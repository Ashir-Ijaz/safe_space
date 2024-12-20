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
  DateTime appointmentTime; // New field for storing appointment time

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
      required this.uid,
      required this.appointmentTime}); // New parameter for appointment time

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
        uid: json['uid'] as String,
        appointmentTime: (json['appointmentTime'] as Timestamp)
            .toDate()); // Convert Firestore Timestamp to DateTime
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
      String? uid,
      DateTime? appointmentTime}) {
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
        uid: uid ?? this.uid,
        appointmentTime:
            appointmentTime ?? this.appointmentTime); // Copying appointmentTime
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
      'uid': uid,
      'appointmentTime':
          Timestamp.fromDate(appointmentTime) // Save as Firestore Timestamp
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

  // Method to check if the appointment time fits within the doctor's available hours
  bool isValidAppointmentTime(
      DateTime doctorStartTime, DateTime doctorEndTime) {
    final appointmentStart = this.appointmentTime;
    final appointmentEnd = appointmentStart
        .add(Duration(hours: 1)); // Assuming the appointment is 1 hour long

    return appointmentStart.isAfter(doctorStartTime) &&
        appointmentEnd.isBefore(doctorEndTime);
  }
}
