import 'dart:math';

import 'package:athlete_surveyor/database.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class CreateUserModel extends ChangeNotifier
{
  /// Run up to DB and see if username already registered before trying to created a new user.
  Future<bool> checkIfUserAlreadyExists(String username) async
  {
    final result = await Database.fetchUser(username);
    
    if(result.isNotEmpty){ return true; } //user found in DB

    return false; //user doesn't exist
  }

  /// Method for generating random temporary passwords for newly added accounts; 15 characters is the standard for 
  /// passwords nowadays. Intended to be changed on first login.
  String _generateRandomTemporaryPassword()
  {
    final random = Random();
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+';
    String password = '';

    for (int i = 0; i <= 15; i++) 
    {
      password += characters[
          random.nextInt(characters.length)]; // Generate a random password
    }

    print('Random pass: $password\n'); //testing; remove later
    return password;
  }

  /// Register the new user with their password
  Future<Result> registerNewUser(String username, String firstName, String lastName, bool giveAdminPrivileges) async 
  {
    // first, get the hashed password
    String hashedPassword = BCrypt.hashpw(_generateRandomTemporaryPassword(), BCrypt.gensalt()); 
    print(hashedPassword); //testing; remove later

    return Database.insertNewUser(username, hashedPassword, firstName, lastName, giveAdminPrivileges);
  }
}