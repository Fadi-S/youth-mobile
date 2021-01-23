import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youth_app/pages/home.dart';
import 'package:youth_app/pages/login.dart';
import 'package:youth_app/pages/task.dart';
import 'package:youth_app/utils/Cache.dart';
import 'package:youth_app/utils/Request.dart';
import 'package:youth_app/data/User.dart';
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
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Color.fromRGBO(139, 186, 106, 0.8),
      ),
      routes: <String, WidgetBuilder> {
        LoginPage.ROUTE: (BuildContext context) => LoginPage(),
        HomePage.ROUTE: (BuildContext context) => HomePage(),
        TaskPage.ROUTE: (BuildContext context) => TaskPage(),
      },
      home: Provider.of<User>(context).empty ? LoginPage() : HomePage(),
    );
  }
}

