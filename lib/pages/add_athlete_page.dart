import 'package:athlete_surveyor/models/student_model.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 


class AddStudent extends StatefulWidget {
  final StudentsModel student_model;
  const AddStudent(this.student_model, {Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _sportController = TextEditingController();

  void _addStudent(BuildContext context) {
    
    widget.student_model.addStudent(
      Student(name: _nameController.text, grade: _gradeController.text, sport: _sportController.text,)
    );
    Navigator.pop(context); // Pop the AddStudent page from the navigation stack
  }


  @override
  Widget build(BuildContext context) {
    //final studentModel = Provider.of<StudentsModel>(context, listen: false);
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
                onPressed: () => _addStudent,
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
