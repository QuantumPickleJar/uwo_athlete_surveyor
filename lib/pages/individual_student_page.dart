import 'package:flutter/material.dart';
import 'package:athlete_surveyor/models/student_model.dart';
//import '/models/student_model.dart'; 
class IndividualStudentScreen extends StatefulWidget {
  final Student studentData;
  final StudentsModel studentsModel; // Add this line

   IndividualStudentScreen({Key? key, required this.studentData, required this.studentsModel}) : super(key: key); // Modify this line

  @override
  _IndividualStudentScreenState createState() => _IndividualStudentScreenState();
}

class _IndividualStudentScreenState extends State<IndividualStudentScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _gradeController;
  late TextEditingController _sportController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.studentData.name);
    _gradeController = TextEditingController(text: widget.studentData.grade);
    _sportController = TextEditingController(text: widget.studentData.sport);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gradeController.dispose();
    _sportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editing ${widget.studentData.name}' : widget.studentData.name),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                widget.studentsModel.updateStudentInDatabase(
                  widget.studentData.name, // Original name of the student
                  _nameController.text,    // New name entered in the text field
                  _gradeController.text,
                  _sportController.text
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/resources/images/individual-icon-1.png', // Load image from images
                          width: 200,
                          height: 200,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: _isEditing
                          ? TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(labelText: 'Name'),
                            )
                          : Text(
                              widget.studentData.name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2, // Set maximum number of lines to 2
                              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _isEditing
                              ? TextFormField(
                                  controller: _gradeController,
                                  decoration: InputDecoration(labelText: 'Grade'),
                                )
                              : Text('Grade: ${widget.studentData.grade}'),
                          const SizedBox(height: 20),
                          _isEditing
                              ? TextFormField(
                                  controller: _sportController,
                                  decoration: InputDecoration(labelText: 'Sport'),
                                )
                              : Text('Sport: ${widget.studentData.sport}'),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
             
              const SizedBox(height: 20),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Forms Filled Out'),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Form 1'),
                      ),
                      Text('1-1-1'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Form 2'),
                      ),
                      Text('1-1-1'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Form 3'),
                      ),
                      Text('1-1-1'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Analytics'),
                    Image.network(
                      'https://via.placeholder.com/300', // Replace with the student's headshot
                      width: 300,
                      height: 300,
                    ),
                    const SizedBox(width: 20),
                    const ElevatedButton(
                      onPressed: _caution,
                      child: Text('Caution'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _caution() {
  // Define the action to be performed when the button is pressed
}
