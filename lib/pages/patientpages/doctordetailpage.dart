// import 'package:flutter/material.dart';

// class DoctorDetailPage extends StatelessWidget {
//   final Map<String, dynamic> doctor;

//   DoctorDetailPage({required this.doctor});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(doctor['name'] ?? 'Doctor Details'),
//         backgroundColor: Colors.teal,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeaderSection(),
//             SizedBox(height: 16.0),
// _buildSectionTitle('Personal Details'),
// _buildDetailCard([
//   _buildDetailRow('Username', doctor['username']),
//   _buildDetailRow('Specialization', doctor['specialization']),
//   _buildDetailRow('Qualification', doctor['qualification']),
//   _buildDetailRow('Bio', doctor['bio']),
//   _buildDetailRow('Email', doctor['email']),
//   _buildDetailRow('Age', doctor['age']?.toString()),
//   _buildDetailRow('Sex', doctor['sex']),
// ]),
// SizedBox(height: 16.0),
// _buildSectionTitle('Availability'),
// _buildDetailCard([
//   _buildDetailRow(
//       'Available Days', doctor['availableDays']?.join(', ')),
//   _buildDetailRow('Start Time', doctor['startTime']),
//   _buildDetailRow('End Time', doctor['endTime']),
// ]),
// SizedBox(height: 16.0),
// _buildSectionTitle('Contact Information'),
// _buildDetailCard([
//   _buildDetailRow('Phone Number', doctor['phonenumber']),
//   _buildDetailRow('Clinic Name', doctor['clinicName']),
//   _buildDetailRow(
//       'Clinic Contact Number', doctor['contactNumberClinic']),
// ]),
// SizedBox(height: 16.0),
// _buildSectionTitle('Professional Details'),
// _buildDetailCard([
//   _buildDetailRow('Fees', doctor['fees']?.toString()),
//   _buildDetailRow('Doctor Type', doctor['doctorType']),
//   _buildDetailRow('Experience', doctor['experience']),
//             ]),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderSection() {
//     return Card(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 40.0,
//               backgroundColor: Colors.teal,
//               child: Text(
//                 doctor['name']?.substring(0, 1).toUpperCase() ?? 'D',
//                 style: TextStyle(fontSize: 32.0, color: Colors.white),
//               ),
//             ),
//             SizedBox(width: 16.0),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     doctor['name'] ?? 'Doctor Name',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     doctor['specialization'] ?? 'Specialization',
//                     style: TextStyle(fontSize: 18, color: Colors.grey[700]),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         color: Colors.teal,
//       ),
//     );
//   }

// Widget _buildDetailCard(List<Widget> children) {
//   return Card(
//     elevation: 2.0,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//     child: Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         children: children,
//       ),
//     ),
//   );
// }

