import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Student Data Upload'),
        ),
        body: Center(
          child: StudentForm(),
        ),
      ),
    );
  }
}

class StudentForm extends StatefulWidget {
  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  final String apiUrl = 'https://jsonplaceholder.typicode.com/users';

  void sendStudentData() async {
    Map<String, dynamic> data = {
      'name': nameController.text,
      'roll': rollController.text,
      'id': idController.text,
    };

    await uploadData(apiUrl, data);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Student Name'),
        ),
        TextField(
          controller: rollController,
          decoration: InputDecoration(labelText: 'Roll'),
        ),
        TextField(
          controller: idController,
          decoration: InputDecoration(labelText: 'Student ID'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: sendStudentData,
          child: Text('Send'),
        ),
      ],
    );
  }
}

Future<void> uploadData(String apiUrl, Map<String, dynamic> data) async {
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: data,
    );

    if (response.statusCode == 200) {
      // Successful upload, handle the response if needed
      print('Data uploaded successfully');
    } else {
      // Handle errors, check response.statusCode and response.body
      print('Error uploading data: ${response.statusCode}');
    }
  } catch (e) {
    // Handle network errors or other exceptions
    print('Exception during data upload: $e');
  }
}
