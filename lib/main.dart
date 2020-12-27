import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youth_app/pages/home.dart';
import 'package:youth_app/pages/login.dart';
import 'package:youth_app/utils/Cache.dart';
import 'package:youth_app/utils/Request.dart';
import 'package:youth_app/utils/User.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Cache cache = await Cache.getInstance();

  var userJson = cache.getJSON(User.KEY);

  final User user = (userJson != null) ? User.getInstance(userJson) : User.initializeEmpty();

  if(!user.empty) {
    Request request = Request('/user', token: user.apiToken);
    request.get().then((http.Response response) {
      if (response.statusCode != 200)
        return;

      var userJson = jsonDecode(response.body);
      userJson['api_token'] = user.apiToken;

      cache.setJSON(User.KEY, userJson);

      user.setUserTo(userJson);
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: user),
        Provider<Cache>.value(value: cache),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Youth Meeting',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) => LoginPage(),
        '/home': (BuildContext context) => HomePage(),
      },
      home: Provider.of<User>(context).empty ? LoginPage() : HomePage(),
    );
  }
}

