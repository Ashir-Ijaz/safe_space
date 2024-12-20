import 'package:flutter/material.dart';
import 'package:safe_space/pages/doctorpages/viewprofiledoctor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Doctorlogin extends StatefulWidget {
  const Doctorlogin({super.key});

  @override
  State<Doctorlogin> createState() => _DoctorloginState();
}

class _DoctorloginState extends State<Doctorlogin> {
  final User? user = FirebaseAuth.instance.currentUser;
  int _currentIndex = 0; // Track the current index for BottomNavigationBar

  String doctorName = "Doctor Name";
  String specialization = "**";
  String qualification = "***";

  @override
  void initState() {
    super.initState();
    if (user != null) {
      fetchProfileData(user!.uid);
    }
  }

  Future<void> fetchProfileData(String uid) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        setState(() {
          doctorName = data['name'] ?? "Doctor's Name";
          specialization = data['specialization'] ?? "**";
          qualification = data['qualification'] ?? "***";
        });
      }
    } catch (e) {
      // Error fetching profile; default values remain
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 3) {
      // Navigate to the "More" screen when tapped
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewProfileDoctorScreen(),
        ),
      );
    }
  }

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
      body: SingleChildScrollView(
        child: Padding(
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
                      icon:
                          const Icon(Icons.add, size: 30, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 19),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        specialization,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        qualification,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
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
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        currentIndex: _currentIndex, // Highlight the current tab
        onTap: _onBottomNavTap,
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










// import 'package:flutter/material.dart';
// import 'package:safe_space/pages/doctorpages/viewprofiledoctor.dart';

// class Doctorlogin extends StatelessWidget {
//   const Doctorlogin({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // Background color
//       appBar: AppBar(
//         title: const Text(
//           'SAFE-SPACE',
//           style: TextStyle(fontWeight: FontWeight.bold), // Make title bold
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         toolbarHeight: 70,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(
//             color: Colors.black,
//             height: 1,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         // Wrap the body with SingleChildScrollView
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Doctor's Profile Section
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundColor: Colors.grey.shade200,
//                     child: IconButton(
//                       icon:
//                           const Icon(Icons.add, size: 30, color: Colors.black),
//                       onPressed: () {},
//                     ),
//                   ),
//                   const SizedBox(width: 19),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text(
//                         'Dr. Professor Vaneeza',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                       SizedBox(height: 6),
//                       Text(
//                         'Surgeon',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 18),
//                       ),
//                       SizedBox(height: 6),
//                       Text(
//                         'Mbbs(Pb), Phd(AFPGM)',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 17),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),

//               // Stars for Rating
//               const Row(
//                 children: [
//                   Icon(Icons.star, color: Colors.yellow, size: 20),
//                   Icon(Icons.star, color: Colors.yellow, size: 20),
//                   Icon(Icons.star, color: Colors.yellow, size: 20),
//                   Icon(Icons.star, color: Colors.yellow, size: 20),
//                   Icon(Icons.star_border, color: Colors.yellow, size: 20),
//                 ],
//               ),
//               const SizedBox(height: 18),
//               const Divider(color: Colors.black, thickness: 1),

//               // Reviews Section
//               const Text(
//                 'Reviews',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 180, // Adjust height to make containers bigger
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 4,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       width: 180, // Adjust width for bigger containers
//                       margin: const EdgeInsets.only(right: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade200,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Center(child: Text('Review ${index + 1}')),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Appointments Section
//               const Text(
//                 'Appointments',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 180, // Adjust height to make containers bigger
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 4,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       width: 180, // Adjust width for bigger containers
//                       margin: const EdgeInsets.only(right: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade200,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Center(child: Text('Appointment ${index + 1}')),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),

//       // Bottom Navigation Bar
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Color.fromARGB(255, 255, 255, 255),
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.black,
//         currentIndex: 0, // Highlight the current tab (Home as default)
//         onTap: (index) {
//           if (index == 3) {
//             // Check if the Menu icon is tapped
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => ViewProfileDoctorScreen()),
//             );
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today),
//             label: 'Calendar',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.mail),
//             label: 'Messages',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.menu),
//             label: 'More',
//           ),
//         ],
//       ),
//     );
//   }
// }
