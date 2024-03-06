import 'package:flutter/material.dart';

class Activity {
  final String title;
  final String description;
  final String time;

  Activity(this.title, this.description, this.time);
}

class Activities extends StatelessWidget {
  final List<Activity> activities = [
    Activity(
      'Seminar on Machine Learning',
      'Learn about the latest trends in machine learning.',
      '9:00 AM - 11:00 AM',
    ),
    Activity(
      'Workshop on Mobile App Development',
      'Hands-on workshop on building mobile apps using Flutter.',
      '11:30 AM - 1:30 PM',
    ),
    Activity(
      'Panel Discussion on Cybersecurity',
      'Join industry experts for a discussion on cybersecurity.',
      '2:00 PM - 4:00 PM',
    ),
    Activity(
      'Cultural Event - Dance Competition',
      'Showcase your dancing talent in this competition.',
      '4:30 PM - 6:30 PM',
    ),
    Activity(
      'Guest Lecture on Entrepreneurship',
      'Learn from successful entrepreneurs about startup strategies.',
      '7:00 PM - 9:00 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'College Activities',
      home: Scaffold(
        appBar: AppBar(
          title: Text('College Activities'),
        ),
        body: ListView.builder(
          itemCount: activities.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  activities[index].title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(activities[index].description),
                    SizedBox(height: 4.0),
                    Text(
                      'Time: ${activities[index].time}',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


