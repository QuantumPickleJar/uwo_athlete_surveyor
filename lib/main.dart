// ignore: dangling_library_doc_comments
/// Date Started:     3/30/24
/// Desc: 
/// Entry point for student-faculty survey orchestrating app.
/// 
/// Authors: Josh, Vince, Amanda, Matt.
/// Version:          0.0.1
import 'package:athlete_surveyor/models/previous_forms_model.dart';
import 'package:athlete_surveyor/pages/previous_forms.dart';
import 'package:flutter/material.dart';

const Text appbarTitleText = Text(
  "Final Project GUI", 
  style: TextStyle(
    color: Colors.white, 
    fontWeight: FontWeight.bold));

void main() 
{
  runApp(const MaterialApp(home: MainApp()));
}

class MainApp extends StatelessWidget 
{
  const MainApp({super.key});

  /// Use to navigate to any page by supplying the existing context from "Widget build" and the name of the page.
  void navigateToPage(BuildContext context, Widget page)
  {
    Navigator.push
    (
      context,
      MaterialPageRoute(builder: (context) => page)
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: appbarTitleText,
        backgroundColor: Colors.blue.shade200),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(2.0),
            child: ElevatedButton(onPressed: null, child: Text("Screen 1"))),
          Padding(padding: EdgeInsets.all(2.0),
            child: ElevatedButton(onPressed: null, child: Text("Screen 2"))),
          Padding(padding: EdgeInsets.all(2.0),
            child: ElevatedButton(onPressed: null, child: Text("Screen 3"))),
          Padding(padding: EdgeInsets.all(2.0),
            child: ElevatedButton(onPressed: null, child: Text("Screen 4"))),
          Padding(padding: EdgeInsets.all(2.0),
            child: ElevatedButton(onPressed: null, child: Text("Screen 5"))),
          Padding(padding: EdgeInsets.all(2.0),
            child: ElevatedButton(onPressed: null, child: Text("Screen 6"))),
          Padding(padding: EdgeInsets.all(2.0),
            child: ElevatedButton(onPressed: null, child: Text("Screen 7"))),
          Padding(padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(onPressed:(){ navigateToPage(context, PreviousFormsWidget(PreviousFormsModel())); }, child: const Text("Screen 8")))
        ]));
  }
}
