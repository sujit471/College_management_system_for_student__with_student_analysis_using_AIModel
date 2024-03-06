//this is the code for the prediction of student probabilities of  passing or failing the subjects with output as  comments  and the number of  subjects that
//that he she can fail in that subjects where parsing has been done aling with the link for the model hosted

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class Predictor extends StatefulWidget {
  @override
  _PredictorState createState() => _PredictorState();
}

class _PredictorState extends State<Predictor> {
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
      //parsing the data from the link using post method
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
        await Future.delayed(Duration(seconds: 3)); // Delay display of remark for 4 seconds
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
                //custom animation before loading the actual data
                'animations/ailoadinganimation.json',
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: attendanceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Attendance Score',
                    border: InputBorder.none,
                    icon: Icon(Icons.event_available),
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
