import 'package:cloud_firestore/cloud_firestore.dart';

class UsersDb {
  String username;
  String emaill; // Consider renaming to 'email' for consistency
  String password;
  String usertype;

  // Constructor
  UsersDb({
    required this.username,
    required this.emaill,
    required this.password,
    required this.usertype,
  });

  // Factory constructor for creating an instance from JSON
  factory UsersDb.fromJson(Map<String, Object?> json) {
    return UsersDb(
      username: json['username'] as String,
      emaill: json['email'] as String,
      password: json['password'] as String,
      usertype: json['usertype'] as String,
    );
  }

  UsersDb copywith(
      {String? username, String? emaill, String? password, String? usertype}) {
    return UsersDb(
        username: username ?? this.username,
        emaill: emaill ?? this.emaill,
        password: password ?? this.password,
        usertype: usertype ?? this.usertype);
  }

  // Method for converting an instance to JSON (optional, but useful for Firestore)
  Map<String, Object?> toJson() {
    return {
      'username': username,
      'email': emaill,
      'password': password,
      'usertype': usertype,
    };
  }
}