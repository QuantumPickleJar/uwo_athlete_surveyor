import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:athlete_surveyor/models/student_model.dart';

class IndividualStudentScreen extends StatelessWidget {
  final Student studentData;

  const IndividualStudentScreen({Key? key, required this.studentData}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        buildContext: context, 
        title: studentData.name, 
        hasBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${studentData.name}',
                     style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20), // Spacer between lines
                        Text(
                          'Grade: ${studentData.grade}',
                    
                        ),
                        const SizedBox(height: 20), // Spacer between lines
                        Text(
                          'Sport: ${studentData.sport}',
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ), // Spacer between lines
                ],
              ),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
