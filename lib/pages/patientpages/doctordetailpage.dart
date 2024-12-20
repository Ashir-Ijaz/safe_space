import 'package:flutter/material.dart';

class DoctorDetailPage extends StatelessWidget {
  final Map<String, dynamic> doctor;

  DoctorDetailPage({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor['name'] ?? 'Doctor Details'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            SizedBox(height: 16.0),
            _buildSectionTitle('Personal Details'),
            _buildDetailCard([
              _buildDetailRow('Username', doctor['username']),
              _buildDetailRow('Specialization', doctor['specialization']),
              _buildDetailRow('Qualification', doctor['qualification']),
              _buildDetailRow('Bio', doctor['bio']),
              _buildDetailRow('Email', doctor['email']),
              _buildDetailRow('Age', doctor['age']?.toString()),
              _buildDetailRow('Sex', doctor['sex']),
            ]),
            SizedBox(height: 16.0),
            _buildSectionTitle('Availability'),
            _buildDetailCard([
              _buildDetailRow(
                  'Available Days', doctor['availableDays']?.join(', ')),
              _buildDetailRow('Start Time', doctor['startTime']),
              _buildDetailRow('End Time', doctor['endTime']),
            ]),
            SizedBox(height: 16.0),
            _buildSectionTitle('Contact Information'),
            _buildDetailCard([
              _buildDetailRow('Phone Number', doctor['phonenumber']),
              _buildDetailRow('Clinic Name', doctor['clinicName']),
              _buildDetailRow(
                  'Clinic Contact Number', doctor['contactNumberClinic']),
            ]),
            SizedBox(height: 16.0),
            _buildSectionTitle('Professional Details'),
            _buildDetailCard([
              _buildDetailRow('Fees', doctor['fees']?.toString()),
              _buildDetailRow('Doctor Type', doctor['doctorType']),
              _buildDetailRow('Experience', doctor['experience']),
            ]),
          ],
        ),
      ),
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
                doctor['name']?.substring(0, 1).toUpperCase() ?? 'D',
                style: TextStyle(fontSize: 32.0, color: Colors.white),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor['name'] ?? 'Doctor Name',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    doctor['specialization'] ?? 'Specialization',
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
}
