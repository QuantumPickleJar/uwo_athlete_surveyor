// ignore: dangling_library_doc_comments
/// Date Started:     3/30/24
/// Desc: 
/// Entry point for student-faculty survey orchestrating app.
/// 
/// Authors: Josh, Vince, Amanda, Matt.
/// Version:          0.0.1
import 'package:athlete_surveyor/models/inbox_model.dart';
import 'package:athlete_surveyor/models/previous_forms_model.dart';
import 'package:athlete_surveyor/pages/inbox_page.dart';
import 'package:athlete_surveyor/pages/previous_forms_page.dart';
import 'package:athlete_surveyor/pages/screen_one_splash_screen.dart';
import 'package:athlete_surveyor/pages/screen_twoB_home_screen.dart';
import 'package:athlete_surveyor/pages/screen_two_home_screen.dart';
import 'package:athlete_surveyor/pages/students_page.dart';
import 'package:athlete_surveyor/resources/colors.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:flutter/material.dart';

const Text _appbarTitleText = Text(
  "Final Project GUI", 
  style: TextStyle(
    color: Colors.black, 
    fontWeight: FontWeight.bold));

void main() 
{
  runApp(const MaterialApp(home: MainApp()));
}

class MainApp extends StatelessWidget 
{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: _appbarTitleText,
        backgroundColor: titanYellow),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              onPressed:(){ navigateToPage(context, const ScreenOne()); },
              child: const Text("Screen 1: Login"))),
          Padding(padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              onPressed:(){ navigateToPage(context, const ScreenTwo()); },
              child: const Text("Screen 2a: Home"))),
          Padding(padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              onPressed:(){ navigateToPage(context, const ScreenTwoB()); },
              child: const Text("Screen 2b: Home - ADMIN"))),
          Padding(padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              onPressed:(){ navigateToPage(context, InboxWidget(InboxModel())); },
              child: const Text("Screen 6: Inbox"))),
          Padding(padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              onPressed:(){ navigateToPage(context, PreviousFormsWidget(PreviousFormsModel())); }, 
              child: const Text("Screen 8: Previous Forms")))
        ]));
  }
}
