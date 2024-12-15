import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentDb {
  String username;
  String email;
  String gender;
  String phonenumber;
  String address;
  String reasonforvisit;
  String typeofappointment;
  String doctorpreference;
  String urgencylevel;
  String uid;

  AppointmentDb(
      {required this.username,
      required this.email,
      required this.phonenumber,
      required this.address,
      required this.doctorpreference,
      required this.gender,
      required this.reasonforvisit,
      required this.typeofappointment,
      required this.urgencylevel,
      required this.uid});

  factory AppointmentDb.fromJson(Map<String, Object?> json) {
    return AppointmentDb(
        username: json['username'] as String,
        email: json['email'] as String,
        phonenumber: json['phonenumber'] as String,
        address: json['address'] as String,
        doctorpreference: json['doctorpreference'] as String,
        gender: json['gender'] as String,
        reasonforvisit: json['reasonforvisit'] as String,
        typeofappointment: json['typeofappointment'] as String,
        urgencylevel: json['urgencylevel'] as String,
        uid: json['uid'] as String);
  }

  AppointmentDb copyWith(
      {String? username,
      String? email,
      String? gender,
      String? phonenumber,
      String? address,
      String? reasonforvisit,
      String? typeofappointment,
      String? doctorpreference,
      String? urgencylevel,
      String? uid}) {
    return AppointmentDb(
        username: username ?? this.username,
        email: email ?? this.email,
        phonenumber: phonenumber ?? this.phonenumber,
        address: address ?? this.address,
        doctorpreference: doctorpreference ?? this.doctorpreference,
        gender: gender ?? this.gender,
        reasonforvisit: reasonforvisit ?? this.reasonforvisit,
        typeofappointment: typeofappointment ?? this.typeofappointment,
        urgencylevel: urgencylevel ?? this.urgencylevel,
        uid: uid ?? this.uid);
  }

  Map<String, Object?> toJson() {
    return {
      'username': username,
      'email': email,
      'phonenumber': phonenumber,
      'address': address,
      'doctorpreference': doctorpreference,
      'gender': gender,
      'reasonforvisit': reasonforvisit,
      'typeofappointment': typeofappointment,
      'urgencylevel': urgencylevel,
      'uid': uid
    };
  }

  Future<void> saveToFirestore(String uid) async {
    try {
      final collection =
          FirebaseFirestore.instance.collection('appointments').doc(uid);
      await collection.set(toJson());
      print('Appointment saved successfully!');
    } catch (e) {
      print('Failed to save appointment: $e');
    }
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';

// class AppointmentDb {
//   String username;
//   String email; // Consider renaming to 'email' for consistency
//   String gender;
//   String phonenumber;
//   String address;
//   String reasonforvisit;
//   String typeofappointment;
//   String doctorpreference;
//   String urgencylevel;

//   AppointmentDb({
//     required this.username,
//     required this.email,
//     required this.phonenumber,
//     required this.address,
//     required this.doctorpreference,
//     required this.gender,
//     required this.reasonforvisit,
//     required this.typeofappointment,
//     required this.urgencylevel,
//   });

//   factory AppointmentDb.fromJson(Map<String, Object?> json) {
//     return AppointmentDb(
//         username: json['username'] as String,
//         email: json['email'] as String,
//         phonenumber: json['phonenumber'] as String,
//         address: json['address'] as String,
//         doctorpreference: json['doctorpreference'] as String,
//         gender: json['gender'] as String,
//         reasonforvisit: json['reasonforvisit'] as String,
//         typeofappointment: json['typeofappointment'] as String,
//         urgencylevel: json['urgencylevel'] as String);
//   }

//   AppointmentDb copywith({
//     String? username,
//     String? email, // Consider renaming to 'email' for consistency
//     String? gender,
//     String? phonenumber,
//     String? address,
//     String? reasonforvisit,
//     String? typeofappointment,
//     String? doctorpreference,
//     String? urgencylevel,
//   }) {
//     return AppointmentDb(
//         username: username ?? this.username,
//         email: email ?? this.email,
//         phonenumber: phonenumber ?? this.phonenumber,
//         address: address ?? this.address,
//         doctorpreference: doctorpreference ?? this.doctorpreference,
//         gender: gender ?? this.gender,
//         reasonforvisit: reasonforvisit ?? this.reasonforvisit,
//         typeofappointment: typeofappointment ?? this.typeofappointment,
//         urgencylevel: urgencylevel ?? this.urgencylevel);
//   }

//   Map<String, Object?> toJson() {
//     return {
//       'username': username,
//       'email': email,
//       'phonenumber': phonenumber,
//       'address': address,
//       'doctorpreference': doctorpreference,
//       'gender': gender,
//       'reasonforvisit': reasonforvisit,
//       'typeofappointment': typeofappointment,
//       'urgencylevel': urgencylevel
//     };
//   }
// }
