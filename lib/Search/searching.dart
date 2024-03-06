import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import'package:flutter/material.dart';
import'package:http/http.dart'as http;
import 'package:lottie/lottie.dart';
import '../login_UI_yt/logintry.dart';
class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late Timer _timer;
  void initState() {
    super.initState();
   // userData = getUserData(widget.user.uid);
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
  String remark = '';
  bool isPredicting = false;

  TextEditingController attendanceController = TextEditingController();
  TextEditingController assignmentController = TextEditingController();
  TextEditingController assessmentController = TextEditingController();

  Future<void> postData() async {
    setState(() {
      isPredicting = true;
    });
    try {
      final url = Uri.parse('https://shres58tha.pythonanywhere.com/predict');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "attendance_score": double.parse(attendanceController.text),
        "assignment_score": double.parse(assignmentController.text),
        "assessment_score": double.parse(assessmentController.text),
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          remark = responseData['selected_remark'];
        });
        await Future.delayed(Duration(seconds: 4)); // Delay display of remark for 4 seconds
        setState(() {
          isPredicting = false;
        });
      } else {
        setState(() {
          remark = 'Failed to fetch data';
          isPredicting = false;
        });
      }
    } catch (error) {
      setState(() {
        remark = 'Error: $error';
        isPredicting = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Predictor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: isPredicting
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'animations/ailoadinganimation.json',
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Text(
                "Predicting your Case ",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          )
              : remark.isNotEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                remark,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: attendanceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Attendance Score',
                    border: InputBorder.none,
                    icon: Icon(Icons.event_available),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: assignmentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Assignment Score',
                    border: InputBorder.none,
                    icon: Icon(Icons.assignment),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: assessmentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Assessment Score',
                    border: InputBorder.none,
                    icon: Icon(Icons.assessment),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  postData();
                },
                child: Text('Predict'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

