import 'package:athlete_surveyor/pages/add_athlete_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:flutter/material.dart';
import 'individual_student_page.dart'; // Import the individual student screen

//
class StudentsWidget extends StatelessWidget {
  const StudentsWidget({super.key});

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

      return Scaffold(
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
                    onPressed: (){ navigateToPage(context, const AddAthleteWidget()); },
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
                        navigateToPage(context, IndividualStudentWidget(studentData: dataList[index]));
                      },
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
}

void _sport() {}

void _grade() {}