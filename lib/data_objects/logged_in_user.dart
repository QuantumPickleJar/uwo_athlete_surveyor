// Data Object to represent the currently logged-in user and any information about them that may be needed during use of application.
import 'package:athlete_surveyor/models/users/user_types.dart';

class LoggedInUser extends User
{
  final bool isAdmin;                         /// Referenced as `is_admin` in the table
  final bool isTempPassword;                  /// Referenced as `is_temp_password` in the table

  /// wraps the user in a model-friendly class that extends [User]
  LoggedInUser({
    required super.userId, 
    required super.username, 
    required super.firstName, 
    required super.lastName, 
    required this.isAdmin,
    required this.isTempPassword
  });

  bool get hasAdminPrivileges => isAdmin;
  bool get hasTempPassword => isTempPassword;

  /// Minifying function, reduces line count in UserRepository and Database
  /// NOTE: inconsisntent syntax standard
  factory LoggedInUser.fromMap(Map<String, dynamic> userData) {
    assert(userData.containsKey('uuid_user'), 'userId (uuid_user) field is missing');
    assert(userData.containsKey('username'), 'username field is missing');
    assert(userData.containsKey('first_name'), 'firstName (first_name) field is missing');
    assert(userData.containsKey('last_name'), 'lastName (last_name) field is missing');
    assert(userData.containsKey('is_admin'), 'isAdmin (is_admin) field is missing');
    assert(userData.containsKey('isTempPassword'), 'isTempPassword (is_temp_password) field is missing');

    return LoggedInUser(
      userId: userData['uuid_user'] as String,
      username: userData['username'] as String,
      firstName: userData['first_name'] as String,
      lastName: userData['last_name'] as String,
      isAdmin: userData['is_admin'] as bool,
      isTempPassword: userData['is_temp_password'] as bool,
    );
  }
}
