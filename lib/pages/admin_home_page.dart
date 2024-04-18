import 'package:athlete_surveyor/models/student_model.dart';
import 'package:athlete_surveyor/pages/students_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Welcome, [NAME]', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),//TODO: replace [NAME] with actual data pulled from login.
                Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(onPressed:(){ navigateToPage(context, Students(StudentsModel())); }, 
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                        child: const SizedBox(width: 200, height: 50, child: Center(child: Text('View Student Forms', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(onPressed: null, 
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                        child: const SizedBox(width: 200, height: 50, child: Center(child: Text('Create a Form', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
                    )
                  ],
                )
              ],
            );
  }
}