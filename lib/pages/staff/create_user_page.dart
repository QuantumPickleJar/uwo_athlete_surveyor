// ignore_for_file: library_private_types_in_public_api

import 'package:athlete_surveyor/models/create_user_model.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:athlete_surveyor/resources/constant_values.dart' as constants;
import 'package:postgres/postgres.dart';

//TODO: send email to new users giving them their temp password
//TODO: check for temp passwords on login; make user change temp pass on first login

/// A Form-based page for entering information to create a new application user.
class CreateUserPage extends StatefulWidget
{
  final CreateUserModel createUserModel;
  const CreateUserPage(this.createUserModel, {super.key});

  @override
  _CreateUserState createState() => _CreateUserState();
}

/// StatefulWidget State.
class _CreateUserState extends State<CreateUserPage>
{
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool isChecked = false;

  /// Use snackbar messages to indicate whether or not user creation is successful.
  void _showSnackbarMessage(String message)
  {
    ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {
                    // Code to execute.
                  }),
                content: Text(message),
                padding: const EdgeInsets.symmetric(horizontal: constants.defaultEdgeInsetsPadding), //inner padding for snackbar
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))));
  }

  /// Clear all text controllers.
  void _clearText()
  {
    usernameController.clear();
    firstNameController.clear();
    lastNameController.clear();
  }

  /// Form validation; check entered username isn't blank.
  String? _validateUsername(String username) { return username.isNotEmpty ? null : constants.invalidUsernameString; }
  
  /// Form validation; check entered first name isn't blank.
  String? _validateFirstName(String firstName) { return firstName.isNotEmpty ? null : constants.invalidFirstNameString; }
  
  /// Form validation; check entered lastName isn't blank.
  String? _validateLastName(String lastName) { return lastName.isNotEmpty ? null : constants.invalidLastNameString; }

  /// Validate supplied new user credentials against database, only adding the user if it comes back that the user
  /// isn't already present.
  void _validateNewUserCredentials() async
  {
    FocusManager.instance.primaryFocus?.unfocus(); //close virtual keyboard

    if(_formKey.currentState!.validate())
    {
      if(!await widget.createUserModel.checkIfUserAlreadyExists(usernameController.text.trim()))
      {
        Result result = await widget.createUserModel.registerNewUser(usernameController.text.trim(), firstNameController.text.trim(), lastNameController.text.trim(), isChecked);
        String? newUserUuid = result[0][0] as String?;
        print('New user id: $newUserUuid'); // the act of registering a new user will return the UUID assigned by the database; keeping functionality present in case useful later

        if(newUserUuid != null && newUserUuid.isNotEmpty) // successful user creation
        {
          _clearText();
          _showSnackbarMessage(constants.userSuccessfullyAdded);
        }
        else // error occurred attempting to add user
        {
          _showSnackbarMessage(constants.userAdditionError);
        }
      }
      else //username already in DB
      {
        print('Username exists already');
        _showSnackbarMessage(constants.usernameAlreadyExists);
      }
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: defaultAppBar( 
        buildContext: context, 
        title: constants.createNewUserString,
        hasBackButton: true, 
        actionButton: null),
      body: Container(
        padding: const EdgeInsets.all(constants.defaultEdgeInsetsPadding),
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              defaultTextFormField(
                controller: usernameController, 
                validator: (text) => _validateUsername(text!), 
                hintText: constants.newUsernameFieldHint,
                obscureText: false),
              defaultTextFormField(
                controller: firstNameController, 
                validator: (text) => _validateFirstName(text!), 
                hintText: constants.firstNameFieldHint,
                obscureText: false),
              defaultTextFormField(
                controller: lastNameController, 
                validator: (text) => _validateLastName(text!),
                hintText: constants.lastNameFieldHint,
                obscureText: false),
              CheckboxListTile(
                title: const Text(constants.checkboxListTileTitleText),
                value: isChecked,
                onChanged: (bool? value) { 
                  setState(() {
                    isChecked = value!;
                  });}),
              ElevatedButton(
                onPressed: (){ _validateNewUserCredentials(); },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                child: const SizedBox(child: Center(child: Text(constants.addNewUserCheckButtonText, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))))),
    ]))));
  }
}