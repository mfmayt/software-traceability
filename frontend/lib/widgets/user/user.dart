class User {
  final String id;
  final String name;
  final String password;
  final String email;
  final String accessToken;
  final String role;

  User({this.id, this.name, this.password, this.email, this.accessToken, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      password: json['password'],
      email: json['email'],
      accessToken: json['accessToken'],
      role: json['role'],
    );
  }

}