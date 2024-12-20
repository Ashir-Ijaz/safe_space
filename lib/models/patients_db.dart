import 'package:cloud_firestore/cloud_firestore.dart';

class PatientsDb {
  String name;
  String username;
  int age; // Fixed 'Int' to 'int' (Dart uses 'int' for integers)
  String sex;
  String email;
  String bloodgroup;
  String uid;

  PatientsDb({
    required this.name,
    required this.username,
    required this.age,
    required this.sex,
    required this.email,
    required this.bloodgroup,
    required this.uid,
  });

  factory PatientsDb.fromJson(Map<String, Object?> json) {
    return PatientsDb(
      name: json['name'] as String,
      username: json['username'] as String,
      age: json['age'] as int, // Fixed 'Int' to 'int'
      sex: json['sex'] as String,
      email: json['email'] as String,
      bloodgroup: json['bloodgroup'] as String,
      uid: json['uid'] as String,
    );
  }

  /// Fetch profile information from Firestore
  // static Future<PatientsDb> fetchProfile(String uid) async {
  //   try {
  //     final docRef = FirebaseFirestore.instance.collection('humanpatients').doc(uid);
  //     final docSnapshot = await docRef.get();

  //     if (docSnapshot.exists) {
  //       return PatientsDb.fromJson(docSnapshot.data() as Map<String, dynamic>);
  //     } else {
  //       throw Exception('Profile not found.');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching profile: $e');
  //   }
  // }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'username': username,
      'age': age,
      'sex': sex,
      'email': email,
      'bloodgroup': bloodgroup,
      'uid': uid,
    };
  }

  /// Check if profile exists and save/update it in Firestore
  Future<void> checkAndSaveProfile() async {
    try {
      // Reference to 'humanpatients' collection
      final docRef = FirebaseFirestore.instance
          .collection('humanpatients')
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
  // /// Fetch profile information from Firestore
  // static Future<PatientsDb> fetchProfile(String uid) async {
  //   try {
  //     final docRef = FirebaseFirestore.instance.collection('humanpatients').doc(uid);
  //     final docSnapshot = await docRef.get();

  //     if (docSnapshot.exists) {
  //       return PatientsDb.fromJson(docSnapshot.data() as Map<String, dynamic>);
  //     } else {
  //       throw Exception('Profile not found.');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching profile: $e');
  //   }
  // }


// import 'dart:ffi';

// import 'package:cloud_firestore/cloud_firestore.dart';

// class PatientsDb {
//   String name;
//   String username;
//   Int age;
//   String sex;
//   String email;
//   String bloodgroup;
//   String uid;

//   PatientsDb({
//     required this.name,
//     required this.username,
//     required this.age,
//     required this.sex,
//     required this.email,
//     required this.bloodgroup,
//     required this.uid,
//   });

//   factory PatientsDb.fromJson(Map<String, Object?> json) {
//     return PatientsDb(
//         name: json['name'] as String,
//         username: json['username'] as String,
//         age: json['age'] as Int,
//         sex: json['sex'] as String,
//         email: json['email'] as String,
//         bloodgroup: json['bloodgroup'] as String,
//         uid: json['uid'] as String);
//   }

//   PatientsDb copywith({
//     String? name,
//     String? username,
//     Int? age,
//     String? sex,
//     String? email,
//     String? bloodgroup,
//     String? uid,
//   }) {
//     return PatientsDb(
//       name: name ?? this.name,
//       username: username ?? this.username,
//       age: age ?? this.age,
//       sex: sex ?? this.sex,
//       email: email ?? this.email,
//       bloodgroup: bloodgroup ?? this.bloodgroup,
//       uid: uid ?? this.uid,
//     );
//   }

//   Map<String, Object?> toJson() {
//     return {
//       'name': name,
//       'username': username,
//       'age': age,
//       'sex': sex,
//       'email': email,
//       'bloodgroup': bloodgroup,
//       'uid': uid,
//     };
//   }

//   Future<void> saveToFirestore(String name) async {
//     try {
//       final collection =
//           FirebaseFirestore.instance.collection('patients').doc(name);
//       await collection.set(toJson());
//       print('patient profile saved successfully!');
//     } catch (e) {
//       print('Failed to save patient profile: $e');
//     }
//   }
// }
