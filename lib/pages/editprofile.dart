import 'package:flutter/material.dart';
import 'package:safe_space/models/petpatient_db.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditPagePet extends StatefulWidget {
  @override
  _EditPagePetState createState() => _EditPagePetState();
}

class _EditPagePetState extends State<EditPagePet> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for TextFormFields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _nameController.dispose();
    _usernameController.dispose();
    // _bioController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _sexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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

                // Bio Field
                // Text('Bio', style: _fieldLabelStyle()),
                // SizedBox(height: 5),
                // TextFormField(
                //   controller: _bioController,
                //   maxLines: 2,
                //   decoration: _inputDecoration('Tell something about yourself'),
                // ),
                // SizedBox(height: 20),

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
                Text('Sex', style: _fieldLabelStyle()),
                SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: _sexController.text.isNotEmpty
                      ? _sexController.text
                      : null, // Set initial value if available
                  decoration: _inputDecoration(
                      'Select your Sex'), // Use your input decoration
                  items: ['Male', 'Female']
                      .map((sex) => DropdownMenuItem<String>(
                            value: sex,
                            child: Text(sex),
                          ))
                      .toList(), // Map list to DropdownMenuItems
                  onChanged: (value) {
                    if (value != null) {
                      _sexController.text = value; // Update the controller
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your Sex';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 40),

                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          final patientProfile = PetpatientDb(
                            name: _nameController.text,
                            username: _usernameController.text,
                            sex: _sexController.text,
                            email: user.email ?? '',
                            age: int.tryParse(_ageController.text) ?? 0,
                            uid: user
                                .uid, // Replace with the user's unique ID (e.g., Firebase UID)
                          );

                          // Save or update the profile in Firestore
                          await patientProfile.checkAndSaveProfile();
                          // Here you can handle saving data logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Profile Updated Successfully')),
                          );
                          Navigator.pop(
                              context); // Go back to the previous page
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      backgroundColor: Colors.black, // Button color
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
    );
  }

  // Helper function for input decoration
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

  // Helper function for field labels
  TextStyle _fieldLabelStyle() {
    return TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]);
  }
}