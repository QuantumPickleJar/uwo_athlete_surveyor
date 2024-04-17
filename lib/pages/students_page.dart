import 'package:flutter/material.dart';
import 'individual_student.dart'; // Import the individual student screen
import 'add_athlete.dart'; // Import the add athlete screen

void main() {
  runApp(MaterialApp( // Wrap the Students widget with MaterialApp
   home: const Students(),
  ));
}

class Student {//sets what each cluan will comprise of
  String name;
  String grade;
  String sport;

  Student({required this.name, required this.grade, required this.sport});
}

class Students extends StatefulWidget {
  const Students({Key? key}) : super(key: key);

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  // Define sorting criteria
  bool _sortBySport = false;
  bool _sortByGrade = false;

  @override
  Widget build(BuildContext context) {
    // Sample data for the list
    List<Map<String, dynamic>> dataList = [
      {
        'name': 'Zucy Doe',
        'grade': 'Grade: 9',
        'sport': 'Sport: Tennis',
        'image': 'assets/download-7.jpg', // Path to your image asset
      },
      
      
      
    ];

    // Sort data based on sorting criteria
    if (_sortBySport) {
      dataList.sort((a, b) => a['sport'].compareTo(b['sport']));
    } else if (_sortByGrade) {
      dataList.sort((a, b) => a['grade'].compareTo(b['grade']));
    }

    return Scaffold( // Removed MaterialApp since it's already wrapped by the one in main
      appBar: AppBar(
        title: const Text('Your App Title'),
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
                    _addAthlete(context); // Pass context to the function
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
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      dataList[index]['image'], // Load image from asset
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(dataList[index]['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dataList[index]['grade']),
                      Text(dataList[index]['sport']),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _moreInfo(context, dataList[index]);
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

  void _moreInfo(BuildContext context, Map<String, dynamic> studentData) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => IndividualStudentScreen(studentData: studentData)),
    );
  }

  void _addAthlete(BuildContext context) {
    // Navigate to the AddStudent screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddStudent()),
    );
  }
}
