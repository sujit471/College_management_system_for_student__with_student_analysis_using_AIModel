import 'package:table_calendar/table_calendar.dart';
import'package:flutter/material.dart';
class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime today = DateTime.now();
  void _ondayselected(DateTime day, DateTime focusedDay){
    setState(() {
      today = day;
    });

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Welcome"),),
      body:  Column(
        children: [
          Container(
            child:TableCalendar(
              locale: "en_US",
              rowHeight: 43,
              headerStyle: const HeaderStyle(formatButtonVisible: false,titleCentered: true),
              focusedDay: today,
              selectedDayPredicate: (day)=> isSameDay(day,today),
              firstDay: DateTime.utc(1999,1,1),
              lastDay: DateTime.utc(2050,1,1),
              onDaySelected: _ondayselected,
            ) ,
          )
        ],
      ),
    );

    }
  }

