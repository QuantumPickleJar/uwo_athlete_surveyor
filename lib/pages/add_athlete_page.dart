import 'package:flutter/material.dart';

// 
class AddAthleteWidget extends StatelessWidget {
  const AddAthleteWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your App Title'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Athlete Information',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(height: 20), // Add some spacing between widgets
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    'https://via.placeholder.com/150', // Replace with your image URL
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(width: 16.0), // Add some spacing between image and text fields
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Name: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5), // Adjust padding
                                ),
                                style: TextStyle(fontSize: 14), // Adjust font size
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10), // Spacer between lines
                        Row(
                          children: [
                            Text(
                              'Grade: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5), // Adjust padding
                                ),
                                style: TextStyle(fontSize: 14), // Adjust font size
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10), // Spacer between lines
                        Row(
                          children: [
                            Text(
                              'Sport: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5), // Adjust padding
                                ),
                                style: TextStyle(fontSize: 14), // Adjust font size
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
             const SizedBox(height: 20), // Add some spacing between widgets
             const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add Survey'),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      // Add your widgets here
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5), // Add some spacing between widgets
              Column(
                children: [
                  const Text("Analytics of 'Student's name'"),
                  Image.network(
                    'https://via.placeholder.com/400', // Replace with the student's headshot
                    width: 390,
                    height: 390,
                  ),
                ],
              ),
            ],
          ),
          
        ),
      );
  }
}

// ignore: unused_element
void _caution(){

}