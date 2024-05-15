// ignore_for_file: dangling_library_doc_comments

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: A data-object to represent the persistent information of the current user for use throughout the application.
/// Bugs: n/a
/// Reflection: n/a

/// Data Object to represent the currently logged-in user and any information about them that may be needed during use of application.
class LoggedInUser
{
  final String _uuid;
  final bool _isAdmin;
  final bool _isTempPassword;
  final String _username;
  final String _firstName;
  final String _lastName;

  String get userUuid => _uuid;
  bool get hasAdminPrivileges => _isAdmin;
  bool get hasTempPassword => _isTempPassword;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _username;

  LoggedInUser(this._uuid, this._isAdmin, this._isTempPassword, this._username, this._firstName, this._lastName);
}