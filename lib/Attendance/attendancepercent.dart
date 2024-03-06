import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectAttendance {
  //final String subject;
  final double attendance;

  SubjectAttendance( this.attendance);
}

class AttendanceService {
  Future<List<SubjectAttendance>> getSubjectAttendances(String uid) async {
    final DocumentSnapshot documentSnapshot =
    await FirebaseFirestore.instance.collection('student_attendance').doc(uid).get();

    if (documentSnapshot.exists) {
      final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

      final List<SubjectAttendance> subjectAttendances =
      data.entries.map((entry) {
       // final String subject = entry.key;
        final double attendance = entry.value.toDouble();
        return SubjectAttendance(attendance);
      }).toList();

      return subjectAttendances;
    } else {
      throw Exception('Attendance data not found.');
    }
  }

  Future<double> getOverallAttendance(String uid) async {
    final DocumentSnapshot documentSnapshot =
    await FirebaseFirestore.instance.collection('student_attendance').doc(uid).get();

    if (documentSnapshot.exists) {
      return documentSnapshot['overall_score'].toDouble();
    } else {
      throw Exception('Overall score data not found.');
    }
  }
}

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late double overallAttendance = 0.0;
  late List<SubjectAttendance> subjectAttendances = [];

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    final service = AttendanceService();
    final overall = await service.getOverallAttendance('your_user_id');
    final subjects = await service.getSubjectAttendances('your_user_id');
    print("overall attendance : $overall");
    print("Subject attendance : $subjects");
    setState(() {
      overallAttendance = overall;
      subjectAttendances = subjects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Tracker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: 300,
              width: 450,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 15.0,
                        percent: overallAttendance / 100.0,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${overallAttendance.toStringAsFixed(2)}% ',
                              style: TextStyle(fontSize: 25),
                            ),
                            const Text(
                              'Attendance',
                              style: TextStyle(fontSize: 25),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.redAccent,
                        progressColor: Colors.green,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: '.',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 117),
                                ),
                                TextSpan(
                                  text: ' Present',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: '.',
                                style: TextStyle(color: Colors.red, fontSize: 150),
                              ),
                              TextSpan(
                                text: 'Absent',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ],
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: subjectAttendances.length,
              itemBuilder: (context, index) {
                final subjectAttendance = subjectAttendances[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text('hello'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              SizedBox(height: 5),
                              LinearPercentIndicator(
                                animation: true,
                                animationDuration: 2000,
                                width: 120.0,
                                lineHeight: 10.0,
                                trailing: Text(
                                  ' ${subjectAttendance.attendance.toStringAsFixed(2)}%',
                                  style: TextStyle(color: Colors.red),
                                ),
                                percent: subjectAttendance.attendance / 100.0,
                                progressColor: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
