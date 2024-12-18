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

  DoctorsDb(
      {required this.name,
      required this.username,
      required this.specialization,
      required this.qualification,
      required this.bio,
      required this.email,
      required this.age,
      required this.sex,
      required this.uid});

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
        uid: json['uid'] as String);
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
    };
  }

  // Future<void> saveToFirestore(String name) async {
  //   try {
  //     final collection =
  //         FirebaseFirestore.instance.collection('doctors').doc(name);
  //     await collection.set(toJson());
  //     print('Doctors saved successfully!');
  //   } catch (e) {
  //     print('Failed to save record: $e');
  //   }
  // }

  Future<void> checkAndSaveProfile() async {
    try {
      // Reference to 'humanpatients' collection
      final docRef = FirebaseFirestore.instance
          .collection('doctors')
          .doc(uid); // Use `uid` as the document ID

      // Check if document exists
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // If document exists, update it
        await docRef.update(toJson());
        print('Profile updated successfully!');
      } else {
        // If document does not exist, create it
        await docRef.set(toJson());
        print('Profile created successfully!');
      }
    } catch (e) {
      print('Error saving/updating profile: $e');
    }
  }
}
