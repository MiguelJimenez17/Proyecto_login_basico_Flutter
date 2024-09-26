class User {
  String email;
  String password;

  User({required this.email, required this.password});

  Map<String, String> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, String> map) {
    return User(
      email: map['email']!,
      password: map['password']!,
    );
  }
}
