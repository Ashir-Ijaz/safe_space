// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:safe_space/models/doctors_db.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:safe_space/models/appointment_db_service.dart';

// class EditPageDoctor extends StatefulWidget {
//   @override
//   _EditPageDoctorState createState() => _EditPageDoctorState();
// }

// class _EditPageDoctorState extends State<EditPageDoctor> {
//   final User? user = FirebaseAuth.instance.currentUser;
//   final _formKey = GlobalKey<FormState>();

//   // Controllers for TextFormFields
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _specializationController =
//       TextEditingController();
//   final TextEditingController _qualificationController =
//       TextEditingController();
//   final TextEditingController _bioController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _sexController = TextEditingController();
//   // New TextEditingControllers for additional fields
//   final TextEditingController _phoneNumberController = TextEditingController();
//   final TextEditingController _clinicNameController = TextEditingController();
//   final TextEditingController _contactNumberClinicController =
//       TextEditingController();
//   final TextEditingController _feesController = TextEditingController();
//   final TextEditingController _doctorTypeController = TextEditingController();
//   //String _doctorType = "Human"; // Default value for the dropdown
//   final TextEditingController _experienceController = TextEditingController();

//   // Variables for availability
//   final Map<String, bool> _selectedDays = {
//     'Monday': false,
//     'Tuesday': false,
//     'Wednesday': false,
//     'Thursday': false,
//     'Friday': false,
//     'Saturday': false,
//     'Sunday': false,
//   };

//   TimeOfDay? _startTime;
//   TimeOfDay? _endTime;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _usernameController.dispose();
//     _bioController.dispose();
//     _ageController.dispose();
//     _sexController.dispose();
//     _specializationController.dispose();
//     _qualificationController.dispose();
//     _phoneNumberController.dispose();
//     _clinicNameController.dispose();
//     _contactNumberClinicController.dispose();
//     _feesController.dispose();
//     _experienceController.dispose();
//     _doctorTypeController.dispose();
//     super.dispose();
//   }

//   Future<Map<String, dynamic>> fetchProfile(String uid) async {
//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('doctors')
//           .where('uid', isEqualTo: uid)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         return querySnapshot.docs.first.data() as Map<String, dynamic>;
//       } else {
//         throw Exception('Profile not found.');
//       }
//     } catch (e) {
//       throw Exception('Error fetching profile: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Fetch user data and populate controllers
//     if (user != null) {
//       fetchProfile(user!.uid).then((data) {
//         setState(() {
//           _nameController.text = data['name'] ?? '';
//           _usernameController.text = data['username'] ?? '';
//           _ageController.text = data['age']?.toString() ?? '';
//           _sexController.text = data['sex'] ?? '';
//           _bioController.text = data['bio'] ?? '';
//           _specializationController.text = data['specialization'] ?? '';
//           _qualificationController.text = data['qualification'] ?? '';
//           _phoneNumberController.text = data['phoneNumber'] ?? '';
//           _clinicNameController.text = data['clinicName'] ?? '';
//           _contactNumberClinicController.text =
//               data['contactNumberClinic'] ?? '';
//           _feesController.text = data['fees']?.toString() ?? '';
//           _doctorTypeController.text = data['doctorType'] ?? 'Human';
//           _experienceController.text = data['experience'] ?? '';
//         });
//       }).catchError((error) {
//         print('Error fetching profile: $error');
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Name Field
//                 _buildTextField('Name', _nameController, 'Enter your name'),

//                 // Username Field
//                 _buildTextField(
//                     'Username', _usernameController, 'Enter your username'),

//                 // Specialization Field
//                 _buildDropdown('Specialization', _specializationController, [
//                   'Psychiatrist',
//                   'Cardiologist',
//                   'Dermatologist',
//                   'Neurologist',
//                   'Pediatrician',
//                   'Orthopedic',
//                   'Gynecologist',
//                   'Radiologist',
//                 ]),

//                 // Qualification Field
//                 _buildDropdown('Qualification', _qualificationController, [
//                   'MBBS',
//                   'MD',
//                   'MS',
//                   'DNB',
//                   'MCh',
//                   'DM',
//                   'Fellowship in Cardiology',
//                   'Fellowship in Dermatology',
//                   'Fellowship in Neurology',
//                 ]),

