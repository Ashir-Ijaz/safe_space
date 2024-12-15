import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class PatientsDb {
  String name;
  String username;
  Int age;
  String sex;
  String email;
  String uid;

  PatientsDb({
    required this.name,
    required this.username,
    required this.age,
    required this.sex,
    required this.email,
    required this.uid,
  });

  factory PatientsDb.fromJson(Map<String, Object?> json) {
    return PatientsDb(
        name: json['name'] as String,
        username: json['username'] as String,
        age: json['age'] as Int,
        sex: json['sex'] as String,
        email: json['email'] as String,
        uid: json['uid'] as String);
  }

  PatientsDb copywith({
    String? name,
    String? username,
    Int? age,
    String? sex,
    String? email,
    String? uid,
  }) {
    return PatientsDb(
      name: name ?? this.name,
      username: username ?? this.username,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      email: email ?? this.email,
      uid: uid ?? this.uid,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'username': username,
      'age': age,
      'sex': sex,
      'email': email,
      'uid': uid,
    };
  }

  Future<void> saveToFirestore(String name) async {
    try {
      final collection =
          FirebaseFirestore.instance.collection('patients').doc(name);
      await collection.set(toJson());
      print('patient profile saved successfully!');
    } catch (e) {
      print('Failed to save patient profile: $e');
    }
  }
}
