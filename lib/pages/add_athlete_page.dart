// ignore_for_file: avoid_print

import 'dart:io';

import 'package:athlete_surveyor/models/student_model.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';


class AddStudent extends StatefulWidget 
{
  final StudentsModel studentsModel;
  const AddStudent(this.studentsModel, {super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _sportController = TextEditingController();
  String? _imageUrl; // Store the URL of the picked image

Future<void> _pickImage() async {
  final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

  setState(() {
    if (pickedFile != null) {
      _imageUrl = pickedFile.path;
    } else {
      print('No image selected.');
    }
  });
}

  

  void _submitForm() {
    // Validate form fields and retrieve data
    String name = _nameController.text;
    String grade = _gradeController.text;
    String sport = _sportController.text;

    widget.studentsModel.addStudentToDatabase(name, grade, sport)
        .then((_) {
      // Clear form fields
      _nameController.clear();
      _gradeController.clear();
      _sportController.clear();

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
        hasBackButton: true,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Column(
                children: [
                  _imageUrl != null
                  ? Image.file(
                      File(_imageUrl!), // Display the picked image if available
                      width: 150,
                      height: 150,
                    )
                  : GestureDetector(
                      onTap: _pickImage, // Call _pickImage method when tapped
                      child: Container(
                        width: 150,
                        height: 150,
                        color: Colors.grey, // Placeholder for the image
                        child: Icon(Icons.add_photo_alternate),
                      ),
                    ),
                    ElevatedButton(onPressed: () {
                      _pickImage(); // Call _pickImage to select an image
                      _submitForm(); // Call _submitForm to submit the form
                    }, child: Text('Insert Image')),
                ],
              ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

