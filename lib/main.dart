// ignore: dangling_library_doc_comments
/// Date Started:     3/30/24
/// Desc: 
/// Entry point for student-faculty survey orchestrating app.
/// 
/// Authors: Josh, Vince, Amanda, Matt.
/// Version:          0.0.1
import 'package:flutter/material.dart';

const Text appbarTitleText = Text(
  "Final Project GUI", 
  style: TextStyle(
    color: Colors.white, 
    fontWeight: FontWeight.bold));

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  void goToScreenSix()
  {
    //TODO
  }

  void goToScreenEight()
  {
    //TODO
  }

    @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: appbarTitleText,
        backgroundColor: Colors.blue.shade200, 
        actions:[
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(onPressed: goToScreenSix, child: const Text("S6")),
          ), 
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(onPressed: goToScreenEight, child: const Text("S8")),
          )]),
          body: Column(children: [
            //Add buttons for navigation to other screens here.
          ]));
  }
}
