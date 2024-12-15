import 'package:flutter/material.dart';
import 'package:safe_space/pages/doctorpages/editprofiledoctor.dart';

class ViewProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Profile',
      home: ViewProfileDoctorScreen(),
    );
  }
}

class ViewProfileDoctorScreen extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        ProfileInfoRow(title: 'Name', value: 'viny'),
        ProfileInfoRow(title: 'Username', value: 'urs_viny'),
        ProfileInfoRow(
            title: 'Specialization', value: 'Surgeon'), // Added age field
        ProfileInfoRow(
            title: 'Qualification',
            value: 'Mbbs(Pb),Phd(AFPGM)'), // Added sex field
        ProfileInfoRow(title: 'Bio', value: 'I like you'),
        ProfileInfoRow(
            title: 'Email', value: 'urviny@gmail.com', isGreyed: true),
        ProfileInfoRow(title: 'Age', value: '20'), // Added sex field
        ProfileInfoRow(title: 'Sex', value: 'Female'), // Added sex field

        SizedBox(
          height: 50,
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Navigate to EditProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditPageDoctor()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  horizontal: 40, vertical: 15), // Button size
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              backgroundColor: Colors.black, // Button color
            ),
            child: Text(
              'Edit',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Text color
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
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
