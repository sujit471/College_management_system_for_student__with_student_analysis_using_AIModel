import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EngineeringProfessionalPracticePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homework List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: subjects.map((subject) => SubjectHomeworkList(subject: subject)).toList(),
        ),
      ),
    );
  }
}

class SubjectHomeworkList extends StatelessWidget {
  final String subject;
  List<String> backGroundImages =[
   // 'svgimage/homework2.jpg',
    'svgimage/homework1.jpg',
    // 'svgimage/homework6.jpg',
    // 'svgimage/homework7.jpg',

  ];

  SubjectHomeworkList({required this.subject});

  DateTime? _parseDueDate(dynamic dueDateData) {
    if (dueDateData is Timestamp) {
      // If 'Due Date' is a Timestamp, cast it directly
      return dueDateData.toDate();
    } else if (dueDateData is String) {
      // If 'Due Date' is a String, parse it to DateTime
      return DateTime.tryParse(dueDateData);
    }
    return null; // Return null if unable to parse
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('homework')
          .where('subject', isEqualTo: subject)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No homework available for $subject'),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '$subject Homework',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var homework = snapshot.data!.docs[index];
                  DateTime? dueDate = _parseDueDate(homework['Due Date']);
                  // Format DateTime object as a string
                  String formattedDueDate = dueDate != null
                      ? DateFormat.yMMMMd().format(dueDate)
                      : 'Unknown';
                  var backgroundImages;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.redAccent,
                      boxShadow: [BoxShadow(blurRadius: 10,spreadRadius: 0.0,color: Colors.grey,blurStyle: BlurStyle.normal,offset: Offset.zero),],
                      image: DecorationImage(
                        image: AssetImage(backGroundImages[index % backGroundImages.length]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: 200, // Adjust the width according to your needs
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Homework: ${homework['title']}',
                            style: TextStyle(color: Colors.white, shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 6)]), // Add text shadow
                          ),
                          Text(
                            'Description: ${homework['description']}',
                            style: TextStyle(color: Colors.white, shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 6)]), // Add text shadow
                          ),
                          Text(
                            'Due Date: $formattedDueDate',
                            style: TextStyle(color: Colors.white, shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 6)]), // Add text shadow
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

final List<String> subjects = [
  'Telecommunication',
  'Information System',
  'Big Data',
  'Multimedia',
  'EPP',
  'Computer Science',
];
