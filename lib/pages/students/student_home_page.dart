import 'package:flutter/material.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Welcome, [NAME]', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)), //TODO: replace [NAME] with actual data pulled from login.
                ElevatedButton(onPressed: null, 
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                  child: const SizedBox(width: 250, height: 75, child: Center(child: Text('Complete a Self-Inventory Survey', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,))))
              ]);
  }
}