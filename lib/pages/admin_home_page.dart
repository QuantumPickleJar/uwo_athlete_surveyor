import 'package:athlete_surveyor/models/student_model.dart';
import 'package:athlete_surveyor/pages/students_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Welcome, [ADMIN_NAME]', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold), textAlign: TextAlign.center),//TODO: replace [NAME] with actual data pulled from login.
                  Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed:(){ navigateToPage(context, Consumer<StudentsModel> (builder: (context, studentsModel, child) => StudentsWidget(studentsModel))); }, 
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                        child: const SizedBox(child: Center(child: Text('View Student Forms', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
                      ElevatedButton(onPressed: null, 
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                        child: const SizedBox(child: Center(child: Text('Create a Form', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))))])]));
  }
}