// Widget _buildDetailRow(String label, String? value) {
//   return Column(
//     children: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           Flexible(
//             child: Text(
//               value ?? 'Not Available',
//               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//               textAlign: TextAlign.end,
//             ),
//           ),
//         ],
//       ),
//       Divider(color: Colors.grey[300]),
//     ],
//   );
// }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorDetailPage extends StatefulWidget {
  final Map<String, dynamic> doctor;

  DoctorDetailPage({required this.doctor});

  @override
  _DoctorDetailPageState createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  late Future<Map<String, dynamic>?> doctorSlots;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    doctorSlots = fetchDoctorSlots(widget.doctor['uid']);
  }

  Future<Map<String, dynamic>?> fetchDoctorSlots(String doctorId) async {
    try {
      final docSnapshot =
          await _firestore.collection('slots').doc(doctorId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching slots for doctor: $e');
      return null;
    }
  }

  // Display doctor slots with booking status
  Widget buildSlotList(Map<String, dynamic> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: slots.entries.map((entry) {
        final day = entry.key;
        final slotList = entry.value as List<dynamic>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...slotList.map((slot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('hh:mm a').format(DateTime.parse(slot['time'])),
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    slot['booked'] ? 'Booked' : 'Free',
                    style: TextStyle(
                      fontSize: 16,
                      color: slot['booked'] ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              );
            }).toList(),
            SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctor['name'] ?? 'Doctor Details'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: doctorSlots,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching doctor slots'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No slots available.'));
          }

          final slots = snapshot.data!['slots'] ?? {};
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                SizedBox(height: 16.0),
                _buildSectionTitle('Personal Details'),
                _buildDetailCard([
                  _buildDetailRow('Username', widget.doctor['username']),
                  _buildDetailRow(
                      'Specialization', widget.doctor['specialization']),
                  _buildDetailRow(
                      'Qualification', widget.doctor['qualification']),
                  _buildDetailRow('Bio', widget.doctor['bio']),
                  _buildDetailRow('Email', widget.doctor['email']),
                  _buildDetailRow('Age', widget.doctor['age']?.toString()),
                  _buildDetailRow('Sex', widget.doctor['sex']),
                ]),
                SizedBox(height: 16.0),
                _buildSectionTitle('Availability'),
                _buildDetailCard([
                  _buildDetailRow('Available Days',
                      widget.doctor['availableDays']?.join(', ')),
                  _buildDetailRow('Start Time', widget.doctor['startTime']),
                  _buildDetailRow('End Time', widget.doctor['endTime']),
                ]),
                SizedBox(height: 16.0),
                _buildSectionTitle('Contact Information'),
                _buildDetailCard([
                  _buildDetailRow('Phone Number', widget.doctor['phonenumber']),
                  _buildDetailRow('Clinic Name', widget.doctor['clinicName']),
                  _buildDetailRow('Clinic Contact Number',
                      widget.doctor['contactNumberClinic']),
                ]),
                SizedBox(height: 16.0),
                _buildSectionTitle('Professional Details'),
                _buildDetailCard([
                  _buildDetailRow('Fees', widget.doctor['fees']?.toString()),
                  _buildDetailRow('Doctor Type', widget.doctor['doctorType']),
                  _buildDetailRow('Experience', widget.doctor['experience']),
                ]),
                SizedBox(height: 16.0),
                _buildSectionTitle('Available Slots'),
                buildSlotList(slots),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Flexible(
              child: Text(
                value ?? 'Not Available',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.teal,
              child: Text(
                widget.doctor['name']?.substring(0, 1).toUpperCase() ?? 'D',
                style: TextStyle(fontSize: 32.0, color: Colors.white),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doctor['name'] ?? 'Doctor Name',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.doctor['specialization'] ?? 'Specialization',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
    );
  }
}










// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// class DoctorDetailPage extends StatelessWidget {
//   late Future<Map<String, dynamic>?> doctorSlots;

//   @override
//   void initState() {
//     super.initState();
//     doctorSlots = fetchDoctorSlots(widget.doctor['uid']);
//   }
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final Map<String, dynamic> doctor;

//   DoctorDetailPage({required this.doctor});

  
//  Future<Map<String, dynamic>?> fetchDoctorSlots(String doctorId) async {
  
//     try {
//       final docSnapshot =
//           await _firestore.collection('slots').doc(doctorId).get();
//       if (docSnapshot.exists) {
//         return docSnapshot.data();
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching slots for doctor: $e');
//       return null;
//     }
//   }

 
//  // Display doctor slots with booking status
//   Widget buildSlotList(Map<String, dynamic> slots) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: slots.entries.map((entry) {
//         final day = entry.key;
//         final slotList = entry.value as List<dynamic>;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               day,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             ...slotList.map((slot) {
//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     DateFormat('hh:mm a').format(DateTime.parse(slot['time'])),
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   Text(
//                     slot['booked'] ? 'Booked' : 'Free',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: slot['booked'] ? Colors.red : Colors.green,
//                     ),
//                   ),
//                 ],
//               );
//             }).toList(),
//             SizedBox(height: 16),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(doctor['name'] ?? 'Doctor Details'),
//         backgroundColor: Colors.teal,
//       ),
//       body:FutureBuilder<Map<String, dynamic>?>(
//         future: doctorSlots,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error fetching doctor slots'));
//           }

//           if (!snapshot.hasData) {
//             return Center(child: Text('No slots available.'));
//           }

//           final slots = snapshot.data!['slots'] ?? {};
//           return SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeaderSection(),
//             SizedBox(height: 16.0),
//             _buildSectionTitle('Personal Details'),
//             _buildDetailCard([
//               _buildDetailRow('Username', doctor['username']),
//               _buildDetailRow('Specialization', doctor['specialization']),
//               _buildDetailRow('Qualification', doctor['qualification']),
//               _buildDetailRow('Bio', doctor['bio']),
//               _buildDetailRow('Email', doctor['email']),
//               _buildDetailRow('Age', doctor['age']?.toString()),
//               _buildDetailRow('Sex', doctor['sex']),
//             ]),
//             SizedBox(height: 16.0),
//             _buildSectionTitle('Availability'),
//             _buildDetailCard([
//               _buildDetailRow(
//                   'Available Days', doctor['availableDays']?.join(', ')),
//               _buildDetailRow('Start Time', doctor['startTime']),
//               _buildDetailRow('End Time', doctor['endTime']),
//             ]),
//             SizedBox(height: 16.0),
//             _buildSectionTitle('Contact Information'),
//             _buildDetailCard([
//               _buildDetailRow('Phone Number', doctor['phonenumber']),
//               _buildDetailRow('Clinic Name', doctor['clinicName']),
//               _buildDetailRow(
//                   'Clinic Contact Number', doctor['contactNumberClinic']),
//             ]),
//             SizedBox(height: 16.0),
//             _buildSectionTitle('Professional Details'),
//             _buildDetailCard([
//               _buildDetailRow('Fees', doctor['fees']?.toString()),
//               _buildDetailRow('Doctor Type', doctor['doctorType']),
//               _buildDetailRow('Experience', doctor['experience']),
//             ]),
//             SizedBox(height: 16.0),
//              _buildSectionTitle('Availability'),
//                 buildSlotList(slots),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailCard(List<Widget> children) {
//     return Card(
//       elevation: 2.0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: children,
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String? value) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             Flexible(
//               child: Text(
//                 value ?? 'Not Available',
//                 style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//                 textAlign: TextAlign.end,
//               ),
//             ),
//           ],
//         ),
//         Divider(color: Colors.grey[300]),
//       ],
//     );
//   }

//   Widget _buildHeaderSection() {
//     return Card(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 40.0,
//               backgroundColor: Colors.teal,
//               child: Text(
//                 doctor['name']?.substring(0, 1).toUpperCase() ?? 'D',
//                 style: TextStyle(fontSize: 32.0, color: Colors.white),
//               ),
//             ),
//             SizedBox(width: 16.0),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     doctor['name'] ?? 'Doctor Name',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     doctor['specialization'] ?? 'Specialization',
//                     style: TextStyle(fontSize: 18, color: Colors.grey[700]),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         color: Colors.teal,
//       ),
//     );
//   }
// }































 // Widget buildSlotList(Map<String, dynamic> slots) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: slots.entries.map((entry) {
  //       final day = entry.key;
  //       final slotList = entry.value as List<dynamic>;

  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             day,
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 8),
  //           ...slotList.map((slot) {
  //             return Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   slot['time'],
  //                   style: TextStyle(fontSize: 16),
  //                 ),
  //                 Text(
  //                   slot['booked'] ? 'Booked' : 'Free',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: slot['booked'] ? Colors.red : Colors.green,
  //                   ),
  //                 ),
  //               ],
  //             );
  //           }).toList(),
  //           SizedBox(height: 16),
  //         ],
  //       );
  //     }).toList(),
  //   );
  // }
