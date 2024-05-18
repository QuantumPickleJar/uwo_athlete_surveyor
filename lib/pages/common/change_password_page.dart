// ignore_for_file: library_private_types_in_public_api, dangling_library_doc_comments


/// Name: Joshua T. Hill
/// Date: 5/16/2024
/// Description: A page for changing passwords; always shows up when someone's password is still the temporary one assigned on first creation.
/// Bugs: n/a
/// Reflection: n/a

import 'dart:async';

import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/models/change_password_model.dart';
import 'package:athlete_surveyor/pages/common/tabbed_main_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:athlete_surveyor/resources/constant_values.dart' as constants;

/// A Form-based page for entering information to create a new application user.
class ChangePasswordPage extends StatefulWidget
{
  final ChangePasswordModel changePasswordModel;
  final LoggedInUser currentUser;
  const ChangePasswordPage(this.changePasswordModel, {super.key, required this.currentUser});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

/// StatefulWidget State.
class _ChangePasswordState extends State<ChangePasswordPage>
{
  final _formKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordAgainController = TextEditingController();

  /// Use snackbar messages to indicate an error occurred when trying to change password.
  void _showSnackbarMessage(String message)
  {
    ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                action: SnackBarAction(
                  label: '',
                  onPressed: () {
                    // Code to execute; no need to add anything as tapping the button already closes the snackbar.
                  }),
                content: Text(message),
                padding: const EdgeInsets.symmetric(horizontal: constants.defaultEdgeInsetsPadding), // Inner padding for snackbar
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))));
  }

  /// Form validation; check that two passwords match before attempting DB update.
  String? _validateSamePasswords() 
  {
     return (newPasswordController.text.trim().compareTo(newPasswordAgainController.text.trim()) == 0) ? null 
                                                                                                       : constants.invalidPasswordsString;
  }

  /// Attempt to update the user's password after validation.
  void _updatePasswordIfValid() async
  {
    FocusManager.instance.primaryFocus?.unfocus(); //close virtual keyboard

    if(_formKey.currentState!.validate())
    {
      if(await widget.changePasswordModel.updateUserPassword(widget.currentUser.userUuid, newPasswordAgainController.text.trim()))
      {
        _showSnackbarMessage(constants.passwordChangeSucessful);

        Timer(const Duration(seconds: 3), () { navigateToPage(context, TabbedMainPage(currentUser: widget.currentUser)); }); // Wait 3 seconds so user can see Snackbar message, then move to main tabbed page.
      }
      else
      {
        _showSnackbarMessage(constants.passwordChangeUnsuccessful);
      }
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: defaultAppBar( 
        buildContext: context, 
        title: constants.changePassword,
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
                      controller: newPasswordController,
                      validator: null,
                      hintText: constants.enterNewPasswordFieldHint,
                      obscureText: false),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(constants.defaultEdgeInsetsPadding),
                    child: defaultTextFormField(
                      controller: newPasswordAgainController, 
                      validator: (text) => _validateSamePasswords(),
                      hintText: constants.enterNewPasswordAgainFieldHint,
                      obscureText: false),
                  )]),
              ElevatedButton(
                onPressed: (){ _updatePasswordIfValid(); },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.yellow)), 
                child: const SizedBox(child: Center(child: Text(constants.changePassword, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))))],
          ))));
  }

}