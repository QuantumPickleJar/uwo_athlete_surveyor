// ignore: dangling_library_doc_comments
/// Date Started:     3/30/24
/// Desc: 
/// Entry point for student-faculty survey orchestrating app.
/// 
/// Authors: Josh, Vince, Amanda.
/// Version:          0.0.1
import 'package:athlete_surveyor/models/inbox_model.dart';
import 'package:athlete_surveyor/models/forms/previous_forms_model.dart';
import 'package:athlete_surveyor/pages/common/tabbed_main_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/student_model.dart';

void main() 
{
  //runApp(const MaterialApp(home: MainApp()));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InboxModel()),
        ChangeNotifierProvider(create: (context) => StudentsModel()),
        ChangeNotifierProvider(create: (context) => PreviousFormsModel())
      ],
      child: const MaterialApp(home: MainApp())
    )
  );
}

class MainApp extends StatelessWidget 
{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      body: Container(alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 275,
              height: 200,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(image: NetworkImage('https://uwosh.edu/umc/wp-content/uploads/sites/18/2019/07/UWO_vertical_Oshkosh_4c.png'), fit: BoxFit.fill)
              ),
            ),
            const Text('Be Better Initiative', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            ElevatedButton(onPressed: (){ navigateToPage(context, TabbedMainPage(isAdmin: false)); }, 
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
              child: const SizedBox(width: 200, height: 50, child: Center(child: Text('Log in using UWO ID', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
            ElevatedButton(onPressed: (){ navigateToPage(context, TabbedMainPage(isAdmin: true)); }, 
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
              child: const SizedBox(width: 200, height: 50, child: Center(child: Text('Log in using UWO ID (ADMIN)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))))
          ])));
  }
}
