/// Most basic user class, to represent a registered user
abstract class User {
  final String userId;
  final String username;
  final String firstName; 
  final String lastName;

  User({required this.userId, required this.username, required this.firstName, required this.lastName});
}

class Staff extends User {
  Staff({required super.userId, required super.username, required super.firstName, required super.lastName});
  
  // Additional staff-specific methods here
}

class Student extends User {
  Student({required super.userId, required super.username, required super.firstName, required super.lastName});
  
  // Additional staff-specific methods here
}