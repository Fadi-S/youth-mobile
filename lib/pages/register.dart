import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:youth_app/pages/login.dart';
import 'package:youth_app/utils/Cache.dart';
import 'package:youth_app/utils/Request.dart';
import 'file:///F:/Projects/youth_app/lib/data/User.dart';
import 'package:youth_app/widget/fancy_button.dart';
import 'package:youth_app/widget/fancy_text_field.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmationController = TextEditingController();

  bool _isRegisterPressed = false;
  String _error = "";

  void _register() async {

    if(!await Request.isNetworkAvailable()) {
      _respond(error: "You have no internet connection");
      return;
    }

    String name = nameController.text;
    String phone = phoneController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String passwordConf = passwordConfirmationController.text;

    setState(() {
      _error = "";
      _isRegisterPressed = true;
    });

    var request = new Request('/register');

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var model = '';
    if(Platform.isAndroid)
      model = (await deviceInfo.androidInfo).model;
    else
      model = (await deviceInfo.iosInfo).name;

    http.Response response = await request.post({
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConf,
      'device_name': model,
      'phone': phone,
    });

    if(response.statusCode != 200) {

      if(response.statusCode == 422) {

        Map<String, dynamic> errors = jsonDecode(response.body)['errors'];

        _respond(error: errors.values.first[0]);

      }else {
        _respond(error: 'Something went wrong');
      }

      return;
    }

    var userJSON = jsonDecode(response.body);

    Provider.of<User>(context, listen: false).setUserTo(userJSON);

    Provider.of<Cache>(context, listen: false).setJSON(User.KEY, userJSON);

    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);

    _respond();
  }

  void _respond({String error}) {
    setState(() {
      _error = error ?? '';
      _isRegisterPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[

            FancyTextField(
              controller: nameController,
              enabled: !_isRegisterPressed,
              keyboardType: TextInputType.text,
              validator: (value) => (value.isEmpty) ? 'Please enter your Name' : null,
              labelText: "Name",
              border: OutlineInputBorder(),
            ),

            FancyTextField(
              controller: emailController,
              enabled: !_isRegisterPressed,
              keyboardType: TextInputType.text,
              validator: (value) => (value.isEmpty) ? 'Please enter your Email' : null,
              labelText: "Email",
              border: OutlineInputBorder(),
            ),

            FancyTextField(
              controller: phoneController,
              enabled: !_isRegisterPressed,
              keyboardType: TextInputType.phone,
              validator: (value) => (value.isEmpty) ? 'Please enter your Number' : null,
              labelText: "Phone Number",
              border: OutlineInputBorder(),
            ),

            FancyTextField(
              controller: passwordController,
              password: true,
              enabled: !_isRegisterPressed,
              keyboardType: TextInputType.text,
              validator: (value) => (value.isEmpty) ? 'Please enter your Password' : null,
              labelText: "Password",
              border: OutlineInputBorder(),
            ),

            FancyTextField(
              controller: passwordConfirmationController,
              password: true,
              enabled: !_isRegisterPressed,
              keyboardType: TextInputType.text,
              validator: (value) => (value.isEmpty) ? 'Please confirm your Password' : null,
              labelText: "Password Confirmation",
              border: OutlineInputBorder(),
            ),

            FancyButton(
              onPressed: (_isRegisterPressed) ? null : _register,
              textColor: Colors.white,
              color: Colors.indigo,
              child: Visibility(
                visible: _isRegisterPressed,
                child: CircularProgressIndicator(),
                replacement: const Text("SIGN UP"),
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
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text(
                  "Already Have an account? Sign In",
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
