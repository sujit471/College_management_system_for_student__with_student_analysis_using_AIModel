import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SubjectContainer extends StatelessWidget {
  final String subject;
  final int marks;

  const SubjectContainer(
      {super.key, required this.subject, required this.marks});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 5.0,
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subject,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            marks.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class MarksPage extends StatefulWidget {
  final User user;

  MarksPage({Key? key, required this.user}) : super(key: key);

  @override
  _MarksPageState createState() => _MarksPageState();
}

class _MarksPageState extends State<MarksPage> {
  late Future<DocumentSnapshot> userData;

  String _getResultText(double percentage) {
    if (percentage < 35) {
      return 'You Failed';
    } else if (percentage >= 35 && percentage < 50) {
      return 'Barely Passed';
    } else if (percentage >= 50 && percentage < 70) {
      return 'Good';
    } else if (percentage >= 70 && percentage < 90) {
      return 'Great';
    } else {
      return 'Excellent Result';
    }
  }

  Color _getResultColor(double percentage) {
    if (percentage < 35) {
      return Colors.red;
    } else if (percentage >= 35 && percentage < 50) {
      return Colors.orange;
    } else if (percentage >= 50 && percentage < 70) {
      return Colors.yellow;
    } else if (percentage >= 70 && percentage < 90) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  @override
  void initState() {
    super.initState();
    userData = getUserData(widget.user.uid);
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    return await FirebaseFirestore.instance.collection('Marks').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marks'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Marks data not found.'));
          } else {
            Map<String, dynamic> marksData =
                snapshot.data!.data() as Map<String, dynamic>;
            Map<String, dynamic> subjects = marksData['subjects'];
            int totalMarks = marksData['total_marks'];
            int totalObtainedMarks =
                subjects.values.reduce((value, element) => value + element);
            double percentage = (totalObtainedMarks / 700) * 100;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 13.0,
                        percent: percentage / 100,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${percentage.toStringAsFixed(2)}%',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getResultText(percentage),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _getResultColor(percentage),
                              ),
                            ),
                          ],
                        ),
                        progressColor: Colors.green,
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  //   // child: Text(
                  //   //   'Marks for ${widget.user.email}:',
                  //   //   style: const TextStyle(
                  //   //     fontSize: 20,
                  //   //     fontWeight: FontWeight.bold,
                  //   //     color: Colors.blue,
                  //   //   ),
                  //   // ),
                  // ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      String subject = subjects.keys.elementAt(index);
                      int marks = subjects.values.elementAt(index);
                      return SubjectContainer(subject: subject, marks: marks);
                    },

                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Total Marks: $totalMarks',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
