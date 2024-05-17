// ignore_for_file: dangling_library_doc_comments

/// Name: Joshua T. Hill
/// Date: 5/16/2024
/// Description: The model for the ChangePasswordPage.
/// Bugs: n/a
/// Reflection: n/a

import 'package:athlete_surveyor/database.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';

/// Model for the ChangePasswordPage class.
class ChangePasswordModel extends ChangeNotifier
{

  /// Update the password and return 'true' if successful.
  Future<bool> updateUserPassword(String userId, String newPassword) async
  {
    String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt()); // Hash new password for security.

    final result = await Database.updateUserPasswordById(userId, hashedPassword, false);

    return result.affectedRows > 0 ? true : false;
  }

}