//                 // Bio Field
//                 _buildTextField(
//                     'Bio', _bioController, 'Tell something about yourself',
//                     isMultiline: true),

//                 // Age Field
//                 _buildTextField('Age', _ageController, 'Enter your age'),

//                 // Sex Field
//                 _buildDropdown('Sex', _sexController, ['Male', 'Female']),

//                 // Available Days Field
//                 _buildAvailableDaysField(context),

//                 // New Fields
//                 _buildTextField('Phone Number', _phoneNumberController,
//                     'Enter your phone number'),
//                 _buildTextField(
//                     'Clinic Name', _clinicNameController, 'Enter clinic name'),
//                 _buildTextField(
//                     'Clinic Contact Number',
//                     _contactNumberClinicController,
//                     'Enter clinic contact number'),
//                 _buildTextField('Consultation Fees', _feesController,
//                     'Enter consultation fees'),
//                 _buildDropdown('Doctor Type', _doctorTypeController,
//                     ['Human', 'Veterinary']),

//                 _buildTextField(
//                     'Experience', _experienceController, 'Years of experience'),

//                 // Time Fields
//                 _buildTimeSelector('Start Time', () async {
//                   TimeOfDay? pickedTime = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (pickedTime != null) {
//                     setState(() {
//                       _startTime = pickedTime;
//                     });
//                   }
//                 }, _startTime),

//                 _buildTimeSelector('End Time', () async {
//                   TimeOfDay? pickedTime = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (pickedTime != null) {
//                     setState(() {
//                       _endTime = pickedTime;
//                     });
//                   }
//                 }, _endTime),

//                 SizedBox(height: 40),

//                 // Save Button
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (_formKey.currentState?.validate() ?? false) {
//                         final User? user = FirebaseAuth.instance.currentUser;
//                         if (user != null) {
//                           // Convert TimeOfDay to String
//                           String? startTimeString = _startTime?.format(context);
//                           String? endTimeString = _endTime?.format(context);

//                           // Convert Map<String, bool> to List<String>
//                           List<String> selectedDaysList = _selectedDays.entries
//                               .where((entry) => entry.value)
//                               .map((entry) => entry.key)
//                               .toList();

//                           // Create the DoctorsDb object with the selected schedule details
//                           final patientProfile = DoctorsDb(
//                             name: _nameController.text,
//                             username: _usernameController.text,
//                             sex: _sexController.text,
//                             email: user.email ?? '',
//                             qualification: _qualificationController.text,
//                             specialization: _specializationController.text,
//                             bio: _bioController.text,
//                             age: int.tryParse(_ageController.text) ?? 0,
//                             uid: user.uid,
//                             phonenumber: _phoneNumberController.text,
//                             clinicName: _clinicNameController.text,
//                             contactNumberClinic:
//                                 _contactNumberClinicController.text,
//                             fees: double.tryParse(_feesController.text) ?? 0.0,
//                             doctorType: _doctorTypeController.text,
//                             experience: _experienceController.text,
//                             availableDays:
//                                 selectedDaysList, // Pass selected days as List<String>
//                             startTime:
//                                 startTimeString, // Pass the formatted start time string
//                             endTime:
//                                 endTimeString, // Pass the formatted end time string
//                           );

//                           final service = DatabaseService(
//                               uid: user.uid,
//                               startTime: startTimeString.toString(),
//                               endTime: endTimeString.toString(),
//                               availableDays: selectedDaysList);

//                           await service.saveSlotsToFirestore();

//                           await patientProfile.checkAndSaveProfile();
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                                 content: Text('Profile Updated Successfully')),
//                           );
//                           Navigator.pop(context);
//                         }
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Text(
//                       'Save',
//                       style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper method to build text fields
//   Widget _buildTextField(
//       String label, TextEditingController controller, String hint,
//       {bool isMultiline = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: _fieldLabelStyle()),
//         SizedBox(height: 5),
//         TextFormField(
//           controller: controller,
//           decoration: _inputDecoration(hint),
//           maxLines: isMultiline ? 2 : 1,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter your $label';
//             }
//             return null;
//           },
//         ),
//         SizedBox(height: 20),
//       ],
//     );
//   }

//   // Helper method to build dropdown fields
//   Widget _buildDropdown(
//       String label, TextEditingController controller, List<String> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: _fieldLabelStyle()),
//         SizedBox(height: 5),
//         DropdownButtonFormField<String>(
//           value: controller.text.isNotEmpty ? controller.text : null,
//           decoration: _inputDecoration('Select your $label'),
//           items: items.map((item) {
//             return DropdownMenuItem<String>(value: item, child: Text(item));
//           }).toList(),
//           onChanged: (value) {
//             if (value != null) {
//               controller.text = value;
//             }
//           },
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please select your $label';
//             }
//             return null;
//           },
//         ),
//         SizedBox(height: 20),
//       ],
//     );
//   }

//   // Helper method to build available days field
//   Widget _buildAvailableDaysField(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Available Days', style: _fieldLabelStyle()),
//         GestureDetector(
//           onTap: () async {
//             // Open a dialog to select multiple days
//             await showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 Map<String, bool> tempSelectedDays = Map.from(_selectedDays);

//                 return AlertDialog(
//                   title: Text('Select Available Days'),
//                   content: SingleChildScrollView(
//                     child: Column(
//                       children: tempSelectedDays.entries.map((entry) {
//                         return StatefulBuilder(
//                           builder: (context, setStateDialog) {
//                             return CheckboxListTile(
//                               title: Text(entry.key),
//                               value: entry.value,
//                               onChanged: (bool? value) {
//                                 setStateDialog(() {
//                                   tempSelectedDays[entry.key] = value ?? false;
//                                 });
//                               },
//                             );
//                           },
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                   actions: [
//                     TextButton(
//                       child: Text('Cancel'),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     TextButton(
//                       child: Text('Save'),
//                       onPressed: () {
//                         setState(() {
//                           _selectedDays.clear();
//                           _selectedDays.addAll(tempSelectedDays);
//                         });
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//             decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(8)),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     _selectedDays.entries
//                             .where((entry) => entry.value)
//                             .map((entry) => entry.key)
//                             .join(', ') ??
//                         'Select Days',
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 Icon(Icons.arrow_drop_down),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: 20),
//       ],
//     );
//   }

//   // Helper method to build time selector
//   Widget _buildTimeSelector(
//       String label, Function onTap, TimeOfDay? selectedTime) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: _fieldLabelStyle()),
//         GestureDetector(
//           onTap: () => onTap(),
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//             decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(8)),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     selectedTime != null
//                         ? selectedTime.format(context)
//                         : 'Select Time',
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 Icon(Icons.access_time),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: 20),
//       ],
//     );
//   }

