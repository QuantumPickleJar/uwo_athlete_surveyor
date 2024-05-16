// ignore_for_file: dangling_library_doc_comments

/// Name: Amanda Dorsey
/// Date:5/17/24
/// Description: This is the screen that shows all the students in the database. It
/// allows the admint o see grade and sport and also to press the 'more info' button to
/// go to that students specific page/profile. The admin can also delete the student 
/// from this page and also add athlete by pressing the "Add Athlete" button
/// Bugs: none
/// Reflection: Decorating was the most fun for me since I had a lot of freedom and this
/// page was easier to design than others.

import 'package:athlete_surveyor/resources/colors.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../individual_student_page.dart'; // Import the individual student screen
import '../add_athlete_page.dart'; // Import the add athlete screen
import '/models/student_model.dart';
import 'dart:ui';

class StudentsWidget extends StatefulWidget {
  final StudentsModel studentModel;

  const StudentsWidget(this.studentModel, {super.key});

  @override
  State<StudentsWidget> createState() => _StudentsWidgetState();
}

class _StudentsWidgetState extends State<StudentsWidget> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Clear existing students before fetching from the database
    widget.studentModel.students.clear();
    // Fetch students from the database when the widget is initialized
    widget.studentModel.fetchStudentsFromDatabase();
  }

 //depending on what the selectedIdnex is set at it will display the students in sort by grade or sport. Default is by sport
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        widget.studentModel.sortBySport();
      } else if (_selectedIndex == 1) {
        widget.studentModel.sortByGrade();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        buildContext: context, 
        title: "Students", 
        hasBackButton: false
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Students",
                  style: TextStyle(fontSize: 50),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _addAthlete(context); // Pass context to the function
                    });
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    backgroundColor: MaterialStateProperty.all<Color>(titanYellow),
                  ),
                  child: const Text("Add Athlete"),
                ),
              ],
            ),
          ),
          Consumer<StudentsModel>(
            builder: (context, studentModel, _) {
              return Expanded(
                child: ListView.builder(
                  itemCount: studentModel.students.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Off-white background color
                          borderRadius: BorderRadius.circular(8.0), // Rounded corners
                        ),
                        child: ListTile(
                          title: Text(studentModel.students[index].name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ //displays the grade and sport associated with the student
                              Text(studentModel.students[index].grade),
                              Text(studentModel.students[index].sport),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _moreInfo(
                                    context,
                                    studentModel.students[index],
                                  );
                                },
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    titanYellow
                                  ),
                                ),
                                child: const Text('More Info'),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {//passes in the students information so the computer knows what student to delete
                                  widget.studentModel.deleteStudent(
                                    studentModel.students[index].name,
                                    studentModel.students[index].grade,
                                    studentModel.students[index].sport,
                                    studentModel.students[index].id,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      //start of the bottom naviagation that holds the filter by grade and sport
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports),
            label: 'Sort by Sport',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Sort by Grade',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white, //when the filter is selected it will turn white
        onTap: _onItemTapped, 
        backgroundColor: titanYellow,
      ),
    );
  }
  //pushes the user to the screen that will display the individual students information
  void _moreInfo(BuildContext context, Student studentData) {
    final studentsModel = Provider.of<StudentsModel>(context, listen: false); // Assuming StudentsModel is provided higher up the widget tree
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => IndividualStudentScreen(studentData: studentData, studentsModel: studentsModel)),
    );
  }

 //pushed to the add athlete page
  void _addAthlete(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return AddStudent(widget.studentModel);
      }),
    );
  }
}
