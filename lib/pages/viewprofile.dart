import 'package:flutter/material.dart';
import 'package:safe_space/models/petpatient_db.dart';
import 'package:safe_space/pages/editprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Profile',
      home: ViewProfileScreen(),
    );
  }
}

class ViewProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Prevent pixel overflow issues
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20), // Adds spacing
              ProfilePhoto(),
              SizedBox(height: 30),
              ProfileInfoSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double imageSize =
        MediaQuery.of(context).size.width * 0.4; // Adjust for screen size

    return Column(
      children: [
        Container(
          height: 120, // Suitable height for a profile picture
          width: 120, // Suitable width for a profile picture
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Circular shape for the profile picture
            image: DecorationImage(
              image:
                  AssetImage('assets/images/one.jpg'), // Profile picture asset
              fit: BoxFit.cover, // Ensure the image covers the container
            ),
            color: Colors.grey[300], // Placeholder background color
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 35, // Size for the small circular camera icon
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black
                    .withOpacity(0.6), // Semi-transparent background
              ),
              child: Icon(
                Icons.camera_alt,
                size: 20, // Size of the camera icon
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Change photo',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class ProfileInfoSection extends StatelessWidget {
  Future<PetpatientDb> fetchProfile(String uid) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('pets')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return PetpatientDb.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        throw Exception('Profile not found.');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  @override
  // Widget build(BuildContext context) {
  //   final User? user = FirebaseAuth.instance.currentUser;

  //   // Return a widget showing the profile only if user is authenticated
  //   if (user == null) {
  //     return Center(child: CircularProgressIndicator());
  //   }

  //   // Use a FutureBuilder to handle the async fetchProfile call
  //   return FutureBuilder<PetpatientDb>(
  //     future: fetchProfile(user.uid),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         // Show loading indicator while waiting for data
  //         return Center(child: CircularProgressIndicator());
  //       } else if (snapshot.hasError) {
  //         // Handle errors if fetching fails
  //         return Center(
  //           child: ElevatedButton(
  //             onPressed: () {
  //               // Navigate to EditProfilePage
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => EditPagePet()),
  //               );
  //             },
  //             style: ElevatedButton.styleFrom(
  //               padding: EdgeInsets.symmetric(
  //                   horizontal: 40, vertical: 15), // Button size
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8), // Rounded corners
  //               ),
  //               backgroundColor: Colors.black, // Button color
  //             ),
  //             child: Text(
  //               'Create Profile',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 color: Colors.white, // Text color
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         );
  //       } else if (!snapshot.hasData) {
  //         // Handle case where no data is returned
  //         return Center(child: Text('Profile not found.'));
  //       } else {
  //         // If data is fetched successfully, display the profile
  //         final pet = snapshot.data!; // PatientsDb instance

  //         return Column(
  //           children: [
  //             SizedBox(
  //               height: 20,
  //             ),
  //             ProfileInfoRow(title: 'Name', value: pet.name),
  //             ProfileInfoRow(title: 'Username', value: pet.username),
  //             ProfileInfoRow(
  //                 title: 'Age', value: pet.age.toString()), // Added age field
  //             ProfileInfoRow(title: 'Sex', value: pet.sex), // Added sex field
  //             ProfileInfoRow(title: 'Email', value: pet.email, isGreyed: true),
  //             SizedBox(
  //               height: 50,
  //             ),
  //             Center(
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   // Navigate to EditProfilePage
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => EditPagePet()),
  //                   );
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   padding: EdgeInsets.symmetric(
  //                       horizontal: 40, vertical: 15), // Button size
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8), // Rounded corners
  //                   ),
  //                   backgroundColor: Colors.black, // Button color
  //                 ),
  //                 child: Text(
  //                   'Edit Profile',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: Colors.white, // Text color
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         );
  //       }
  //     },
  //   );
  // }
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    // Return a widget showing the profile only if user is authenticated
    if (user == null) {
      return Center(child: CircularProgressIndicator());
    }

    // Use a FutureBuilder to handle the async fetchProfile call
    return FutureBuilder<PetpatientDb>(
      future: fetchProfile(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error loading profile: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditPagePet()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    'Create Profile',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No profile data found.'));
        } else {
          final pet = snapshot.data!;
          return Column(
            children: [
              SizedBox(height: 20),
              ProfileInfoRow(title: 'Name', value: pet.name),
              ProfileInfoRow(title: 'Username', value: pet.username),
              ProfileInfoRow(title: 'Age', value: pet.age.toString()),
              ProfileInfoRow(title: 'Sex', value: pet.sex),
              ProfileInfoRow(title: 'Email', value: pet.email, isGreyed: true),
              SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditPagePet()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.black,
                  ),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isGreyed;

  ProfileInfoRow(
      {required this.title, required this.value, this.isGreyed = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600]),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isGreyed ? Colors.grey : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:safe_space/pages/editprofile.dart';

// class ViewProfileApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Edit Profile',
//       home: ViewProfileScreen(),
//     );
//   }
// }

// class ViewProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         // Prevent pixel overflow issues
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 20), // Adds spacing
//               ProfilePhoto(),
//               SizedBox(height: 30),
//               ProfileInfoSection(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ProfilePhoto extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     double imageSize =
//         MediaQuery.of(context).size.width * 0.4; // Adjust for screen size

//     return Column(
//       children: [
//         Container(
//           height: 120, // Suitable height for a profile picture
//           width: 120, // Suitable width for a profile picture
//           decoration: BoxDecoration(
//             shape: BoxShape.circle, // Circular shape for the profile picture
//             image: DecorationImage(
//               image:
//                   AssetImage('assets/images/one.jpg'), // Profile picture asset
//               fit: BoxFit.cover, // Ensure the image covers the container
//             ),
//             color: Colors.grey[300], // Placeholder background color
//           ),
//           child: Align(
//             alignment: Alignment.bottomRight,
//             child: Container(
//               height: 35, // Size for the small circular camera icon
//               width: 35,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.black
//                     .withOpacity(0.6), // Semi-transparent background
//               ),
//               child: Icon(
//                 Icons.camera_alt,
//                 size: 20, // Size of the camera icon
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//         SizedBox(height: 10),
//         Text(
//           'Change photo',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
//         ),
//       ],
//     );
//   }
// }

// class ProfileInfoSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 20,
//         ),
//         ProfileInfoRow(title: 'Name', value: 'Johnmobbin'),
//         ProfileInfoRow(title: 'Username', value: 'johnmobbin'),
//         ProfileInfoRow(title: 'Bio', value: 'Likes animals and design'),
//         ProfileInfoRow(title: 'Email', value: 'Add your email', isGreyed: true),
//         SizedBox(
//           height: 50,
//         ),
//         Center(
//           child: ElevatedButton(
//             onPressed: () {
//               // Navigate to EditProfilePage
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => EditPage()),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               padding: EdgeInsets.symmetric(
//                   horizontal: 40, vertical: 15), // Button size
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8), // Rounded corners
//               ),
//               backgroundColor: Colors.black, // Button color
//             ),
//             child: Text(
//               'Edit Profile',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.white, // Text color
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ProfileInfoRow extends StatelessWidget {
//   final String title;
//   final String value;
//   final bool isGreyed;

//   ProfileInfoRow(
//       {required this.title, required this.value, this.isGreyed = false});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//                 color: Colors.grey[600]),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: isGreyed ? Colors.grey : Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }