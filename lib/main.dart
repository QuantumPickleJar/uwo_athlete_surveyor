// ignore_for_file: dangling_library_doc_comments
// ignore_for_file: library_private_types_in_public_api

/// Date Started:     3/30/24
/// Desc: 
/// Entry point for student-faculty survey orchestrating app.
/// 
/// Authors: Josh, Vince, Amanda.
/// Version:          0.0.1

import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/models/inbox_model.dart';
import 'package:athlete_surveyor/models/login_model.dart';
import 'package:athlete_surveyor/models/previous_forms_model.dart';
import 'package:athlete_surveyor/pages/tabbed_main_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'models/student_model.dart';
import 'package:flutter/foundation.dart' as foundation_dart;

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
  String? username;
  String? password;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // so we can reference the Form where we need it

  /// 
  String? validateUsername(String username)
  {
    return username.isNotEmpty ? null : 'Username field left blank, please enter username';
  }

  /// 
  String? validatePassword(String password)
  {
    return password.isNotEmpty ? null : 'Password field left blank, please enter username';
  }

  /// Used specifically to speed up admin account login for testing purposes.
  void buttonPressTestAdminLogin(BuildContext context) async
  {
    usernameController.text = 'admin@uwosh.edu';
    passwordController.text = 'A)msBslYwXnnmb9W';

    validateLogin(context);
  }

  /// General validate login method.
  void validateLogin(BuildContext context) async
  {
    if(_formKey.currentState!.validate())
    {
      LoggedInUser? currentUser = await widget.loginModel.checkExistingPassword(usernameController.text, passwordController.text);
 
      if(context.mounted && currentUser != null) { navigateToPage(context, TabbedMainPage(currentUser: currentUser)); }
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
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
              TextFormField(
                controller: usernameController,
                validator: (username) => validateUsername(username!),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Username')),
              TextFormField(
                controller: passwordController,
                validator: (password) => validatePassword(password!),
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Password')),
              Visibility(
                visible: foundation_dart.kDebugMode, //only visible in debug mode
                child: ElevatedButton(
                  onPressed: (){ widget.loginModel.testingInsertAdminAccount(); },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                  child: const SizedBox(child: Center(child: Text('DEBUG: Print random pass to console', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
              ),
              Visibility(
                visible: foundation_dart.kDebugMode, //only visible in debug mode
                child: ElevatedButton(
                  onPressed: (){ }, //TODO: add test account for student and insertion method for debug 
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                  child: const SizedBox(child: Center(child: Text('DEBUG: Login as Student', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
              ),
              Visibility(
                visible: foundation_dart.kDebugMode, //only visible in debug mode
                child: ElevatedButton(
                  onPressed: (){ buttonPressTestAdminLogin(context); }, 
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                  child: const SizedBox(child: Center(child: Text('DEBUG: Login as Staff (ADMIN)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
              )
            ]),
        )));
  }
}