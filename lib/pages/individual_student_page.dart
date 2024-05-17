// ignore_for_file: dangling_library_doc_comments, library_private_types_in_public_api

/// Name:Amanda Dorsey
/// Date: 5/17/24
/// Description: this is the page that displayes the individuals students information
/// such as name, grade, sport and ID. It also allows the admin to make changes to each one(
/// grade, sport and ID)
/// Bugs:none
/// Reflection:getting the editing to work was tricky, but an interesting feature to put on 
/// the app. Decorating the screen was also hard, as I never liked what I designed and wish 
/// I had more time to do so.

import 'package:flutter/material.dart';
import 'package:athlete_surveyor/models/student_model.dart';

class IndividualStudentScreen extends StatefulWidget {
  final Student studentData;
  final StudentsModel studentsModel;

  // ignore: use_super_parameters
  const IndividualStudentScreen({Key? key, required this.studentData, required this.studentsModel}) : super(key: key);

  @override
  _IndividualStudentScreenState createState() => _IndividualStudentScreenState();
}

class _IndividualStudentScreenState extends State<IndividualStudentScreen> {
  bool _isEditing = false;
  //texts feild being crearted for use
  late TextEditingController _nameController;
  late TextEditingController _gradeController;
  late TextEditingController _sportController;
  late TextEditingController _idController;

  @override
  void initState() {
    super.initState();//the text feilds  being assigned the variable
    _nameController = TextEditingController(text: widget.studentData.name);
    _gradeController = TextEditingController(text: widget.studentData.grade);
    _sportController = TextEditingController(text: widget.studentData.sport);
    _idController = TextEditingController(text: widget.studentData.id);
  }

  @override
  void dispose() {//texts feilds beings disposed on 
    _nameController.dispose();
    _gradeController.dispose();
    _sportController.dispose();
    _idController.dispose();
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
              setState(() {//the text that is edited that will go and call update student-which will in turn update the database
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  widget.studentsModel.updateStudentInDatabase(
                    widget.studentData.name,
                    _nameController.text,
                    _gradeController.text,
                    _sportController.text,
                    _idController.text,
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
                          'lib/resources/images/individual-icon-1.png',
                          width: 200,
                          height: 200,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(//start of what can be edited on the individual students page.
                      child: _isEditing //if the _isEditing is true it will allow the admin to edit the text
                          ? TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(labelText: 'Name'),
                            )
                          : Text(
                              widget.studentData.name, //displayes the name associated with that student
                              textAlign: TextAlign.center, 
                              overflow: TextOverflow.ellipsis, //if there is overflow it will truncate it with ()
                              maxLines: 2,  //limits the answer to 2 lines
                              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 20),
                          _isEditing//if the _isEditing is true it will allow the admin to edit the text
                              ? TextFormField(
                                  controller: _gradeController,
                                  decoration: const InputDecoration(labelText: 'Grade'),
                                )
                              : Text('Grade: ${widget.studentData.grade}'),
                          const SizedBox(height: 20),
                          _isEditing//if the _isEditing is true it will allow the admin to edit the text
                              ? TextFormField(
                                  controller: _sportController,
                                  decoration: const InputDecoration(labelText: 'Sport'),
                                )
                              : Text('Sport: ${widget.studentData.sport}'),
                          const SizedBox(height: 20),
                          _isEditing//if the _isEditing is true it will allow the admin to edit the text
                              ? TextFormField(
                                  controller: _idController,
                                  decoration: const InputDecoration(labelText: 'ID'),
                                )
                              : Text('ID: ${widget.studentData.id}'),
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
                  Text('Forms Filled Out'), //shows what forms is associated witht he student
                  SizedBox(height: 20), //seperates the form titles from the text "Forms filled out" with 20px of room
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
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ElevatedButton( // Not finished for lack of time.
                    //   onPressed: _caution,
                    //   child: Text('Caution'),
                    // ),
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

// void _caution() {
//   // Define the action to be performed when the button is pressed
// }
