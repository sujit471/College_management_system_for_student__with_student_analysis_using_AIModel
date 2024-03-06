import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';
import 'package:lottie/lottie.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> news = [];
  late DateTime _selectedDay;
  late Map<DateTime, List<dynamic>> _events;
  late CalendarFormat _calendarFormat;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _events = {};
    _calendarFormat = CalendarFormat.month;
    fetchNews();
  }

  Future<void> fetchNews() async {
    final response =
    await http.get(Uri.parse("https://shres58tha.pythonanywhere.com/news"));
    if (response.statusCode == 200) {
      setState(() {
        news = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      body: Column(
        children: <Widget>[
          _buildTableCalendar(),
          _isLoading
              ? Expanded(
            child: Center(
              child: Lottie.asset(
                'animations/loadinganimation.json',
                height: 200,
                fit: BoxFit.fill,
              ),
            ),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: news.length,
              itemBuilder: (BuildContext context, int index) {
                return NewsItem(
                  title: news[index]['strong'],
                  description: news[index]['div'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCalendar() {
    return Container(
      height: 370,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
      padding: const EdgeInsets.all(8.0),
      child: TableCalendar(
        calendarFormat: _calendarFormat,
        focusedDay: _selectedDay,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableGestures: AvailableGestures.horizontalSwipe,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
        },
        headerStyle: const HeaderStyle(
          titleTextStyle: TextStyle(fontSize: 16.0),
          formatButtonVisible: false,
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(color: Colors.white),
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
          });
        },
      ),
    );
  }
}

class NewsItem extends StatefulWidget {
  final String title;
  final String description;

  const NewsItem({required this.title, required this.description});

  @override
  _NewsItemState createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.amberAccent,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            expanded = !expanded;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              expanded ? widget.description : '${widget.description.substring(0, 100)}...',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            if (expanded)
              TextButton(
                onPressed: () {
                  setState(() {
                    expanded = false;
                  });
                },
                child: const Text('Show Less'),
              ),
          ],
        ),
      ),
    );
  }
}
