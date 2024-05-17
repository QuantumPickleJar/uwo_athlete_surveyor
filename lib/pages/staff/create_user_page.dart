// ignore_for_file: library_private_types_in_public_api, dangling_library_doc_comments, avoid_print

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: A page for creating new users in the app database.
/// Bugs: n/a
/// Reflection: Good chance to leverage Form validation.

import 'package:athlete_surveyor/models/create_user_model.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:athlete_surveyor/resources/constant_values.dart' as constants;
import 'package:postgres/postgres.dart';
import 'package:email_validator/email_validator.dart';

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
                  label: constants.ok,
                  onPressed: () {
                    // Code to execute; no need to add anything as tapping the button already closes the snackbar.
                  }),
                content: Text(message),
                padding: const EdgeInsets.symmetric(horizontal: constants.defaultEdgeInsetsPadding), // Inner padding for snackbar
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

  /// Form validation; check entered username is an email address.
  String? _validateUsername(String username) { return EmailValidator.validate(username) ? null : constants.invalidEmailString; }

  /// Form validation; check entered first name isn't blank.
  String? _validateFirstName(String firstName) { return firstName.isNotEmpty ? null : constants.invalidFirstNameString; }
  
  /// Form validation; check entered lastName isn't blank.
  String? _validateLastName(String lastName) { return lastName.isNotEmpty ? null : constants.invalidLastNameString; }

  /// Validate supplied new user credentials against database, only adding the user if it comes back that the user isn't already present.
  void _validateNewUserCredentials() async
  {
    FocusManager.instance.primaryFocus?.unfocus(); //close virtual keyboard

    if(_formKey.currentState!.validate())
    {
      if(!await widget.createUserModel.checkIfUserAlreadyExists(usernameController.text.trim()))
      {
        Result result = await widget.createUserModel.registerNewUser(usernameController.text.trim(), firstNameController.text.trim(), lastNameController.text.trim(), isChecked);
        String? newUserUuid = result[0][0] as String?;
        print('New user id: $newUserUuid'); // The act of registering a new user will return the UUID assigned by the database; keeping functionality present in case useful later

        if(newUserUuid != null && newUserUuid.isNotEmpty) // Successful user creation
        {
          _clearText();
          _showSnackbarMessage(constants.userSuccessfullyAdded);
        }
        else                                              // Error occurred attempting to add user
        {
          _showSnackbarMessage(constants.userAdditionError);
        }
      }
      else                                                // Username already in DB
      {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(constants.defaultEdgeInsetsPadding),
                    child: defaultTextFormField(
                      controller: usernameController, 
                      validator: (text) => _validateUsername(text!), 
                      hintText: constants.newUsernameFieldHint,
                      obscureText: false),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(constants.defaultEdgeInsetsPadding),
                    child: defaultTextFormField(
                      controller: firstNameController, 
                      validator: (text) => _validateFirstName(text!), 
                      hintText: constants.firstNameFieldHint,
                      obscureText: false),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(constants.defaultEdgeInsetsPadding),
                    child: defaultTextFormField(
                      controller: lastNameController, 
                      validator: (text) => _validateLastName(text!),
                      hintText: constants.lastNameFieldHint,
                      obscureText: false),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(constants.defaultEdgeInsetsPadding),
                    child: CheckboxListTile(
                      title: const Text(constants.checkboxListTileTitleText),
                      value: isChecked,
                      onChanged: (bool? value) { 
                        setState(() {
                          isChecked = value!;
                        });}),
                  )]),
              ElevatedButton(
                onPressed: (){ _validateNewUserCredentials(); },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                child: const SizedBox(child: Center(child: Text(constants.addNewUserCheckButtonText, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))))],
          ))));
  }
}