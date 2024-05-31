// ignore_for_file: avoid_print

import 'package:athlete_surveyor/models/students_model.dart';
import 'package:athlete_surveyor/models/users/user_types.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:athlete_surveyor/services/users/user_repository.dart';
import 'package:flutter/material.dart';

class AddStudentPage extends StatefulWidget 
{
  // final StudentsModel studentsModel;
  final UserRepository userRepository;
  const AddStudentPage(this.userRepository, {super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> 
{
  // late String firstName, lastName;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _sportController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  /// Helper method, verifies all fields have valid data to avoid unwanted data in the DB
  bool areAllFieldsFilled(String email, String fname, String lname, String grade, String sport) {
    return email.isNotEmpty &&
     fname.isNotEmpty && 
     lname.isNotEmpty && 
     grade.isNotEmpty && 
     sport.isNotEmpty;
  }

  /// handle adding a new student athlete to the database
  void _submitForm() {
    // Validate form fields and retrieve data
    String name = _nameController.text;
    String firstName = name.substring(0, name.indexOf(' '));
    String lastName = name.substring(name.indexOf(' ') + 1);
    String grade = _gradeController.text;
    String sport = _sportController.text;
    String email = _emailController.text;

    if (areAllFieldsFilled(email, firstName, lastName, grade, sport)) {
      /// if all that's needed is present, build a [Student]
      Student newStudent = Student(
        userId: '', // This will be generated by the database
        username: email,
        firstName: firstName,
        lastName: lastName,
        grade: grade,
        sport: sport,
      );
    // widget.studentsModel.addStudentToDatabase(name, grade, sport).then((_) {
      widget.userRepository.addStudentToDatabase(newStudent).then((_) {
        // Clear form fields
        _nameController.clear();
        _gradeController.clear();
        _sportController.clear();
        _emailController.clear();

        // Navigate back to the previous screen
        Navigator.pop(context);
      }).catchError((error) {
        // Handle error
        print('Error adding student: $error');
        // Show error message to the user
      });
    } else {
      // Handle validation error
      print('Please fill in all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        buildContext: context, 
        title: "Add New Athlete", 
        hasBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Athlete Information',
                style: TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 20), 
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://via.placeholder.com/150', 
                  width: 150,
                  height: 150,
                ),
                const SizedBox(width: 16.0), 
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Email: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Name: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), 
                      Row(
                        children: [
                          const Text(
                            'Grade: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _gradeController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), 
                      Row(
                        children: [
                          const Text(
                            'Sport: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _sportController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), 
            Center(
              child: ElevatedButton(
                onPressed: () => _submitForm(),
                child: const Text('Add Student'),
              ),
            ),
            const SizedBox(height: 5), 
            Column(
              children: [
                const Text("Analytics of 'Student's name'"),
                Image.network(
                  'https://via.placeholder.com/400', 
                  width: 390,
                  height: 390,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}