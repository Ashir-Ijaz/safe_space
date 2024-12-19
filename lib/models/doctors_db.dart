import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorsDb {
  String name;
  String username;
  String specialization;
  String qualification;
  String bio;
  String email;
  int age;
  String sex;
  String uid;
  List<String>? availableDays; // New field for selected days
  String? startTime; // New field for start time
  String? endTime; // New field for end time

  DoctorsDb({
    required this.name,
    required this.username,
    required this.specialization,
    required this.qualification,
    required this.bio,
    required this.email,
    required this.age,
    required this.sex,
    required this.uid,
    this.availableDays,
    this.startTime,
    this.endTime,
  });

  factory DoctorsDb.fromJson(Map<String, Object?> json) {
    return DoctorsDb(
      name: json['name'] as String,
      username: json['username'] as String,
      specialization: json['specialization'] as String,
      qualification: json['qualification'] as String,
      bio: json['bio'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
      sex: json['sex'] as String,
      uid: json['uid'] as String,
      availableDays: (json['availableDays'] as List<dynamic>?)?.cast<String>(),
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
    );
  }

  DoctorsDb copywith({
    String? name,
    String? username,
    String? specialization,
    String? qualification,
    String? bio,
    String? email,
    int? age,
    String? sex,
    String? uid,
    List<String>? availableDays,
    String? startTime,
    String? endTime,
  }) {
    return DoctorsDb(
      name: name ?? this.name,
      username: username ?? this.username,
      specialization: specialization ?? this.specialization,
      qualification: qualification ?? this.qualification,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      uid: uid ?? this.uid,
      availableDays: availableDays ?? this.availableDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'username': username,
      'specialization': specialization,
      'qualification': qualification,
      'bio': bio,
      'email': email,
      'age': age,
      'sex': sex,
      'uid': uid,
      'availableDays': availableDays, // Store as list of selected days
      'startTime': startTime, // Store start time as string (e.g., '09:00')
      'endTime': endTime, // Store end time as string (e.g., '17:00')
    };
  }

  Future<void> checkAndSaveProfile() async {
    try {
      final docRef = FirebaseFirestore.instance.collection('doctors').doc(uid);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update(toJson());
        print('Profile updated successfully!');
      } else {
        await docRef.set(toJson());
        print('Profile created successfully!');
      }
    } catch (e) {
      print('Error saving/updating profile: $e');
    }
  }
}
