// import 'package:flutter/material.dart';
// import 'auth_service.dart';
// import 'Loginpage.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final _auth = AuthService(); // AuthService instance
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Page'),
//         backgroundColor: Colors.orangeAccent,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Welcome to the Homepage!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             // ElevatedButton(
//             //   onPressed: () async {
//             //     try {
//             //       await _auth.signout();
//             //       // Replace current page with LoginPage after signout
//             //       Navigator.pushReplacement(
//             //         context,
//             //         MaterialPageRoute(
//             //           builder: (context) => const LoginPage(),
//             //         ),
//             //       );
//             //     } catch (e) {
//             //       // Handle signout errors if needed
//             //       debugPrint("Error during signout: $e");
//             //     }
//             //   },
//             //   style: ElevatedButton.styleFrom(
//             //     backgroundColor: Colors.orangeAccent,
//             //     padding: const EdgeInsets.symmetric(
//             //       horizontal: 32,
//             //       vertical: 12,
//             //     ),
//             //   ),
//             //   child: const Text(
//             //     'Sign Out',
//             //     style: TextStyle(fontSize: 16),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
