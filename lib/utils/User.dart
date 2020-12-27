import 'package:flutter/cupertino.dart';


class User extends ChangeNotifier
{
  static const KEY = "user";

    String name;
    String username;
    String email;
    String apiToken;
    String picture;
    bool empty = false;

    User({this.username, this.apiToken, this.name, this.email, this.picture, this.empty});

    factory User.fromJson(Map<String, dynamic> json) {

      return User(
        name: json['name'],
        email: json['email'],
        username: json['username'],
        apiToken: json['api_token'],
        picture: json['picture'],
        empty: false,
      );
    }

    static User getInstance(json) => User.fromJson(json);

    static User initializeEmpty() => User(empty: true);

    void setUserTo(Map json) {
      this.name = json['name'];
      this.email = json['email'];
      this.username = json['username'];

      if(json['api_token'] != null)
        this.apiToken = json['api_token'];

      this.picture = json['picture'];

      this.empty = false;

      notifyListeners();
    }
}