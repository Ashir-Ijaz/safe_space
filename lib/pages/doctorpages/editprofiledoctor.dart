// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:safe_space/models/doctors_db.dart';

// class EditPageDoctor extends StatefulWidget {
//   @override
//   _EditPageDoctorState createState() => _EditPageDoctorState();
// }

// class _EditPageDoctorState extends State<EditPageDoctor> {
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
//   final TextEditingController _emailController = TextEditingController();

//   @override
//   void dispose() {
//     // Clean up the controllers when the widget is disposed
//     _nameController.dispose();
//     _usernameController.dispose();
//     _bioController.dispose();
//     _emailController.dispose();
//     _ageController.dispose();
//     _sexController.dispose();
//     _specializationController.dispose();
//     _qualificationController.dispose();
//     super.dispose();
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
//                 Text('Name', style: _fieldLabelStyle()),
//                 SizedBox(height: 5),
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: _inputDecoration('Enter your name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your name';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),

//                 // Username Field
//                 Text('Username', style: _fieldLabelStyle()),
//                 SizedBox(height: 5),
//                 TextFormField(
//                   controller: _usernameController,
//                   decoration: _inputDecoration('Enter your username'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a username';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),

//                 // Specialization Field
//                 Text('Specialization', style: _fieldLabelStyle()),
//                 SizedBox(height: 5),
//                 DropdownButtonFormField<String>(
//                   value: _specializationController.text.isNotEmpty
//                       ? _specializationController.text
//                       : null, // Set initial value if available
//                   decoration: _inputDecoration(
//                       'Select your Specialization'), // Custom input decoration
//                   items: [
//                     'psychiatrist',
//                     'Cardiologist',
//                     'Dermatologist',
//                     'Neurologist',
//                     'Pediatrician',
//                     'Orthopedic',
//                     'Gynecologist',
//                     'Radiologist',
//                   ] // List of Specializations
//                       .map((specialization) => DropdownMenuItem<String>(
//                             value: specialization,
//                             child: Text(specialization),
//                           ))
//                       .toList(), // Convert list to DropdownMenuItems
//                   onChanged: (value) {
//                     if (value != null) {
//                       _specializationController.text =
//                           value; // Update controller text
//                     }
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please select your Specialization';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),

//                 // Qualification Field
//                 Text('Qualification', style: _fieldLabelStyle()),
//                 SizedBox(height: 5),
//                 DropdownButtonFormField<String>(
//                   value: _qualificationController.text.isNotEmpty
//                       ? _qualificationController.text
//                       : null, // Set initial value if available
//                   decoration: _inputDecoration(
//                       'Select your Qualification'), // Custom input decoration
//                   items: [
//                     'MBBS',
//                     'MD',
//                     'MS',
//                     'DNB',
//                     'MCh',
//                     'DM',
//                     'DGO',
//                     'Fellowship in Cardiology',
//                     'Fellowship in Dermatology',
//                     'Fellowship in Neurology',
//                     'Fellowship in Pediatrics',
//                     'Fellowship in Orthopedics',
//                     'Fellowship in Gynecology',
//                     'Fellowship in Psychiatry',
//                     'Fellowship in Radiology',
//                   ] // List of qualifications doctors can have
//                       .map((qualification) => DropdownMenuItem<String>(
//                             value: qualification,
//                             child: Text(qualification),
//                           ))
//                       .toList(), // Convert list to DropdownMenuItems
//                   onChanged: (value) {
//                     if (value != null) {
//                       _qualificationController.text =
//                           value; // Update controller text
//                     }
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please select your Qualification';
//                     }
//                     return null;
//                   },
//                 ),

//                 SizedBox(height: 20),

//                 // // Bio Field
//                 Text('Bio', style: _fieldLabelStyle()),
//                 SizedBox(height: 5),
//                 TextFormField(
//                   controller: _bioController,
//                   maxLines: 2,
//                   decoration: _inputDecoration('Tell something about yourself'),
//                 ),
//                 SizedBox(height: 20),

//                 // Email Field
//                 Text('Email', style: _fieldLabelStyle()),
//                 SizedBox(height: 5),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: _inputDecoration('Enter your email'),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),

//                 // Age Field
//                 Text('Age', style: _fieldLabelStyle()),
//                 SizedBox(height: 5),
//                 TextFormField(
//                   controller: _ageController,
//                   decoration: _inputDecoration('Enter your age'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your age';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),

//                 // Sex Field
//                 Text('Sex', style: _fieldLabelStyle()),
//                 SizedBox(height: 5),
//                 DropdownButtonFormField<String>(
//                   value: _sexController.text.isNotEmpty
//                       ? _sexController.text
//                       : null, // Set initial value if available
//                   decoration: _inputDecoration(
//                       'Select your Sex'), // Use your input decoration
//                   items: ['Male', 'Female']
//                       .map((sex) => DropdownMenuItem<String>(
//                             value: sex,
//                             child: Text(sex),
//                           ))
//                       .toList(), // Map list to DropdownMenuItems
//                   onChanged: (value) {
//                     if (value != null) {
//                       _sexController.text = value; // Update the controller
//                     }
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please select your Sex';
//                     }
//                     return null;
//                   },
//                 ),

//                 SizedBox(height: 40),

