import 'package:flutter/material.dart';
class Imageviewer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Academic Calendar 2080'),
        ),
        body: Center(
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 5,
            child: Image.asset(
              'svgimage/academic calendar.png', // Replace this with the path to your image asset
              width: 360, // Adjust the width as needed
              height: 800, // Adjust the height as needed

            ),
          ),
        ),
      ),
    );
  }
}
