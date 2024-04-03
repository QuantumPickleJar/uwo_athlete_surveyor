import 'package:flutter/material.dart';
import 'individual_student.dart'; // Import the individual student screen

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for the list
    List<Map<String, dynamic>> dataList = [
      {
    'title': 'Student 1',
    'subtitle1': 'Subtitle 1 for Student 1',
    'subtitle2': 'Subtitle 2 for Student 1',
    'image': 'assets/download-7.jpg', // Path to your image asset
  },
  {
    'title': 'Student 2',
    'subtitle1': 'Subtitle 1 for Student 2',
    'subtitle2': 'Subtitle 2 for Student 2',
    'image': 'assets/download-7.jpg', // Path to your image asset
  },
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Your App Title'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 60),
                Text("Filter"),
                Expanded(
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _sport,
                          child: Text("Sport"),
                        ),
                        SizedBox(width: 8), // Add space between buttons
                        ElevatedButton(
                          onPressed: _grade,
                          child: Text("Grade"),
                        ),
                        SizedBox(width: 50), // Add space to the right of the "Grade" button
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Students",
                    style: TextStyle(fontSize: 50),
                  ),
                  ElevatedButton(
                    onPressed: _addAthlete,
                    child: Text("Add Athlete"),
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
                    title: Text(dataList[index]['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dataList[index]['subtitle1']),
                        Text(dataList[index]['subtitle2']),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Navigate to the individual student screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IndividualStudentScreen(
                              studentData: dataList[index], // Pass student data if needed
                            ),
                          ),
                        );
                      },
                      child: const Text('More Info'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _sport() {}

void _grade() {}

void _addAthlete() {}
