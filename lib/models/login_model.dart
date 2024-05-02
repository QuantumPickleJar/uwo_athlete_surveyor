import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/database.dart';
import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart'; 
import 'dart:math';

class LoginModel extends ChangeNotifier
{
  /// Method for Generating Random Temporary passwords for newly added accounts; 15 characters is the standard for passwords nowadays. Intended to be changed on first login.
  String generateRandomTemporaryPassword()
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

  /// 
  void registerNewPassword(String userID, String passwordToRegister) async 
  { 
    // first, get the hashed password
    String hashedPassword = BCrypt.hashpw(passwordToRegister, BCrypt.gensalt()); 
    print(hashedPassword); //testing; remove later

    // final conn = await getOpenConnection(); 
    // final result = await conn.execute( 
    // Sql.named("INSERT INTO users VALUES(@user_id, @hashed_password)"), 
    // parameters: {'user_id': userID, 'hashed_password': hashedPassword}); 
    // print(result); 
  }

  /// Grab the hashed password on the server and check it against the user-provided password.
  Future<LoggedInUser?> checkExistingPassword(String userName, String password) async 
  { 
    final result = await Database.fetchUserPassword(userName);
    if (result.length != 1) 
    { // either the user doesn't exist or some error occurred where more than 1 row returned.
      return null; 
    }
    String hashedPassword = result[0][1] as String; 
    bool passwordMatches = BCrypt.checkpw(password, hashedPassword);

    print(passwordMatches); //testing; remove later
    return passwordMatches ? LoggedInUser(result[0][2] as bool, 
                                          result[0][4] as bool, 
                                          result[0][3] as String, 
                                          result[0][5] as String, 
                                          result[0][6] as String) 
                            : null; //if password matches username, return an instance of LoggedInUser; otherwise null
  }

  Future<bool> testingInsertAdminAccount()
  {
    String username = 'admin@uwosh.edu';
    String hashedPassword = BCrypt.hashpw(generateRandomTemporaryPassword(), BCrypt.gensalt());

    return Database.insertNewUser(username, hashedPassword, true);
  }

}