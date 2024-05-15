// ignore_for_file: dangling_library_doc_comments
// ignore_for_file: library_private_types_in_public_api

/// Date Started:     3/30/24
/// Desc: 
/// Entry point for student-faculty survey orchestrating app.
/// 
/// Authors: Josh, Vince, Amanda.
/// Version:          0.0.1


import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/models/create_user_model.dart';
import 'package:athlete_surveyor/models/inbox_model.dart';
import 'package:athlete_surveyor/models/login_model.dart';
import 'package:athlete_surveyor/models/forms/previous_forms_model.dart';
import 'package:athlete_surveyor/pages/common/tabbed_main_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:athlete_surveyor/resources/constant_values.dart' as constants;
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
        ChangeNotifierProvider(create: (context) => CreateUserModel())
      ],
      child: MaterialApp(home: MainApp(LoginModel()))
    )
  );
}

/// Main
class MainApp extends StatefulWidget
{
  final LoginModel loginModel;
  const MainApp(this.loginModel, {super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

/// Main State
class _MainAppState extends State<MainApp>
{
  final _formKey = GlobalKey<FormState>(); // So we can reference the Form where we need it.
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? username;
  String? password;

  /// Form validation; check entered username.
  String? _validateUsername(String username) { return username.isNotEmpty ? null : constants.invalidUsernameString; }

  /// Form validation; check entered password.
  String? _validatePassword(String password) { return password.isNotEmpty ? null : constants.invalidPasswordString; }

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
    usernameController.text = constants.testStudentUsername;
    passwordController.text = constants.testStudentPassword;

    _validateLogin(context);
  }

  /// Used specifically to speed up admin account login for testing purposes.
  void _buttonPressTestAdminLogin(BuildContext context) async
  {
    usernameController.text = constants.testAdminUsername;
    passwordController.text = constants.testAdminPassword;

    _validateLogin(context);
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(constants.defaultEdgeInsetsPadding),
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
                decoration: const BoxDecoration(
                  image: DecorationImage(image: NetworkImage(constants.uwoWatermarkUrl), fit: BoxFit.fill))),
              const Text(constants.pageTitle, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              defaultTextFormField(
                controller: usernameController, 
                validator: (username) => _validateUsername(username!), 
                hintText: constants.loginUsernameFieldHint,
                obscureText: false),
              defaultTextFormField(
                controller: passwordController, 
                validator: (password) => _validatePassword(password!), 
                hintText: constants.loginPasswordFieldHint,
                obscureText: true),
              ElevatedButton(
                onPressed: (){ _validateLogin(context); },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                child: const SizedBox(child: Center(child: Text(constants.loginButtonText, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
              toggleVisibleButton( // Only visible in debug mode
                visibilityToggle: foundation_dart.kDebugMode, 
                onPressed: (){ _buttonPressTestStudentLogin(context); }, 
                buttonText: constants.testStudentLoginButtonText),
              toggleVisibleButton( // Only visible in debug mode
                visibilityToggle: foundation_dart.kDebugMode, 
                onPressed: (){ _buttonPressTestAdminLogin(context); }, 
                buttonText: constants.testAdminLoginButtonText)]))));
  }
}