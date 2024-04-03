// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

/// Screen Two B is the alternate screen two, only meant to be seen by administrative users.
/// It allows administrative users to Create a form, View Student Forms or navigate to a page on the appBar.

class ScreenTwoB extends StatelessWidget {
  const ScreenTwoB({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      // Navigation buttons in the AppBar
      appBar: AppBar(title: const Text('Home'), actions:[
        ElevatedButton(onPressed: null, child: const Text("Inbox")),
        ElevatedButton(onPressed: null, child: const Text("Messages")),
        ElevatedButton(onPressed: null, child: const Text("Forms")),
      ], backgroundColor: Colors.yellow),
      // Container Centers the column
      body: Container(alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Welcome text
            const Text('Welcome, [NAME]', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            //Column contains two padded buttons for the user to interact with
            Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: null, 
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                    child: SizedBox(width: 200, height: 50, child: Center(child: Text('View Student Forms', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: null, 
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                    child: SizedBox(width: 200, height: 50, child: Center(child: Text('Create a Form', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
                )
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}