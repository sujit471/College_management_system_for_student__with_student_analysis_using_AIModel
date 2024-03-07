import 'dart:convert';
import 'package:college_management_app/login_UI_yt/signup.dart';
import 'package:college_management_app/navigation_menu/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import '../Userprofile/profile.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorMessage = '';// this is to show the error upon the wrong credentials
  bool  _obscureText = true;
  late Future<String> profileImageUrl;

  void initState() {
    super.initState();
    profileImageUrl = fetchProfileImage();
  }
  // fetching image from api

  final TextEditingController nameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  get selectedFaculty => null;

//email:thunderball45@gmail.com pwd: adotya
  Future<String?> _authenticateWithFirebase(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: nameController.text.trim(),
          password: passwordController.text.trim());
      User? user = userCredential.user;
      String uid = user?.uid ?? '';
      print('Authentication successful');
      print('User ID: ${userCredential.user?.uid}');

      Navigator.push(
        context ,
        MaterialPageRoute(builder: (context) => NavigationMenu()),
      );

    } on FirebaseAuthException catch (e) {
      print('Authentication failed: $e');
      setState(() {
        errorMessage = 'Wrong email or password. Please try again';
      });
    }
  }

  // void _login() {
  //   _authenticateWithFirebase();  NavigationController.to.setUserId(uid);
  //
  //  }

  void _login() async {
    // Perform authentication and obtain the user object
    User? user = (await _authenticateWithFirebase(context as BuildContext)) as User?;

    // if (user != null) {
    //   // Navigate to the NavigationMenu after successful login
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => NavigationMenu(user: user)),
    //   );
    // } else {
    //   // Handle login failure
    //   print('Login failed');
    // }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage,style: TextStyle(color:Colors.red),),
              Container(
                decoration: const BoxDecoration(),
                child: FutureBuilder(
                  future: profileImageUrl,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(); // Return an empty container while loading
                    } else if (snapshot.hasError) {
                      return Container(); // Handle error case
                    } else {
                      String imageUrl = snapshot.data.toString();
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 70,
                          //backgroundImage: NetworkImage(imageUrl),
                          backgroundImage: AssetImage('svgimage/img.png'),
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
      
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Name',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
      
              SizedBox(height: 8),
      
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText:_obscureText,
                  decoration:  InputDecoration(
                    prefixIcon: Icon(Icons.key),
                    labelText: 'Password',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: InputBorder.none,
                    suffixIcon: IconButton(  onPressed: (){
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    }, icon: Icon(_obscureText ?Icons.visibility:Icons.visibility_off,))
                  ),
                ),
              ),
              SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: _login,
              //   child: Text('Login'),
              // ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.check_box),
                  Text('Remember Me'),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
      
                        child: Text("Forgot Password?")),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Container(
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple, // Background color
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const NavigationMenu()),
                    // );
                    _login();
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  InkWell(
                    child: const Text("Sign Up",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        )),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      );

  }

  Future<String> fetchProfileImage() async {
    var response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos/1'));

    if (response.statusCode == 200) {
      var photoData = json.decode(response.body);
      return photoData['url'];
    } else {
      throw Exception('Failed to load profile image');
    }
  }
}

