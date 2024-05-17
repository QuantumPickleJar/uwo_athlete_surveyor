// ignore_for_file: dangling_library_doc_comments, avoid_print

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: The model for the LoginPage.
/// Bugs: n/a
/// Reflection: Not a whole lot happening here, just passes the responsibility for validating login from UI --> business logic --> database. Pretty standard.

import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/database.dart';
import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart'; 

/// Model for the 'Login Page', which is Main.dart essentially.
class LoginModel extends ChangeNotifier
{
  /// Grab the hashed password on the server and check it against the user-provided password.
  Future<LoggedInUser?> checkExistingPassword(String username, String password) async 
  { 
    final result = await Database.fetchUser(username);
    if (result.length != 1) 
    { // either the user doesn't exist or some error occurred where more than 1 row returned.
      return null; 
    }
    String hashedPassword = result[0][1] as String; 
    bool passwordMatches = BCrypt.checkpw(password, hashedPassword);

    print('Password matches: $passwordMatches');
    return passwordMatches  ? LoggedInUser( result[0][1] as String,
                                            result[0][2] as bool, 
                                            result[0][4] as bool, 
                                            result[0][3] as String, 
                                            result[0][5] as String, 
                                            result[0][6] as String) 
                            : null; //if password matches username, return an instance of LoggedInUser; otherwise null
  }
}