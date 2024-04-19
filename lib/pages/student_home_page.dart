import 'package:flutter/material.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Welcome, [NAME]', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold), textAlign: TextAlign.center), //TODO: replace [NAME] with actual data pulled from login.
                  ElevatedButton(onPressed: null, 
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                    child: const SizedBox(child: Center(child: Text('Complete a Self-Inventory Survey', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,))))
                ]),
    );
  }
}