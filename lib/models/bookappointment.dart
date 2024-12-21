import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorSlotsWidget extends StatefulWidget {
  final String doctorId;

  DoctorSlotsWidget({required this.doctorId});

  @override
  _DoctorSlotsWidgetState createState() => _DoctorSlotsWidgetState();
}

class _DoctorSlotsWidgetState extends State<DoctorSlotsWidget> {
  late Future<Map<String, dynamic>?> doctorSlots;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    doctorSlots = fetchDoctorSlots(widget.doctorId);
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

  Widget buildSlotList(Map<String, dynamic> slots) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: slots.entries.map((entry) {
        final day = entry.key;
        final slotList = entry.value as List<dynamic>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              day,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 12),
            ...slotList.map((slot) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('hh:mm a')
                          .format(DateTime.parse(slot['time'])),
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    Text(
                      slot['booked'] ? 'Booked' : 'Free',
                      style: TextStyle(
                        fontSize: 16,
                        color: slot['booked'] ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            Divider(color: Colors.grey),
          ],
        );
      }).toList(),
    );
  }

  void _showDaySelectionDialog() async {
    final availableDays = await _getAvailableDays();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Appointment Day'),
          content: SingleChildScrollView(
            child: ListBody(
              children: availableDays.map((day) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _showSlotSelectionDialog(day);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(day),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<List<String>> _getAvailableDays() async {
    final slotsData = await fetchDoctorSlots(widget.doctorId);
    if (slotsData == null || slotsData['slots'] == null) {
      return [];
    }

    final slotsByDay = slotsData['slots'] as Map<String, dynamic>;
    return slotsByDay.keys.toList();
  }

  void _showSlotSelectionDialog(String selectedDay) async {
    final slotsData = await fetchDoctorSlots(widget.doctorId);
    if (slotsData == null || slotsData['slots'] == null) {
      return;
    }

    final slotsByDay = slotsData['slots'] as Map<String, dynamic>;
    final slots = slotsByDay[selectedDay] as List<dynamic>;
    final availableSlots = slots.where((slot) => !slot['booked']).toList();

    if (availableSlots.isEmpty) {
      _showNoSlotsDialog();
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Time Slot for $selectedDay'),
          content: SingleChildScrollView(
            child: ListBody(
              children: availableSlots.map((slot) {
                return GestureDetector(
                  onTap: () {
                    _bookSlot(selectedDay, slot);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat('hh:mm a')
                          .format(DateTime.parse(slot['time'])),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _bookSlot(String selectedDay, dynamic selectedSlot) async {
    final slotTime = DateTime.parse(selectedSlot['time']);

    // Check if the slot is already booked
    if (selectedSlot['booked']) {
      _showSlotAlreadyBookedDialog();
      return;
    }

    // Update the slot to be booked
    final updatedSlot = {
      'time': slotTime.toIso8601String(),
      'booked': true,
    };

    try {
      // Fetch the existing slots for the selected day
      final slotsData = await fetchDoctorSlots(widget.doctorId);
      if (slotsData == null || slotsData['slots'] == null) {
        return;
      }

      final slotsByDay = slotsData['slots'] as Map<String, dynamic>;
      final slotsForSelectedDay = slotsByDay[selectedDay] as List<dynamic>;

      // Find the index of the slot to be updated
      final slotIndex = slotsForSelectedDay.indexWhere(
          (slot) => DateTime.parse(slot['time']).isAtSameMomentAs(slotTime));

      if (slotIndex == -1) {
        _showSlotNotFoundDialog();
        return;
      }

      // Update the booked slot status to true
      slotsForSelectedDay[slotIndex] = updatedSlot;

      // Update the Firestore database
      await FirebaseFirestore.instance
          .collection('slots')
          .doc(widget.doctorId)
          .update({
        'slots.$selectedDay': slotsForSelectedDay,
      });

      // Navigate back with the selected time slot
      Navigator.pop(context, {
        'day': selectedDay,
        'time': DateFormat('hh:mm a').format(slotTime),
      });

      print(
          'Slot booked for $selectedDay at ${DateFormat('hh:mm a').format(slotTime)}');
    } catch (e) {
      print('Error booking slot: $e');
      _showBookingErrorDialog();
    }
  }

  void _showNoSlotsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Slots Available'),
          content: Text('Sorry, there are no available slots for booking.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSlotAlreadyBookedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Slot Already Booked'),
          content: Text(
              'The selected slot is already booked. Please select another one.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSlotNotFoundDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Slot Not Found'),
          content:
              Text('The selected slot could not be found. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showBookingErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Failed'),
          content: Text(
              'An error occurred while booking the slot. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Availability'),
        backgroundColor: Colors.blueAccent,
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

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No slots available.'));
          }

          final slots = snapshot.data!['slots'] ?? {};
          return Column(
            children: [
              Expanded(
                  child: buildSlotList(
                      slots)), // Makes the slot list take remaining space
              Align(
                alignment:
                    Alignment.bottomCenter, // Align the button to the bottom
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ElevatedButton(
                    onPressed: _showDaySelectionDialog,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity,
                          60), // Increase the height and make it full width
                      textStyle: TextStyle(
                          fontSize: 18), // Optional: Increase the font size
                    ),
                    child: Text('Select Time'),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
