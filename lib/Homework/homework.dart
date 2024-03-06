
import 'package:flutter/material.dart';

import 'epp.dart';

class Homework extends StatelessWidget {
  const Homework({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Eighth Semester")),
      ),
      body: MyList(),
    );
  }
}

class MyList extends StatelessWidget {
  final List<String> items = [
    'Telecommunication',
    'Engineering Professional Practice',
    'Energy Environment and Society',
    'Information System',
    'Multimedia',
    'Big Data',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          child: MyExpansionTile(item: items[index]),
          padding: const EdgeInsets.all(16.0),
          margin: EdgeInsets.all(8.0),
          decoration:BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.cyan[100],


          ),
        );
      },
    );
  }
}

class MyExpansionTile extends StatefulWidget {
  final String item;

  const MyExpansionTile({Key? key, required this.item}) : super(key: key);

  @override
  _MyExpansionTileState createState() => _MyExpansionTileState();
}

class _MyExpansionTileState extends State<MyExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.item),
          trailing: GestureDetector(
            onTap: () {
              // Handle the tap on the trailing icon
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Icon(
              color:Colors.white,
              _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            ),
          ),
          onTap: () {
            // Handle the tap on the main ListTile
            _handleItemTap(context, widget.item);
          },
        ),
        if (_isExpanded) ...[
          // Additional information or widgets you want to display when expanded
          ListTile(
            title: Text('Additional Info for ${widget.item}'),
          ),
          // Add more widgets if needed
        ],

      ],
    );
  }
}

void _handleItemTap(BuildContext context, String itemName) {
  // Implement your logic to navigate to different pages based on the tapped item
  switch (itemName) {


    case 'Engineering Professional Practice':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EngineeringProfessionalPracticePage(),
        ),
      );
      break;
  // Add more cases for other items
    default:
    // Handle the default case or add more logic as needed
      break;
  }
}

