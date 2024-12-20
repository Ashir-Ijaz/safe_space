import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_space/models/patients_db.dart';
import 'package:safe_space/models/humanappointment_db.dart';
import 'package:intl/intl.dart';

class BookAppointmentPage extends StatefulWidget {
  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers
  final TextEditingController _appointmentTimeController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _reasonForVisitController =
      TextEditingController();

  // State Variables
  String? selectedDoctorUid;
  String? selectedDoctorName;
  String? appointmentType;
  String? urgencyLevel;

  List<Map<String, dynamic>> doctors = [];
  final List<String> appointmentTypes = ['General', 'Specialist', 'Emergency'];
  final List<String> urgencyLevels = ['Normal', 'Urgent', 'Critical'];

  @override
  void dispose() {
    _appointmentTimeController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _reasonForVisitController.dispose();
    super.dispose();
  }

  // Fetch Doctors
  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('doctors').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching doctors: $e");
      return [];
    }
  }

  // Fetch Patient Profile
  Future<PatientsDb> fetchProfile(String uid) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('humanpatients')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return PatientsDb.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        throw Exception('Profile not found.');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  // Check Slot Availability
  // Future<bool> checkAvailability(
  //     String doctorUid, DateTime appointmentTime) async {
  //   try {
  //     return await HumanAppointmentDb.checkAppointmentSlotAvailability(
  //         doctorUid, appointmentTime);
  //   } catch (e) {
  //     print('Error checking slot availability: $e');
  //     return false;
  //   }
  // }

  // Create Dropdown
  Widget buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
  }) {
    return DropdownButton<T>(
      hint: Text(hint),
      value: value,
      onChanged: onChanged,
      isExpanded: true,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
    );
  }

  // Book Appointment
  // Future<void> bookAppointment(PatientsDb patient) async {
  //   try {
  //     final doctorUid = selectedDoctorUid!;
  //     final appointmentTime = DateTime.parse(_appointmentTimeController.text);
  //     final phoneNumber = _phoneNumberController.text.trim();
  //     final address = _addressController.text.trim();
  //     final reason = _reasonForVisitController.text.trim().isNotEmpty
  //         ? _reasonForVisitController.text.trim()
  //         : 'Checkup';
  //     final appointmentTypeSelected = appointmentType ?? 'General';
  //     final urgency = urgencyLevel ?? 'Normal';
  //     final doctorPreference = selectedDoctorName ?? 'None';

  //     // Validate appointment time
  //     if (appointmentTime.isBefore(DateTime.now())) {
  //       throw Exception('Appointment time must be in the future.');
  //     }

  //     // Check slot availability
  //     bool isAvailable = await checkAvailability(doctorUid, appointmentTime);
  //     if (!isAvailable) {
  //       throw Exception('Selected slot is not available.');
  //     }

  //     // Create the appointment
  //     final appointment = HumanAppointmentDb(
  //       appointmentId:
  //           FirebaseFirestore.instance.collection('humanappointments').doc().id,
  //       doctorUid: doctorUid,
  //       patientUid: patient.uid,
  //       username: patient.username,
  //       email: patient.email,
  //       gender: patient.sex,
  //       phonenumber: phoneNumber,
  //       address: address,
  //       reasonforvisit: reason,
  //       typeofappointment: appointmentTypeSelected,
  //       doctorpreference: doctorPreference,
  //       urgencylevel: urgency,
  //       uid: patient.uid,
  //       appointmentTime: appointmentTime,
  //     );

  //     await appointment.bookAppointment();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Appointment booked successfully')));
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Book Appointment')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return FutureBuilder<PatientsDb>(
      future: fetchProfile(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Book Appointment')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(
                child: Text('Error fetching profile: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final patient = snapshot.data!;

          return Scaffold(
            appBar: AppBar(title: Text('Book Appointment')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient Details
                    Text(
                      'Patient Details',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    SizedBox(height: 10),
                    Text('Name: ${patient.username}',
                        style: TextStyle(fontSize: 16)),
                    Text('Email: ${patient.email}',
                        style: TextStyle(fontSize: 16)),
                    Text('Age: ${patient.age}', style: TextStyle(fontSize: 16)),
                    Text('Gender: ${patient.sex}',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20),

                    // Appointment Details
                    Text(
                      'Appointment Details',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    SizedBox(height: 20),

                    // Doctor Dropdown
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchDoctors(),
                      builder: (context, doctorSnapshot) {
                        if (doctorSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (doctorSnapshot.hasError) {
                          return Text('Error fetching doctors');
                        } else if (doctorSnapshot.hasData) {
                          final doctorList = doctorSnapshot.data!;
                          return buildDropdown<String>(
                            hint: 'Select Doctor',
                            value: selectedDoctorUid,
                            items: doctorList
                                .map((d) => d['uid'] as String)
                                .toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedDoctorUid = newValue;
                                selectedDoctorName = doctorList.firstWhere(
                                    (d) => d['uid'] == newValue)['name'];
                              });
                            },
                          );
                        } else {
                          return Text('No doctors available');
                        }
                      },
                    ),
                    SizedBox(height: 20),

                    // Appointment Time
                    TextField(
                      controller: _appointmentTimeController,
                      decoration: InputDecoration(
                        labelText: 'Appointment Time (yyyy-mm-dd hh:mm)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                    SizedBox(height: 20),

                    // Reason for Visit
                    TextField(
                      controller: _reasonForVisitController,
                      decoration: InputDecoration(
                        labelText: 'Reason for Visit',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Appointment Type Dropdown
                    buildDropdown<String>(
                      hint: 'Select Appointment Type',
                      value: appointmentType,
                      items: appointmentTypes,
                      onChanged: (newValue) {
                        setState(() {
                          appointmentType = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 20),

                    // Urgency Level Dropdown
                    buildDropdown<String>(
                      hint: 'Select Urgency Level',
                      value: urgencyLevel,
                      items: urgencyLevels,
                      onChanged: (newValue) {
                        setState(() {
                          urgencyLevel = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 20),

                    // Phone Number
                    TextField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 20),

                    // Address
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Book Appointment Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('Book Appointment'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(child: Text('No data available')),
          );
        }
      },
    );
  }
}
