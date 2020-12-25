import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:youth_app/pages/register.dart';
import 'package:youth_app/utils/Cache.dart';
import 'package:youth_app/utils/Request.dart';
import 'package:youth_app/utils/User.dart';
import 'package:youth_app/widget/fancy_button.dart';
import 'package:youth_app/widget/fancy_text_field.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool _isLoginPressed = false;
  String _error = "";

  void _login() async {

    if(!await Request.isNetworkAvailable()) {
      _respond(error: "You have no internet connection");
      return;
    }

    String email = emailController.text;
    String password = passwordController.text;
    setState(() {
      _error = "";
      _isLoginPressed = true;
    });

    var request = new Request('/login');

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var model = '';
    if(Platform.isAndroid)
      model = (await deviceInfo.androidInfo).model;
    else
      model = (await deviceInfo.iosInfo).name;

    http.Response response = await request.post({'email': email, 'password': password, 'device_name': model});

    if(response.statusCode != 200) {
      _respond(error: 'Wrong email or password');

      return;
    }
    var userJSON = jsonDecode(response.body);

    User user = User.getInstance(userJSON);

    Provider.of<Cache>(context, listen: false).setJSON('user', userJSON);

    Provider.of<User>(context, listen: false);

    _respond();
  }

  void _respond({String error}) {
    setState(() {
      _error = error ?? '';
      _isLoginPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[

            FancyTextField(
              controller: emailController,
              enabled: !_isLoginPressed,
              keyboardType: TextInputType.text,
              validator: (value) => (value.isEmpty) ? 'Please enter your Email' : null,
              labelText: "Email",
              border: OutlineInputBorder(),
            ),

            FancyTextField(
              controller: passwordController,
              password: true,
              enabled: !_isLoginPressed,
              keyboardType: TextInputType.text,
              validator: (value) => (value.isEmpty) ? 'Please enter your Password' : null,
              labelText: "Password",
              border: OutlineInputBorder(),
            ),

            FancyButton(
              onPressed: (_isLoginPressed) ? null : _login,
              textColor: Colors.white,
              color: Colors.indigo,
              child: Visibility(
                visible: _isLoginPressed,
                child: CircularProgressIndicator(),
                replacement: const Text("SIGN IN"),
              ),
            ),

            /*
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 5),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgetPasswordPage(email: emailController.text)),
                  );
                },
                child: Chip(
                  label: const Text(
                    "Forgot Password ?",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),*/

            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            Text(
              _error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
