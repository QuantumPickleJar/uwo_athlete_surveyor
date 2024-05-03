import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../individual_student_page.dart'; // Import the individual student screen
import '../add_athlete_page.dart'; // Import the add athlete screen
import '/models/student_model.dart';


class StudentsWidget extends StatefulWidget {
  final StudentsModel studentModel;

  const StudentsWidget(this.studentModel, {Key? key}) : super(key: key);

  @override
  State<StudentsWidget> createState() => _StudentsWidgetState();
}

class _StudentsWidgetState extends State<StudentsWidget> {
  // defaults _sortBy 
  bool _sortBySport = false;
  bool _sortByGrade = false;

  @override
  void initState() {
    super.initState();
    // Fetch students from the database when the widget is initialized
    widget.studentModel.fetchStudentsFromDatabase();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 60),
              const Text(
                "Filter",
                style: TextStyle(fontSize: 30),
              ),
              Expanded(
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _sortBySport = false;
                            _sortByGrade = true;
                            widget.studentModel.sortBySport(); // Call sorting method
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
                          widget.studentModel.sortByGrade();
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
                            children: [
                              Text(studentModel.students[index].grade),
                              Text(studentModel.students[index].sport),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              _moreInfo(
                                context,
                                studentModel.students[index],
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.yellow,
                              ),
                            ),
                            child: const Text('More Info'),
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
    );
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
      MaterialPageRoute(builder: (context) => AddStudent(widget.studentModel)),
    );
  }
}
