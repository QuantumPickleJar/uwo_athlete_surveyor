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

}