//   // Helper method for consistent input decoration
//   InputDecoration _inputDecoration(String hint) {
//     return InputDecoration(
//       contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       hintText: hint,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//     );
//   }

//   // Helper method for consistent field label style
//   TextStyle _fieldLabelStyle() {
//     return TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_space/models/doctors_db.dart';
import 'package:safe_space/models/appointment_db_service.dart';

class EditPageDoctor extends StatefulWidget {
  @override
  _EditPageDoctorState createState() => _EditPageDoctorState();
}

class _EditPageDoctorState extends State<EditPageDoctor> {
  final User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _qualificationController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _clinicNameController = TextEditingController();
  final TextEditingController _contactNumberClinicController =
      TextEditingController();
  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _doctorTypeController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  final Map<String, bool> _selectedDays = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _ageController.dispose();
    _sexController.dispose();
    _specializationController.dispose();
    _qualificationController.dispose();
    _phoneNumberController.dispose();
    _clinicNameController.dispose();
    _contactNumberClinicController.dispose();
    _feesController.dispose();
    _experienceController.dispose();
    _doctorTypeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (user != null) {
      fetchProfile(user!.uid).then((data) {
        setState(() {
          _nameController.text = data['name'] ?? '';
          _usernameController.text = data['username'] ?? '';
          _ageController.text = data['age']?.toString() ?? '';
          _sexController.text = data['gender'] ?? '';
          _bioController.text = data['bio'] ?? '';
          _specializationController.text = data['specialization'] ?? '';
          _qualificationController.text = data['qualification'] ?? '';
          _phoneNumberController.text = data['phoneNumber'] ?? '';
          _clinicNameController.text = data['clinicName'] ?? '';
          _contactNumberClinicController.text =
              data['contactNumberClinic'] ?? '';
          _feesController.text = data['fees']?.toString() ?? '';
          _doctorTypeController.text = data['doctorType'] ?? 'Human';
          _experienceController.text = data['experience'] ?? '';
        });
      }).catchError((error) {
        print('Error fetching profile: $error');
      });
    }
  }

  Future<Map<String, dynamic>> fetchProfile(String uid) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        throw Exception('Profile not found.');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildSectionHeader('Personal Details'),
                _buildCard([
                  _buildTextField('Name', _nameController, 'Enter your name'),
                  _buildTextField(
                      'Username', _usernameController, 'Enter your username'),
                  _buildTextField(
                      'Bio', _bioController, 'Tell something about yourself',
                      isMultiline: true),
                  _buildTextField('Age', _ageController, 'Enter your age'),
                  _buildDropdown('Gender', _sexController, ['Male', 'Female']),
                ]),
                _buildSectionHeader('Professional Details'),
                _buildCard([
                  _buildDropdown('Specialization', _specializationController, [
                    'Psychiatrist',
                    'Cardiologist',
                    'Dermatologist',
                    'Neurologist',
                    'Pediatrician',
                    'Orthopedic',
                    'Gynecologist',
                    'Radiologist'
                  ]),
                  _buildDropdown('Qualification', _qualificationController, [
                    'MBBS',
                    'MD',
                    'MS',
                    'DNB',
                    'MCh',
                    'DM',
                    'Fellowship in Cardiology',
                    'Fellowship in Dermatology',
                    'Fellowship in Neurology'
                  ]),
                  _buildDropdown('Doctor Type', _doctorTypeController,
                      ['Human', 'Veterinary']),
                  _buildTextField('Experience', _experienceController,
                      'Years of experience'),
                  _buildTextField('Clinic Name', _clinicNameController,
                      'Enter clinic name'),
                  _buildTextField('Consultation Fees', _feesController,
                      'Enter consultation fees'),
                ]),
                _buildSectionHeader('Availability'),
                _buildCard([
                  _buildAvailableDaysField(context),
                  _buildTimeSelector('Start Time', _startTime),
                  _buildTimeSelector('End Time', _endTime),
                ]),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Save',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hint,
      {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        maxLines: isMultiline ? 3 : 1,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String label, TextEditingController controller, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: DropdownButtonFormField<String>(
        value: controller.text.isNotEmpty ? controller.text : null,
        onChanged: (value) => setState(() => controller.text = value ?? ''),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
      ),
    );
  }

  // Widget _buildAvailableDaysField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: _selectedDays.keys.map((day) {
  //       return CheckboxListTile(
  //         title: Text(day),
  //         value: _selectedDays[day],
  //         onChanged: (bool? value) {
  //           setState(() {
  //             _selectedDays[day] = value ?? false;
  //           });
  //         },
  //       );
  //     }).toList(),
  //   );
  // }

  Widget _buildTimeSelector(String label, TimeOfDay? time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ElevatedButton(
            onPressed: () => _selectTime(label),
            child: Text(time != null ? time.format(context) : 'Select Time'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(String label) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        if (label == 'Start Time') {
          _startTime = selectedTime;
        } else {
          _endTime = selectedTime;
        }
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Save data to Firebase or perform other actions
    }
  }

  Widget _buildAvailableDaysField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Available Days', style: _fieldLabelStyle()),
        GestureDetector(
          onTap: () async {
            // Open a dialog to select multiple days
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                Map<String, bool> tempSelectedDays = Map.from(_selectedDays);

                return AlertDialog(
                  title: Text('Select Available Days'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: tempSelectedDays.entries.map((entry) {
                        return StatefulBuilder(
                          builder: (context, setStateDialog) {
                            return CheckboxListTile(
                              title: Text(entry.key),
                              value: entry.value,
                              onChanged: (bool? value) {
                                setStateDialog(() {
                                  tempSelectedDays[entry.key] = value ?? false;
                                });
                              },
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text('Save'),
                      onPressed: () {
                        setState(() {
                          _selectedDays.clear();
                          _selectedDays.addAll(tempSelectedDays);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDays.entries
                            .where((entry) => entry.value)
                            .map((entry) => entry.key)
                            .join(', ') ??
                        'Select Days',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  TextStyle _fieldLabelStyle() {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }
}
