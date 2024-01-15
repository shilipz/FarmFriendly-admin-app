import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedChoice = 'Choice 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choice Chips Example'),
      ),
      body: Center(
        child: Wrap(
          spacing: 8.0,
          children: [
            ChoiceChip(
              label: Text('Choice 1'),
              selected: selectedChoice == 'Choice 1',
              onSelected: (selected) {
                setState(() {
                  selectedChoice = selected ? 'Choice 1' : '';
                });
              },
            ),
            ChoiceChip(
              label: Text('Choice 442'),
              selected: selectedChoice == 'Choice 222',
              onSelected: (selected) {
                setState(() {
                  selectedChoice = selected ? 'Choice 25555' : '';
                });
              },
            ),
            ChoiceChip(
              label: Text('Choice 3'),
              selected: selectedChoice == 'Choice 3',
              onSelected: (selected) {
                setState(() {
                  selectedChoice = selected ? 'Choice 3' : '';
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
