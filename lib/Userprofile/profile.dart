import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login_UI_yt/logintry.dart';
class Profile1 extends StatefulWidget {
  final User user;

  Profile1({Key? key, required this.user}) : super(key: key);

  @override
  _Profile1State createState() => _Profile1State();
}

class _Profile1State extends State<Profile1> {
  late Future<DocumentSnapshot> userData;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    userData = getUserData(widget.user.uid);
    startTimer();
  }

  void startTimer() {
    _timer = Timer(const Duration(minutes: 15), () {
      // Logout user after 5 minutes of inactivity
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      Text("User Session Expired");
    });
  }

  void resetTimer() {
    _timer.cancel(); // Cancel the existing timer
    startTimer(); // Start a new timer
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Your Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User data not found.'));
          } else {
            Map<String, dynamic> userData =
                snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 120, // Adjust width as needed
                      height: 110, // Adjust height as needed
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.5), // Adjust color and opacity as needed
                            spreadRadius: 8, // Adjust spread radius as needed
                            blurRadius: 20, // Adjust blur radius as needed
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'image/acem-logo-transformed.png',
                          width: 100, // Adjust width as needed
                          height: 90, // Adjust height as needed
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Row(
                          children: <Widget>[
                            Icon(Icons.person, color: Colors.blue),
                            SizedBox(width: 8.0),
                            // Add space between icon and text
                            Text(
                              'Name',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8.0),
                        // Add space between text and end of container
                        Text(
                          '${userData['name']}',
                          // Replace with the desired userData field
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Row(
                          children: <Widget>[
                            Icon(Icons.email, color: Colors.blue),
                            SizedBox(width: 8.0),
                            // Add space between icon and text
                            Text(
                              'Email',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8.0),
                        // Add space between text and end of container
                        Text(
                          '${userData['email']}',
                          // Replace with the desired userData field
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Row(
                          children: <Widget>[
                            Icon(Icons.confirmation_num, color: Colors.blue),
                            SizedBox(width: 8.0),
                            // Add space between icon and text
                            Text(
                              'Roll Number',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(width: 8.0),
                        // Add space between text and end of container
                        Text(
                          '${userData['rollNumber']}',
                          // Replace with the desired userData field
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Row(
                          children: <Widget>[
                            Icon(Icons.school, color: Colors.blue),
                            SizedBox(width: 8.0),
                            // Add space between icon and text
                            Text(
                              'Faculty',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(width: 8.0),
                        // Add space between text and end of container
                        Text(
                          '${userData['faculty']}',
                          // Replace with the desired userData field
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Row(
                          children: <Widget>[
                            Icon(Icons.phone, color: Colors.blue),
                            SizedBox(width: 8.0),
                            // Add space between icon and text
                            Text(
                              'Phone Number',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(width: 8.0),
                        // Add space between text and end of container
                        Text(
                          '${userData['phoneNumber']}',
                          // Replace with the desired userData field
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
