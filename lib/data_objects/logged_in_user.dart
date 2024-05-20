// Data Object to represent the currently logged-in user and any information about them that may be needed during use of application.
import 'package:athlete_surveyor/models/users/user_types.dart';

class LoggedInUser extends User
{
  // final String _uuid;
  final bool isAdmin;
  final bool isTempPassword;

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
  factory LoggedInUser.fromMap(Map<String, dynamic> userData) {
    assert(userData.containsKey('userId'), 'userId field is missing');
    assert(userData.containsKey('username'), 'username field is missing');
    assert(userData.containsKey('firstName'), 'firstName field is missing');
    assert(userData.containsKey('lastName'), 'lastName field is missing');
    assert(userData.containsKey('isAdmin'), 'isAdmin field is missing');
    assert(userData.containsKey('isTempPassword'), 'isTempPassword field is missing');

    return LoggedInUser(
      userId: userData['userId'] as String,
      username: userData['username'] as String,
      firstName: userData['firstName'] as String,
      lastName: userData['lastName'] as String,
      isAdmin: userData['isAdmin'] as bool,
      isTempPassword: userData['isTempPassword'] as bool,
    );
  }
}
