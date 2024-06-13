import 'package:athlete_surveyor/models/users/user_types.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../individual_student_page.dart'; // Import the individual student screen
import '../add_athlete_page.dart'; // Import the add athlete screen
import '../../models/students_model.dart';


class StudentsPage extends StatefulWidget {
  // final StudentsModel studentModel;
const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  // Define sorting criteria
  bool _sortBySport = false;
  bool _sortByGrade = false;

// @override
//   void initState() {
//     super.initState();
//     // Fetch students from the database when the widget is initialized
//     // widget.studentModel.fetchStudentsFromDatabase();
//     widget.studentModel.userRepository.fetchStudentsFromDatabase();
//   }

      @override Widget build(BuildContext context) { 
      return Consumer<StudentsModel>(
        builder: (context, studentsModel, child) {
          // Sorting logic should be applied after fetching students
          if (_sortBySport) {
            studentsModel.students.sort((a, b) => a.sport.compareTo(b.sport));
          } else if (_sortByGrade) {
            studentsModel.students.sort((a, b) => a.grade.compareTo(b.grade));
          }
        
          return Scaffold( // Removed MaterialApp since it's already wrapped by the one in main
            appBar: defaultAppBar(
              buildContext: context, 
              title: "Students", 
              hasBackButton: false
            ), 
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 60),
                    const Text("Filter",
                    style: TextStyle(fontSize: 30)),
                    Expanded(
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _sortBySport = true;
                                  _sortByGrade = false;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                              ),
                              child: const Text("Sport"),
                            ),
                            const SizedBox(width: 8), // Adds space between buttons
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _sortBySport = false;
                                  _sortByGrade = true;
                                });
                              },
                              style: ButtonStyle(
                               backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                              ),
                              child: const Text("Grade"),
                            ),
                            const SizedBox(width: 50), // Add space to the right of the "Grade" button
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                        ),
                        child: const Text("Add Athlete"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    /// This is coming from [Consumer], since this is a [StatelessWidget]
                    itemCount: studentsModel.students.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(studentsModel.students[index].fullName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(studentsModel.students[index].grade),
                            Text(studentsModel.students[index].sport),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _moreInfo(context, studentsModel.students[index]);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                          ),
                          child: const Text('More Info'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
      });
    }


  void _moreInfo(BuildContext context, Student studentData) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => IndividualStudentScreen(studentData: studentData)),
  );
}

  void _addAthlete(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddStudentPage()),
    );
  }
}

class StudentsPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentsModel>(
      builder: (context, studentsModel, child) {
        return StudentsPage();
      },
    );
  }
}
