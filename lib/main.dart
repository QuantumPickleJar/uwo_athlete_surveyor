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
import 'package:athlete_surveyor/models/forms/previous_forms_model.dart';
import 'package:athlete_surveyor/pages/common/tabbed_main_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:athlete_surveyor/services/forms/form_repository.dart';
import 'package:athlete_surveyor/services/questions/question_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/student_model.dart';
import 'package:flutter/foundation.dart' as foundation_dart;
import 'services/forms/form_service.dart';

/// Driver code.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        Provider<FormRepository>(
          create: (_) => FormRepository(),
        ),
        Provider<QuestionRepository>(
          create: (_) => QuestionRepository(),
        ),
        /// [FormService] relies on Question + Form repos, so [ProxyProvider2] is suitable
        ProxyProvider2<FormRepository, QuestionRepository, FormService>(
          update: (_, formRepo, questionRepo, previous) => FormService(formRepo, questionRepo),
        ),
        ChangeNotifierProvider(create: (context) => LoginModel()),
        ChangeNotifierProvider(create: (context) => InboxModel()),
        ChangeNotifierProvider(create: (context) => StudentsModel()),
        ChangeNotifierProvider(create: (context) => PreviousFormsModel()),
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
  final String invalidUsernameString = 'Username field left blank, please enter username';
  final String invalidPasswordString = 'Password field left blank, please enter password';
  final String testStudentUsername = 'testStudent@uwosh.edu';
  final String testStudentPassword = '1A5qGrb6p4!%a4Iw';
  final String testAdminUsername = 'admin@uwosh.edu';
  final String testAdminPassword = 'A)msBslYwXnnmb9W';
  final String uwoWatermarkUrl = 'https://uwosh.edu/umc/wp-content/uploads/sites/18/2019/07/UWO_vertical_Oshkosh_4c.png';
  final String pageTitle = 'Be Better Initiative';
  final String usernameFieldHint = 'Enter Username';
  final String passwordFieldHint = 'Enter Password';
  final String loginButtonText = 'Login';
  final String testStudentLoginButtonText = 'DEBUG: Login as Student';
  final String testAdminLoginButtonText = 'DEBUG: Login as Staff (ADMIN)';

  String? username;
  String? password;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // so we can reference the Form where we need it

  /// Form validation; check entered username.
  String? _validateUsername(String username) { return username.isNotEmpty ? null : invalidUsernameString; }

  /// Form validation; check entered password.
  String? _validatePassword(String password) { return password.isNotEmpty ? null : invalidPasswordString; }

  /// Validate supplied login information against database.
  void _validateLogin(BuildContext context) async
  {
    if(_formKey.currentState!.validate())
    {
      LoggedInUser? currentUser = await widget.loginModel.checkExistingPassword(usernameController.text, passwordController.text);
 
      if(context.mounted && currentUser != null) { navigateToPage(context, TabbedMainPage(currentUser: currentUser)); }
    }
  }

  /// Used specifically to speed up student account login for testing purposes.
  void _buttonPressTestStudentLogin(BuildContext context) async
  {
    usernameController.text = testStudentUsername;
    passwordController.text = testStudentPassword;

    _validateLogin(context);
  }

  /// Used specifically to speed up admin account login for testing purposes.
  void _buttonPressTestAdminLogin(BuildContext context) async
  {
    usernameController.text = testAdminUsername;
    passwordController.text = testAdminPassword;

    _validateLogin(context);
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 275,
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(uwoWatermarkUrl), fit: BoxFit.fill))),
              Text(pageTitle, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              defaultTextFormField(
                controller: usernameController, 
                validator: (username) => _validateUsername(username!), 
                hintText: usernameFieldHint),
              defaultTextFormField(
                controller: passwordController, 
                validator: (password) => _validatePassword(password!), 
                hintText: passwordFieldHint),
              ElevatedButton(
                onPressed: (){ _validateLogin(context); },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                child: SizedBox(child: Center(child: Text(loginButtonText, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
              toggleVisibleButton( //only visible in debug mode
                visibilityToggle: foundation_dart.kDebugMode, 
                onPressed: (){ _buttonPressTestStudentLogin(context); }, 
                buttonText: testStudentLoginButtonText),
              toggleVisibleButton( //only visible in debug mode
                visibilityToggle: foundation_dart.kDebugMode, 
                onPressed: (){ _buttonPressTestAdminLogin(context); }, 
                buttonText: testAdminLoginButtonText)]))));
  }
}