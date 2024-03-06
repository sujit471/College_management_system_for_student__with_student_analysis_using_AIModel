import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class View3Data extends StatefulWidget {
  @override
  _View3DataState createState() => _View3DataState();
}

class _View3DataState extends State<View3Data> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> predictorData = [];

  @override
  void initState() {
    super.initState();
    _fetchPredictorData();
  }

  Future<void> _fetchPredictorData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;
        DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('predictordata').doc(userId).get();
        if (snapshot.exists) {
          setState(() {
            predictorData = [snapshot.data() as Map<String, dynamic>];
          });
        } else {
          setState(() {
            predictorData = [];
          });
        }
      }
    } catch (error) {
      print("Error fetching predictor data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Your Predictor Data'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: predictorData.map((data) {
            return Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ListTile(

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    _buildScoreTextField('Assignment Score', data['assignment_score'], Icons.assignment),
                    SizedBox(height: 8),
                    _buildScoreTextField('Assessment Score', data['assessment_score'], Icons.assessment),
                    SizedBox(height: 8),
                    _buildScoreTextField('Attendance Score', data['attendance_score'], Icons.event_available),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildScoreTextField(String title, double score, IconData iconData) {
    return Row(
      children: [
        Icon(iconData, size: 24, color: Colors.blue),
        SizedBox(width: 12),
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: TextEditingController(text: score.toString()),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            readOnly: true,
          ),
        ),
      ],
    );
  }
}
