abstract class User {
  
  final String userId;              /// Referenced as `uuid_user` in the table
  final String username;  
  final String firstName;           /// Referenced as `first_name` in the table
  final String lastName;            /// Referenced as `last_name` in the table

  User({required this.userId, required this.username, required this.firstName, required this.lastName});
}

class Staff extends User {
  Staff({
    required super.userId,
    required super.username,
    required super.firstName,
    required super.lastName,
  });
}

class Student extends User {
  Student({
    required super.userId, 
    required super.username, 
    required super.firstName, 
    required super.lastName
  });
}