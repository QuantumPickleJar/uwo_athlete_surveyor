// ignore_for_file: dangling_library_doc_comments
// ignore_for_file: library_private_types_in_public_api

/// Date Started:     3/30/24
/// Desc: 
/// Entry point for student-faculty survey orchestrating app.
/// 
/// Authors: Josh, Vince, Amanda.
/// Version:          0.0.1
/// Remarks: ProxyProvider was extremely powerful to be working with starting out

import 'dart:convert';

import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/models/inbox_model.dart';
import 'package:athlete_surveyor/models/login_model.dart';
import 'package:athlete_surveyor/models/forms/previous_forms_model.dart';
import 'package:athlete_surveyor/models/sport.dart';
import 'package:athlete_surveyor/models/sport_selection_model.dart';
import 'package:athlete_surveyor/pages/common/tabbed_main_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:athlete_surveyor/services/db.dart';
import 'package:athlete_surveyor/services/forms/form_repository.dart';
import 'package:athlete_surveyor/services/questions/question_repository.dart';
import 'package:athlete_surveyor/services/sports/sports_repository.dart';
import 'package:athlete_surveyor/services/sports/sports_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/student_model.dart';
import 'package:flutter/foundation.dart' as foundation_dart;
import 'services/forms/form_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final sportsRepository = SportsRepository();
  final sportsService = SportsService(sportsRepository);
  final sports = await sportsService.loadSportsFromFile();
  

  /// Driver code.
  runApp(
    /// Dependency injection time!
    MultiProvider(
      providers: [
        /// Create SportSelectionModel first to load file contents from assets
        ChangeNotifierProvider(
          create: (context) => SportSelectionModel(sportsService: sportsService)..sports = sports,
        ),

        /// [ Prelaunch - 1 of 3 ] low-level repositories
        Provider<QuestionRepository>(create: (_) => QuestionRepository()),
        
        /// Create SportsRepository first
        // Provider<SportsRepository>(create: (context) => SportsRepository(),
        // ),
        
        /// [ Prelaunch - 2 of 3 ] 1-N service relationships
        ProxyProvider<SportSelectionModel, FormRepository>(
          update: (_, sportsModel, __) => FormRepository(SportsRepository()),
        ),
        
        /// [ Prelaunch - 3 of 3 ] complex services (those with multiple/timely dependencies)
        /// [FormService] relies on both the [SportsRepository], [QuestionRepository], & [FormRepository],
        ProxyProvider3<SportsRepository, FormRepository, QuestionRepository, FormService>(
          update: (_, sportsRepo, formRepo, questionRepo, __) => FormService(formRepo, questionRepo),
        ),
        
        ChangeNotifierProvider(create: (context) => LoginModel()),
        ChangeNotifierProvider(create: (context) => InboxModel()),
        ChangeNotifierProvider(create: (context) => StudentsModel()),
        /// [ChangeNotifierProxyProvider] used to create and update the [AuthoredFormsModel]
        /// based on the changes in the [FormService]. It listens to changes in the [FormService]
        /// and updates the [AuthoredFormsModel] accordingly.
        ChangeNotifierProxyProvider<FormService, AuthoredFormsModel>(
          create: (_) => AuthoredFormsModel(Provider.of<FormService>(_, listen: false)),
          update: (_, formService, previous) => previous!..updateFormService(formService),
        ),
      ], 
      child: MaterialApp(home: MainApp(LoginModel()))
    )
  );
}

class MainApp extends StatefulWidget
{
  final LoginModel loginModel;
  const MainApp(this.loginModel, {super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp>
{
  String? username;
  String? password;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // so we can reference the Form where we need it

  /// Form validation; check entered username.
  String? _validateUsername(String username)
  {
    return username.isNotEmpty ? null : 'Username field left blank, please enter username';
  }

  /// Form validation; check entered password.
  String? _validatePassword(String password)
  {
    return password.isNotEmpty ? null : 'Password field left blank, please enter password';
  }

  /// Used specifically to speed up student account login for testing purposes.
  void _buttonPressTestStudentLogin(BuildContext context) async
  {
    usernameController.text = 'testStudent@uwosh.edu';
    passwordController.text = '1A5qGrb6p4!%a4Iw';

    _validateLogin(context);
  }

  /// Used specifically to speed up admin account login for testing purposes.
  void _buttonPressTestAdminLogin(BuildContext context) async
  {
    usernameController.text = 'admin@uwosh.edu';
    passwordController.text = 'A)msBslYwXnnmb9W';

    _validateLogin(context);
  }

  /// Validate supplied login information against database.
  void _validateLogin(BuildContext context) async
  {
    if(_formKey.currentState!.validate()) {
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
                validator: (username) => _validateUsername(username!),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Username')),
              TextFormField(
                controller: passwordController,
                validator: (password) => _validatePassword(password!),
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Password')),
              ElevatedButton(
                onPressed: (){ _validateLogin(context); },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                child: const SizedBox(child: Center(child: Text('Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
              Visibility(
                visible: foundation_dart.kDebugMode, //only visible in debug mode
                child: ElevatedButton(
                  onPressed: (){ _buttonPressTestStudentLogin(context); },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                  child: const SizedBox(child: Center(child: Text('DEBUG: Login as Student', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
              ),
              Visibility(
                visible: foundation_dart.kDebugMode, //only visible in debug mode
                child: ElevatedButton(
                  onPressed: (){ _buttonPressTestAdminLogin(context); }, 
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                  child: const SizedBox(child: Center(child: Text('DEBUG: Login as Staff (ADMIN)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
              )
            ]),
        )));
  }
}