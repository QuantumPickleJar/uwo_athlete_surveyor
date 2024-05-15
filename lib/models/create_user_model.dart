// ignore_for_file: dangling_library_doc_comments

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: The model for the CreateUserPage.
/// Bugs: n/a
/// Reflection: Getting the emailing to work required more effort than I would have liked.

import 'dart:math';
import 'package:athlete_surveyor/database.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:athlete_surveyor/resources/constant_values.dart' as constants;

/// Model for the CreateUserPage class.
class CreateUserModel extends ChangeNotifier
{
  /// Run up to DB and see if username already registered before trying to created a new user.
  Future<bool> checkIfUserAlreadyExists(String username) async
  {
    final result = await Database.fetchUser(username);
    
    if(result.isNotEmpty){ return true; } // User found in DB

    return false;                         //User doesn't exist
  }

  /// Register the new user with a randomly generated temporary password.
  Future<Result> registerNewUser(String username, String firstName, String lastName, bool giveAdminPrivileges) async 
  {
    // first, get the hashed password
    String tempPassword = _generateRandomTemporaryPassword();
    String hashedPassword = BCrypt.hashpw(tempPassword, BCrypt.gensalt()); 
    print(hashedPassword);

    _sendTempPassEmail(username, tempPassword);

    return Database.insertNewUser(username, hashedPassword, firstName, lastName, giveAdminPrivileges);
  }

  /// Method for generating random temporary passwords for newly added accounts; 15 characters is the standard for passwords nowadays. Intended to be changed on first login.
  String _generateRandomTemporaryPassword()
  {
    final random = Random();
    const characters = constants.randomPasswordChars;
    String password = '';

    for (int i = 0; i <= 15; i++) 
    {
      password += characters[
          random.nextInt(characters.length)]; // Generate a random password
    }

    print('Random pass: $password\n');
    return password;
  }

  /// Send an email to the new user giving them their temporary login password.
  void _sendTempPassEmail(String emailAddress, String tempPassword) async
  {
    final mailer = Mailer(constants.emailApiKey);
    final toAddress = Address(emailAddress);
    const fromAddress = Address(constants.sendingEmail);
    final content = Content(constants.contentType, 
                            'Here is your temporary password: $tempPassword\n\nYou will be given the chance to change it when you log in for the first time.');
    const subject = constants.emailSubjectLine;
    final personalization = Personalization([toAddress]);

    final email = Email([personalization], fromAddress, subject, content: [content]);
    mailer.send(email).then((result) {
      // ...
    });
  }

}