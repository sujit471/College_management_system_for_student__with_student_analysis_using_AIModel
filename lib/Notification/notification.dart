import 'dart:async';
import 'dart:convert';
import 'package:college_management_app/Api/modelforlistview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../login_UI_yt/logintry.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _CalendarState();
}

class _CalendarState extends State<Notifications> {
  DateTime today = DateTime.now();
  late Timer _timer;
  void _ondayselected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      startTimer();
    });
  }
  List<SamplePosts> samplePosts =[];
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
  @override
  Widget build(BuildContext context ) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Welcome"),),
      body: Column(
        children: [
          SizedBox(height: 50),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue, width: 3),
            ),
            // height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TableCalendar(
                locale: "en_US",
                rowHeight: 43,
                headerStyle: const HeaderStyle(
                    formatButtonVisible: false, titleCentered: true),
                focusedDay: today,
                selectedDayPredicate: (day) => isSameDay(day, today),
                firstDay: DateTime.utc(1999, 1, 1),
                lastDay: DateTime.utc(2050, 1, 1),
                onDaySelected: _ondayselected,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 2,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder(
                future: getData(),// using this line we are calling the api from  the link
                builder: (context, snapshot) {
                  //Snapshot is the result of the Future or Stream you are listening to in your FutureBuilder.
                  // Before interacting with the data being returned and using it in your builder, you have to access it first.
                  // To access this data, which is technically being delivered indirectly to you, by your FutureBuilder, you need to ask FutureBuilder for it.
                  // You do this by first, saying snapshot, because that is the nickname so to speak you told Flutter that you will be using,
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: samplePosts.length, // Replace with the actual number of items
                      itemBuilder: ( context, int index) {
                        return Container(
                          height: 130,
                          color: Colors.greenAccent,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          margin: EdgeInsets.all(10),
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('User id : (${samplePosts[index].id})/2',style: TextStyle(fontSize: 18),),
                              Text('Name : ${samplePosts[index].username}',style: TextStyle(fontSize: 18),),
                              Text('User Name: ${samplePosts[index].name}',style: TextStyle(fontSize: 18),),
                              Text('email : ${samplePosts[index].email}',style: TextStyle(fontSize: 18),)
                            ],
                          ),
                        );
                      },
                    );
                  }
                  else{
                    return  Center(child: Lottie.asset('animations/loadinganimation.json',height: 200,fit: BoxFit.fill),);
                  }

                }
            ),
          ),
        ],
      ),
    );

  }
  Future<List<SamplePosts>> getData() async{
    final response = await  http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var data = jsonDecode((response.body.toString()));
    if(response.statusCode == 200){
      for(Map<String,dynamic>index in data ){
        samplePosts.add(SamplePosts.fromJson(index));
      }
      return samplePosts;

    }
    else{
      return samplePosts;
    }
  }
}
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter API Example',
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   double result = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     // Replace 'your-api-endpoint' with the actual API endpoint
//     final response = await http.get(Uri.parse('https://your-api-endpoint'));
//
//     if (response.statusCode == 200) {
//       // Assuming the API response is a JSON object with two numbers
//       final data = json.decode(response.body);
//       double number1 = data['number1'];
//       double number2 = data['number2'];
//
//       // Perform the division
//       setState(() {
//         result = number1 / number2;
//       });
//     } else {
//       // Handle error
//       print('Failed to load data: ${response.statusCode}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('API Example'),
//       ),
//       body: Center(
//         child: Text(
//           'Result: ${result.toStringAsFixed(2)}', // Display the result with 2 decimal places
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }
// here  is the example of a

