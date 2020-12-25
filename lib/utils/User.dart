
class User
{
    final String name;
    final String username;
    final String email;
    final String apiToken;
    final String picture;

    User({this.username, this.apiToken, this.name, this.email, this.picture});

    factory User.fromJson(Map<String, dynamic> json) {

      return User(
        name: json['name'],
        email: json['email'],
        username: json['username'],
        apiToken: json['api_token'],
        picture: json['picture'],
      );
    }

    static User getInstance(json) => User.fromJson(json);

    void setUserTo(User user) {

    }
}