import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'individual_student_page.dart'; // Import the individual student screen
import 'add_athlete_page.dart'; // Import the add athlete screen
import '/models/student_model.dart';


class StudentsWidget extends StatefulWidget {
  final StudentsModel studentModel;
  const StudentsWidget(this.studentModel, {Key? key}) : super(key: key);

  @override
  State<StudentsWidget> createState() => _StudentsWidgetState();
}

class _StudentsWidgetState extends State<StudentsWidget> {
  // Define sorting criteria
  bool _sortBySport = false;
  bool _sortByGrade = false;

  @override
  void initState()
  {
    super.initState();

    widget.studentModel.fetchStudentsFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
  
  //var model_of_student = Provider.of<StudentsModel>;
    // Sort data based on sorting criteria
    if (_sortBySport) {
      widget.studentModel.students.sort((a, b) => a.sport.compareTo(b.sport));
    } else if (_sortByGrade) {
      widget.studentModel.students.sort((a, b) => a.grade.compareTo(b.grade));
    }

    return Scaffold( // Removed MaterialApp since it's already wrapped by the one in main
      appBar: defaultAppBar(
        buildContext: context, 
        title: "Students", 
        hasBackButton: false),
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
              itemCount: widget.studentModel.students.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      'assets/download-7.jpg', // Load image from asset
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(widget.studentModel.students[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.studentModel.students[index].grade),
                      Text(widget.studentModel.students[index].sport),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _moreInfo(context, widget.studentModel.students[index]);
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
