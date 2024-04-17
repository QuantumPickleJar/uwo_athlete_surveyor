import 'package:flutter/material.dart';

class IndividualStudentScreen extends StatelessWidget {
  final Map<String, dynamic> studentData;

  const IndividualStudentScreen({Key? key, required this.studentData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(studentData['name']), // Assuming 'title' contains the student's name
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  studentData['image'], // Assuming 'image' contains the URL of the student's image
                  width: 150,
                  height: 150,
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Line 1',
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 20), // Spacer between lines
                      Text(
                        'Line 2',
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 20), // Spacer between lines
                      Text(
                        'Line 3',
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ), // Spacer between lines
              ],
            ),
            const SizedBox(height: 20), // Spacer between the Row and the additional Column
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
            const SizedBox(height: 5), // Spacer before the student's headshot
            Expanded(
              // Wrap the Column containing the elevated button with Expanded
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Analytics of 'Student's name'"),
                  Image.network(
                    'https://via.placeholder.com/300', // Replace with the student's headshot
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 20),
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
    );
  }
}

void _caution() {
  // Define the action to be performed when the button is pressed
}
