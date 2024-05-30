abstract class User {
  
  final String userId;              /// Referenced as `uuid_user` in the table
  final String username;            /// the EMAIL of the user
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
  final String grade;
  final String sport;

  Student({
    required String userId,
    required String username,
    required String firstName,
    required String lastName,
    required this.grade,
    required this.sport,
  }) : super(userId: userId, username: username, firstName: firstName, lastName: lastName);

  factory Student.fromMap(Map<String, dynamic> userData) {
    return Student(
      userId: userData['uuid_user'] as String,
      username: userData['username'] as String,
      firstName: userData['first_name'] as String,
      lastName: userData['last_name'] as String,
      grade: userData['grade'] as String,
      sport: userData['sport'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid_user': userId,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'grade': grade,
      'sport': sport,
    };
  }


  /// Used to show the first and last name of the User
  String get fullName { return '$firstName $lastName'; }

  /// Prints the email [username], and concatenated first-last name of User
  @override
  String toString() {
    return '$username, ${firstName + ' ' + lastName}';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    /// since emails get stored in the username, we check [userId] and [username]
    return other is User && 
      other.userId == userId &&
      other.username == username;
  }

  /// Check two objects for equality
  @override
  int get hashCode => Object.hash(username, userId, firstName, lastName);
}