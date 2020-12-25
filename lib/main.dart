import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youth_app/pages/home.dart';
import 'package:youth_app/pages/login.dart';
import 'package:youth_app/utils/Cache.dart';
import 'package:youth_app/utils/User.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Cache cache = await Cache.getInstance();

  var userJson = cache.getJSON('user');

  final User user = (userJson != null) ? User.getInstance(userJson) : null;

  runApp(
    MultiProvider(
      providers: [
        Provider<User>.value(value: user),
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
      home: Consumer<User>(
        builder: (BuildContext context, User user, child) {
          return (user == null) ? LoginPage() : HomePage();
        },
      ),
    );
  }
}

