import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/circular_percent_indicator.dart'; // Importing the circular percent indicator
import 'package:table_calendar/table_calendar.dart';

class AttendanceScreenss extends StatefulWidget {
  final User user;

  AttendanceScreenss({Key? key, required this.user}) : super(key: key);

  @override
  _AttendanceScreenssState createState() => _AttendanceScreenssState();
}

class _AttendanceScreenssState extends State<AttendanceScreenss> {
  late Stream<DocumentSnapshot> attendanceDataStream;
  final CollectionReference attendanceCollection =
  FirebaseFirestore.instance.collection('student_attendance');

  Map<DateTime, bool> markedDates = {};

  @override
  void initState() {
    super.initState();
    attendanceDataStream = getAttendanceDataStream(widget.user.uid);
    fetchAttendanceRecords();
  }

  Stream<DocumentSnapshot> getAttendanceDataStream(String uid) {
    return FirebaseFirestore.instance
        .collection('student_attendance')
        .doc(uid)
        .snapshots();
  }

  Future<void> fetchAttendanceRecords() async {
    try {
      QuerySnapshot querySnapshot = await attendanceCollection.get();
      querySnapshot.docs.forEach((doc) {
        if (doc.exists) {
          Timestamp timestamp = doc['last_attendance_date'];
          DateTime date = timestamp.toDate();
          markedDates[date] = true; // Mark the date as attended
        }
      });
      setState(() {}); // Update the UI
    } catch (e) {
      print('Error fetching attendance records: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Data'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TableCalendar(
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, date, _) {
                          // Define default style for calendar cells
                          return Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: markedDates[date] == true
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            child: Text(
                              date.day.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        selectedDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange,
                        ),
                      ),
                      availableGestures: AvailableGestures.none,
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekendStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      headerStyle: const HeaderStyle(
                        // centerHeaderTitle: true,
                        formatButtonVisible: false,
                      ),
                      focusedDay: DateTime.now(),
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2025, 12, 31),
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: attendanceDataStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('Attendance data not found.'));
              } else {
                int userAttendance =
                    (snapshot.data?['attendance_count'] as int?) ?? 0;
                double attendancePercentage =
                    (userAttendance / 30) * 100; // Assuming 30 days in a month

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularPercentIndicator(
                          radius: 120.0,
                          lineWidth: 13.0,
                          percent: attendancePercentage / 100,
                          center: Text(
                            "${attendancePercentage.toStringAsFixed(2)}%",
                            style: const TextStyle(fontSize: 20.0),
                          ),
                          progressColor: Colors.blue,
                          animation: true,
                          animationDuration: 1000,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Attendance Count: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '$userAttendance',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )

                            // Add more fields as needed
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
