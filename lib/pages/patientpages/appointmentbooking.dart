import 'package:flutter/material.dart';
import 'package:safe_space/models/appointment_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class PatientInfoScreen extends StatefulWidget {
  const PatientInfoScreen({super.key});

  @override
  _PatientInfoScreenState createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();

  String _gender = 'Male';
  String _appointmentType = 'General Checkup';
  String _doctorPreference = 'Dr. John Doe';
  String _urgencyLevel = 'Normal';

  String generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  Future<bool> doesDocumentExist(String id) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(id)
          .get();
      return doc.exists;
    } catch (e) {
      print('Error checking document existence: $e');
      return false;
    }
  }

  // Future<List<AppointmentDb>> fetchAllAppointments() async {
  //   try {
  //     // Get all documents from the 'appointments' collection
  //     final querySnapshot =
  //         await FirebaseFirestore.instance.collection('appointments').get();

  //     // Map each document into an AppointmentDb object
  //     final appointments = querySnapshot.docs.map((doc) {
  //       return AppointmentDb.fromJson(doc.data());
  //     }).toList();

  //     print('Fetched ${appointments.length} appointments successfully!');
  //     return appointments;
  //   } catch (e) {
  //     print('Failed to fetch appointments: $e');
  //     return [];
  //   }
  // }

  void _submitAppointment() async {
    if (_formKey.currentState?.validate() ?? false) {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final Uid = user.uid;
        final appointment = AppointmentDb(
            username: _nameController.text,
            email: _emailController.text,
            phonenumber: _phoneController.text,
            address: _addressController.text,
            gender: _gender,
            reasonforvisit: _reasonController.text,
            typeofappointment: _appointmentType,
            doctorpreference: _doctorPreference,
            urgencylevel: _urgencyLevel,
            uid: Uid);
        String randomId;
        bool idExists;
        do {
          randomId = generateRandomString(16);
          idExists = await doesDocumentExist(randomId);
        } while (idExists);
        appointment.saveToFirestore(randomId);
        // List<AppointmentDb> appointments = await fetchAllAppointments();
        // for (var appointment in appointments) {
        //   print(
        //       'Appointment for ${appointment.username} with reason: ${appointment.reasonforvisit}');
        // }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Appointment booked successfully!')),
        // );
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment booked successfully!')),
        );

        // Clear the form
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Auth service not getting current user......')),
        );
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _dobController.clear();
    _phoneController.clear();
    _emailController.clear();
    _addressController.clear();
    _reasonController.clear();
    setState(() {
      _gender = 'Male';
      _appointmentType = 'General Checkup';
      _doctorPreference = 'Dr. John Doe';
      _urgencyLevel = 'Normal';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Patient Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _dobController,
                  decoration: const InputDecoration(labelText: 'Date of Birth'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dobController.text =
                            '${pickedDate.toLocal()}'.split(' ')[0];
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your date of birth';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: ['Male', 'Female', 'Other']
                      .map((label) => DropdownMenuItem<String>(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value ?? 'Male';
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _addressController,
                  decoration:
                      const InputDecoration(labelText: 'Address (Optional)'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Appointment Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _reasonController,
                  decoration:
                      const InputDecoration(labelText: 'Reason for Visit'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _appointmentType,
                  decoration:
                      const InputDecoration(labelText: 'Type of Appointment'),
                  items: [
                    'General Checkup',
                    'Specialist Consultation',
                    'Emergency',
                    'Follow-up',
                    'Other'
                  ]
                      .map((label) => DropdownMenuItem<String>(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _appointmentType = value ?? 'General Checkup';
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _doctorPreference,
                  decoration:
                      const InputDecoration(labelText: 'Doctor Preference'),
                  items: ['Dr. John Doe', 'Dr. Jane Smith', 'Dr. Emily Brown']
                      .map((label) => DropdownMenuItem<String>(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _doctorPreference = value ?? 'Dr. John Doe';
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _urgencyLevel,
                  decoration: const InputDecoration(labelText: 'Urgency Level'),
                  items: ['Normal', 'Urgent', 'Emergency']
                      .map((label) => DropdownMenuItem<String>(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _urgencyLevel = value ?? 'Normal';
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitAppointment,
                  child: const Text('Submit Appointment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: const PatientInfoScreen(),
// //     );
// //   }
// // }

// class PatientInfoScreen extends StatefulWidget {
//   const PatientInfoScreen({super.key});

//   @override
//   _PatientInfoScreenState createState() => _PatientInfoScreenState();
// }

// class _PatientInfoScreenState extends State<PatientInfoScreen> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _dobController = TextEditingController();
//   TextEditingController _phoneController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _addressController = TextEditingController();
//   String _gender = 'Male';
//   String _appointmentType = 'General Checkup';
//   String _doctorPreference = 'Dr. John Doe';
//   String _reasonForVisit = '';
//   String _urgencyLevel = 'Normal';
//   DateTime? _preferredDate;
//   String _preferredTime = '9:00 AM';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Appointment Booking'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Patient Information Section
//                 const Text('Patient Information',
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),

//                 TextFormField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(labelText: 'Full Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 10),

//                 TextFormField(
//                   controller: _dobController,
//                   decoration: const InputDecoration(labelText: 'Date of Birth'),
//                   readOnly: true,
//                   onTap: () async {
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime.now(),
//                     );
//                     if (pickedDate != null) {
//                       setState(() {
//                         _preferredDate = pickedDate;
//                         _dobController.text = '${pickedDate.toLocal()}'
//                             .split(' ')[0]; // Show date in format yyyy-mm-dd
//                       });
//                     }
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please select your date of birth';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 10),

//                 DropdownButtonFormField<String>(
//                   value: _gender,
//                   decoration: const InputDecoration(labelText: 'Gender'),
//                   items: ['Male', 'Female', 'Other']
//                       .map((label) => DropdownMenuItem<String>(
//                             value: label,
//                             child: Text(label),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _gender = value ?? 'Male';
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 10),

//                 TextFormField(
//                   controller: _phoneController,
//                   decoration: const InputDecoration(labelText: 'Phone Number'),
//                   keyboardType: TextInputType.phone,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your phone number';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 10),

//                 TextFormField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(labelText: 'Email Address'),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email address';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 10),

//                 TextFormField(
//                   controller: _addressController,
//                   decoration:
//                       const InputDecoration(labelText: 'Address (Optional)'),
//                 ),
//                 const SizedBox(height: 20),

//                 // Appointment Details Section
//                 const Text('Appointment Details',
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),

//                 TextFormField(
//                   decoration:
//                       const InputDecoration(labelText: 'Reason for Visit'),
//                   onChanged: (value) {
//                     setState(() {
//                       _reasonForVisit = value;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 10),

//                 DropdownButtonFormField<String>(
//                   value: _appointmentType,
//                   decoration:
//                       const InputDecoration(labelText: 'Type of Appointment'),
//                   items: [
//                     'General Checkup',
//                     'Specialist Consultation',
//                     'Emergency',
//                     'Follow-up',
//                     'Other'
//                   ]
//                       .map((label) => DropdownMenuItem<String>(
//                             value: label,
//                             child: Text(label),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _appointmentType = value ?? 'General Checkup';
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 10),

//                 DropdownButtonFormField<String>(
//                   value: _doctorPreference,
//                   decoration:
//                       const InputDecoration(labelText: 'Doctor Preference'),
//                   items: ['Dr. John Doe', 'Dr. Jane Smith', 'Dr. Emily Brown']
//                       .map((label) => DropdownMenuItem<String>(
//                             value: label,
//                             child: Text(label),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _doctorPreference = value ?? 'Dr. John Doe';
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 10),

//                 DropdownButtonFormField<String>(
//                   value: _urgencyLevel,
//                   decoration: const InputDecoration(labelText: 'Urgency Level'),
//                   items: ['Normal', 'Urgent', 'Emergency']
//                       .map((label) => DropdownMenuItem<String>(
//                             value: label,
//                             child: Text(label),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _urgencyLevel = value ?? 'Normal';
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // Appointment Confirmation Section
//                 const Text('Appointment Confirmation',
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),

//                 // Review Appointment Summary
//                 Text('Full Name: ${_nameController.text}'),
//                 Text('DOB: ${_dobController.text}'),
//                 Text('Gender: $_gender'),
//                 Text('Phone: ${_phoneController.text}'),
//                 Text('Email: ${_emailController.text}'),
//                 Text('Address: ${_addressController.text}'),
//                 Text('Appointment Type: $_appointmentType'),
//                 Text('Doctor: $_doctorPreference'),
//                 Text('Urgency Level: $_urgencyLevel'),
//                 Text('Reason for Visit: $_reasonForVisit'),
//                 Text('Preferred Date: ${_preferredDate?.toLocal()}'),
//                 Text('Preferred Time: $_preferredTime'),
//                 const SizedBox(height: 20),

//                 // Terms and Conditions
//                 Row(
//                   children: [
//                     Checkbox(
//                       value: true,
//                       onChanged: (value) {},
//                     ),
//                     const Text('I agree to the Terms and Conditions'),
//                   ],
//                 ),
//                 const SizedBox(height: 20),

//                 // Confirm Appointment Button
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState?.validate() ?? false) {
//                       // Appointment Confirmed
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                           content: Text('Appointment Confirmed')));
//                     }
//                   },
//                   child: const Text('Confirm Appointment'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
