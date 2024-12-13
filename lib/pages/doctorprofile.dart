import 'package:flutter/material.dart';

class Doctorlogin extends StatelessWidget {
  const Doctorlogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      appBar: AppBar(
        title: const Text(
          'SAFE-SPACE',
          style: TextStyle(fontWeight: FontWeight.bold), // Make title bold
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        toolbarHeight: 70,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.black,
            height: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor's Profile Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade200,
                  child: IconButton(
                    icon: const Icon(Icons.add, size: 30, color: Colors.black),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 19),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Dr. Professor Vaneeza',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Surgeon',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Mbbs(Pb), Phd(AFPGM)',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Stars for Rating
            const Row(
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 20),
                Icon(Icons.star, color: Colors.yellow, size: 20),
                Icon(Icons.star, color: Colors.yellow, size: 20),
                Icon(Icons.star, color: Colors.yellow, size: 20),
                Icon(Icons.star_border, color: Colors.yellow, size: 20),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(color: Colors.black, thickness: 1),

            // Reviews Section
            const Text(
              'Reviews',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 180, // Adjust height to make containers bigger
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    width: 180, // Adjust width for bigger containers
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: Text('Review ${index + 1}')),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Appointments Section
            const Text(
              'Appointments',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 180, // Adjust height to make containers bigger
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    width: 180, // Adjust width for bigger containers
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: Text('Appointment ${index + 1}')),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
