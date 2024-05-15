// ignore_for_file: dangling_library_doc_comments

/// Name:
/// Date:
/// Description:
/// Bugs:
/// Reflection:

import 'package:flutter/material.dart';
import 'package:athlete_surveyor/models/student_model.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';

const Color titanYellow1 = Color(0xFFFFCC00);

class AddStudent extends StatefulWidget {
  final StudentsModel studentsModel;

  const AddStudent(this.studentsModel, {super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _sportController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  void _submitForm() {
    // Validate form fields and retrieve data
    String name = _nameController.text;
    String grade = _gradeController.text;
    String sport = _sportController.text;
    String id = _idController.text;

    widget.studentsModel.addStudentToDatabase(name, grade, sport, id).then((_) {
      // Clear form fields
      _nameController.clear();
      _gradeController.clear();
      _sportController.clear();
      _idController.clear();
      // Navigate back to the previous screen
      Navigator.pop(context);
    }).catchError((error) {
      // Handle error
      print('Error adding student: $error');
      // Show error message to the user
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        buildContext: context, 
        title: "Add New Athlete", 
        hasBackButton: true
      ),
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
            _buildTextFieldRow('Name:', _nameController),
            const SizedBox(height: 10),
            _buildTextFieldRow('Grade:', _gradeController),
            const SizedBox(height: 10),
            _buildTextFieldRow('Sport:', _sportController),
            const SizedBox(height: 10),
            _buildTextFieldRow('ID:', _idController),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor: MaterialStateProperty.all<Color>(titanYellow1),
                ),
                child: const Text('Add Student'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldRow(String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
