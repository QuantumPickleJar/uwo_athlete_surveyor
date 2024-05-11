// Data Object to represent the currently logged-in user and any information about them that may be needed during use of application.
class LoggedInUser
{
  final bool _isAdmin;
  final bool _isTempPassword;
  final String _username;

  /// Nullable so that we can treat the auto-generated emails as unique identifiers
  final String? _userId;
  final String _firstName;
  final String _lastName;

  bool get hasAdminPrivileges => _isAdmin;
  bool get hasTempPassword => _isTempPassword;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _username;
  String? get userId => _userId;

  LoggedInUser(
    this._userId,
    this._isAdmin, 
    this._isTempPassword, 
    this._username, this._firstName, this._lastName, 
    );
}

// class Staff extends LoggedInUser {
//   Staff({required super.userId, required super.username, required super.firstName, required super.lastName});
  
//   // Additional staff-specific methods here
// }

// class Student extends LoggedInUser {
//   Student({required super.userId, required super.username, required super.firstName, required super.lastName});
  
//   // Additional staff-specific methods here
// }