//                 // Save Button
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (_formKey.currentState?.validate() ?? false) {
//                         final User? user = FirebaseAuth.instance.currentUser;
//                         if (user != null) {
//                           final patientProfile = DoctorsDb(
//                             name: _nameController.text,
//                             username: _usernameController.text,
//                             // Parse age to int
//                             sex: _sexController.text,
//                             email: user.email ?? '',
//                             qualification: _qualificationController.text,
//                             specialization: _specializationController.text,
//                             bio: _bioController.text,
//                             age: int.tryParse(_ageController.text) ?? 0,
//                             uid: user
//                                 .uid, // Replace with the user's unique ID (e.g., Firebase UID)
//                           );

//                           // Save or update the profile in Firestore
//                           await patientProfile.checkAndSaveProfile();
//                           // Here you can handle saving data logic
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                                 content: Text('Profile Updated Successfully')),
//                           );
//                           Navigator.pop(
//                               context); // Go back to the previous page
//                         }
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                       backgroundColor: Colors.black, // Button color
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
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper function for input decoration
//   InputDecoration _inputDecoration(String hintText) {
//     return InputDecoration(
//       hintText: hintText,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: BorderSide(color: Colors.grey),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: BorderSide(color: Colors.black),
//       ),
//       contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//     );
//   }

//   // Helper function for field labels
//   TextStyle _fieldLabelStyle() {
//     return TextStyle(
//         fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]);
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_space/models/doctors_db.dart';

class EditPageDoctor extends StatefulWidget {
  @override
  _EditPageDoctorState createState() => _EditPageDoctorState();
}

class _EditPageDoctorState extends State<EditPageDoctor> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for TextFormFields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _qualificationController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    // _emailController.dispose();
    _ageController.dispose();
    _sexController.dispose();
    _specializationController.dispose();
    _qualificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height, // Prevent overflow
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field
                    Text('Name', style: _fieldLabelStyle()),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration('Enter your name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Username Field
                    Text('Username', style: _fieldLabelStyle()),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: _usernameController,
                      decoration: _inputDecoration('Enter your username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Specialization Field
                    Text('Specialization', style: _fieldLabelStyle()),
                    SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: _specializationController.text.isNotEmpty
                          ? _specializationController.text
                          : null,
                      decoration:
                          _inputDecoration('Select your Specialization'),
                      items: [
                        'psychiatrist',
                        'Cardiologist',
                        'Dermatologist',
                        'Neurologist',
                        'Pediatrician',
                        'Orthopedic',
                        'Gynecologist',
                        'Radiologist',
                      ]
                          .map((specialization) => DropdownMenuItem<String>(
                                value: specialization,
                                child: Text(specialization),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _specializationController.text = value;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your Specialization';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Qualification Field
                    Text('Qualification', style: _fieldLabelStyle()),
                    SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: _qualificationController.text.isNotEmpty
                          ? _qualificationController.text
                          : null,
                      decoration: _inputDecoration('Select your Qualification'),
                      items: [
                        'MBBS',
                        'MD',
                        'MS',
                        'DNB',
                        'MCh',
                        'DM',
                        'DGO',
                        'Fellowship in Cardiology',
                        'Fellowship in Dermatology',
                        'Fellowship in Neurology',
                        'Fellowship in Pediatrics',
                        'Fellowship in Orthopedics',
                        'Fellowship in Gynecology',
                        'Fellowship in Psychiatry',
                        'Fellowship in Radiology',
                      ]
                          .map((qualification) => DropdownMenuItem<String>(
                                value: qualification,
                                child: Text(qualification),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _qualificationController.text = value;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your Qualification';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),

                    // Bio Field
                    Text('Bio', style: _fieldLabelStyle()),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: _bioController,
                      maxLines: 2,
                      decoration:
                          _inputDecoration('Tell something about yourself'),
                    ),
                    SizedBox(height: 20),

                    // Email Field
                    // Text('Email', style: _fieldLabelStyle()),
                    // SizedBox(height: 5),
                    // TextFormField(
                    //   controller: _emailController,
                    //   decoration: _inputDecoration('Enter your email'),
                    //   keyboardType: TextInputType.emailAddress,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter your email';
                    //     }
                    //     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    //       return 'Please enter a valid email';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // SizedBox(height: 20),

                    // Age Field
                    Text('Age', style: _fieldLabelStyle()),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: _ageController,
                      decoration: _inputDecoration('Enter your age'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Sex Field
                    Text('Sex', style: _fieldLabelStyle()),
                    SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: _sexController.text.isNotEmpty
                          ? _sexController.text
                          : null,
                      decoration: _inputDecoration('Select your Sex'),
                      items: ['Male', 'Female']
                          .map((sex) => DropdownMenuItem<String>(
                                value: sex,
                                child: Text(sex),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _sexController.text = value;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your Sex';
                        }
                        return null;
                      },
                    ),

                    Spacer(),

                    // Save Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final User? user =
                                FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              final patientProfile = DoctorsDb(
                                name: _nameController.text,
                                username: _usernameController.text,
                                sex: _sexController.text,
                                email: user.email ?? '',
                                qualification: _qualificationController.text,
                                specialization: _specializationController.text,
                                bio: _bioController.text,
                                age: int.tryParse(_ageController.text) ?? 0,
                                uid: user.uid,
                              );

                              await patientProfile.checkAndSaveProfile();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Profile Updated Successfully')),
                              );
                              Navigator.pop(context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.black),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    );
  }

  TextStyle _fieldLabelStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
  }
}
