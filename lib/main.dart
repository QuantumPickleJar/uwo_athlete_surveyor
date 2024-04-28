// ignore_for_file: dangling_library_doc_comments
// ignore_for_file: library_private_types_in_public_api

/// Date Started:     3/30/24
/// Desc: 
/// Entry point for student-faculty survey orchestrating app.
/// 
/// Authors: Josh, Vince, Amanda.
/// Version:          0.0.1

import 'package:athlete_surveyor/models/inbox_model.dart';
import 'package:athlete_surveyor/models/login_model.dart';
import 'package:athlete_surveyor/models/previous_forms_model.dart';
import 'package:athlete_surveyor/pages/tabbed_main_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/student_model.dart';

/// Driver code.
void main() 
{
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginModel()),
        ChangeNotifierProvider(create: (context) => InboxModel()),
        ChangeNotifierProvider(create: (context) => StudentsModel()),
        ChangeNotifierProvider(create: (context) => PreviousFormsModel())
      ],
      child: MaterialApp(home: MainApp(LoginModel()))
    )
  );
}

/// 
class MainApp extends StatefulWidget
{
  final LoginModel loginModel;
  const MainApp(this.loginModel, {super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

/// 
class _MainAppState extends State<MainApp>
{
  //Convert class to form to make use of automatic validation functionality? See previous lab.
  //Admin pass: A)msBslYwXnnmb9W
  //Admin user: admin@uwosh.edu
  String? username;
  String? password;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      body: Container(alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              TextField(
                onChanged: (value) => username = value,
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), 
                  hintText:'Enter Username')),
              TextField(
                onChanged: (value) => password = value,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), 
                  hintText:'Enter Password')),
              ElevatedButton(
                onPressed: (){ widget.loginModel.testingInsertAdminAccount(); },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                child: const SizedBox(child: Center(child: Text('DEBUG: Print random pass to console', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
              ElevatedButton(
                onPressed: (){ navigateToPage(
                  context, 
                  const TabbedMainPage(isAdmin: false)); }, 
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                child: const SizedBox(child: Center(child: Text('DEBUG: Login as Student', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
              ElevatedButton(
                onPressed: (){ navigateToPage(
                  context, 
                  const TabbedMainPage(isAdmin: true)); }, 
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                child: const SizedBox(child: Center(child: Text('DEBUG: Login as Staff (ADMIN)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))))
            ]),
        )));
  }
}