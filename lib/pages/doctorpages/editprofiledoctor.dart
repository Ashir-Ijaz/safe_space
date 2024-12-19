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

  // Variables for availability
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name Field
                _buildTextField('Name', _nameController, 'Enter your name'),

                // Username Field
                _buildTextField(
                    'Username', _usernameController, 'Enter your username'),

                // Specialization Field
                _buildDropdown('Specialization', _specializationController, [
                  'Psychiatrist',
                  'Cardiologist',
                  'Dermatologist',
                  'Neurologist',
                  'Pediatrician',
                  'Orthopedic',
                  'Gynecologist',
                  'Radiologist',
                ]),

                // Qualification Field
                _buildDropdown('Qualification', _qualificationController, [
                  'MBBS',
                  'MD',
                  'MS',
                  'DNB',
                  'MCh',
                  'DM',
                  'Fellowship in Cardiology',
                  'Fellowship in Dermatology',
                  'Fellowship in Neurology',
                ]),

                // Bio Field
                _buildTextField(
                    'Bio', _bioController, 'Tell something about yourself',
                    isMultiline: true),

                // Age Field
                _buildTextField('Age', _ageController, 'Enter your age'),

                // Sex Field
                _buildDropdown('Sex', _sexController, ['Male', 'Female']),

                // Available Days Field
                _buildAvailableDaysField(context),

                // Time Fields
                _buildTimeSelector('Start Time', () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _startTime = pickedTime;
                    });
                  }
                }, _startTime),

                _buildTimeSelector('End Time', () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _endTime = pickedTime;
                    });
                  }
                }, _endTime),

                SizedBox(height: 40),

                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          // Convert TimeOfDay to String
                          String? startTimeString = _startTime?.format(context);
                          String? endTimeString = _endTime?.format(context);

                          // Convert Map<String, bool> to List<String>
                          List<String> selectedDaysList = _selectedDays.entries
                              .where((entry) => entry.value)
                              .map((entry) => entry.key)
                              .toList();

                          // Create the DoctorsDb object with the selected schedule details
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
                            availableDays:
                                selectedDaysList, // Pass selected days as List<String>
                            startTime:
                                startTimeString, // Pass the formatted start time string
                            endTime:
                                endTimeString, // Pass the formatted end time string
                          );

                          await patientProfile.checkAndSaveProfile();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Profile Updated Successfully')),
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(
      String label, TextEditingController controller, String hint,
      {bool isMultiline = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _fieldLabelStyle()),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: _inputDecoration(hint),
          maxLines: isMultiline ? 2 : 1,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your $label';
            }
            return null;
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // Helper method to build dropdown fields
  Widget _buildDropdown(
      String label, TextEditingController controller, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _fieldLabelStyle()),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: controller.text.isNotEmpty ? controller.text : null,
          decoration: _inputDecoration('Select your $label'),
          items: items.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.text = value;
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your $label';
            }
            return null;
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // Helper method to build available days field
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

  // Helper method to build time selector
  Widget _buildTimeSelector(
      String label, Function onTap, TimeOfDay? selectedTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _fieldLabelStyle()),
        GestureDetector(
          onTap: () => onTap(),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedTime != null
                        ? selectedTime.format(context)
                        : 'Select Time',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Icon(Icons.access_time),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // Helper method for consistent input decoration
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // Helper method for consistent field label style
  TextStyle _fieldLabelStyle() {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }
}
