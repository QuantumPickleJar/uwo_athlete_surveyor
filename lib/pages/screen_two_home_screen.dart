// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

/// Screen Two, this version is for students. The student user can navigate to a page on the appbar, or navigate to a page where they can
/// complete a survey/form.

import 'package:flutter/material.dart';

class ScreenTwo extends StatelessWidget {
  const ScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      /// Appbar with  buttons to navigate to other screens
      appBar: AppBar(title: const Text('Home'), actions:[
        ElevatedButton(onPressed: null, child: const Text("Inbox")),
        ElevatedButton(onPressed: null, child: const Text("Messages")),
        ElevatedButton(onPressed: null, child: const Text("Forms")),
      ], backgroundColor: Colors.yellow),
      /// Container to align the column
      body: Container(alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //Welcome text
            const Text('Welcome, [NAME]', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            // Button that will take student to screen that allows them to fill out a form.
            ElevatedButton(onPressed: null, 
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
              child: SizedBox(width: 250, height: 75, child: Center(child: Text('Complete a Self-Inventory Survey', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)))),
          ],
        ),
      ),
    );
  }
}