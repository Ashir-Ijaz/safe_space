import 'package:cloud_firestore/cloud_firestore.dart';

class HumanAppointmentDb {
  String appointmentId;
  String doctorUid;
  String patientUid;
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

  HumanAppointmentDb({
    required this.appointmentId,
    required this.doctorUid,
    required this.patientUid,
    required this.username,
    required this.email,
    required this.gender,
    required this.phonenumber,
    required this.address,
    required this.reasonforvisit,
    required this.typeofappointment,
    required this.doctorpreference,
    required this.urgencylevel,
    required this.uid,
  });

  factory HumanAppointmentDb.fromJson(Map<String, Object?> json) {
    return HumanAppointmentDb(
      appointmentId: json['appointmentId'] as String,
      doctorUid: json['doctorUid'] as String,
      patientUid: json['patientUid'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      phonenumber: json['phonenumber'] as String,
      address: json['address'] as String,
      reasonforvisit: json['reasonforvisit'] as String,
      typeofappointment: json['typeofappointment'] as String,
      doctorpreference: json['doctorpreference'] as String,
      urgencylevel: json['urgencylevel'] as String,
      uid: json['uid'] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'appointmentId': appointmentId,
      'doctorUid': doctorUid,
      'patientUid': patientUid,
      'username': username,
      'email': email,
      'gender': gender,
      'phonenumber': phonenumber,
      'address': address,
      'reasonforvisit': reasonforvisit,
      'typeofappointment': typeofappointment,
      'doctorpreference': doctorpreference,
      'urgencylevel': urgencylevel,
      'uid': uid,
    };
  }
}
  // Method to book an appointment
  // Future<void> bookAppointment() async {
  //   try {
  //     final docRef = FirebaseFirestore.instance
  //         .collection('humanappointments')
  //         .doc(appointmentId);
  //     await docRef.set(toJson());
  //     print('Appointment booked successfully!');
  //   } catch (e) {
  //     print('Error booking appointment: $e');
  //   }
  // }

  // // Method to check if an appointment slot is available
  // static Future<bool> checkAppointmentSlotAvailability(
  //     String doctorUid, DateTime appointmentTime) async {
  //   // Ensure the time is a whole hour (e.g., no half-past times)
  //   final startOfSlot = DateTime(appointmentTime.year, appointmentTime.month,
  //       appointmentTime.day, appointmentTime.hour);
  //   final endOfSlot = startOfSlot.add(Duration(hours: 1));

  //   try {
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('humanappointments')
  //         .where('doctorUid', isEqualTo: doctorUid)
  //         .where('appointmentTime', isGreaterThanOrEqualTo: startOfSlot)
  //         .where('appointmentTime', isLessThan: endOfSlot)
  //         .get();

  //     return querySnapshot.docs.isEmpty;
  //   } catch (e) {
  //     print('Error checking appointment availability: $e');
  //     return false; // In case of error, assume the slot is unavailable
  //   }
  // }

