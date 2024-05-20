import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/models/form_request.dart';
import 'package:athlete_surveyor/models/users/user_types.dart';
import 'package:athlete_surveyor/services/form_request_repository.dart';
import 'package:athlete_surveyor/database.dart';
import 'package:bcrypt/bcrypt.dart';

class UserRepository {
  /// needed to track incoming/outgoing [FormRequest] operations
  final FormRequestRepository _formRequestRepository = FormRequestRepository();

  Future<List<FormRequest>> getStudentFormRequests(String studentId) async {
    return _formRequestRepository.getFormRequestsForStudent(studentId);
  }

  Future<List<FormRequest>> getStaffAuthoredFormRequests(String userId) async {
    return _formRequestRepository.getUserAuthoredFormRequests(userId);
  }


  /// Fetches a user in preparation for logging them in and placing them into the appropriate
  /// model.  
  /// Accepts a [password], so this should NOT be used for querying profiles.  
  Future<LoggedInUser?> fetchUser({
    required String username, required String password}) async {
    try {
      /// first we get the user, which comes out of a [Result] object
      final result = await Database.fetchUser(username: username);
      if (result.length != 1) {
        print('[UserRepository] Failed to find user with name $username!');
        return null; 
      }

      /// using a Map may take an extra line here, but it's much easier to read and parse from
      Map<String, dynamic> userData = result.first;
      String hashedPassword = userData['password'] as String;

      bool passwordMatched = BCrypt.checkpw(password, hashedPassword);
      if (passwordMatched) {
        return LoggedInUser.fromMap(userData);

        return LoggedInUser(
          userId: userData['uuid_user'] as String,
          username: userData['username'] as String,
          firstName: userData['first_name'] as String,
          lastName: userData['last_name'] as String,
          isAdmin: userData['is_admin'] as bool,
          isTempPassword: userData['is_temp_password'] as bool,
        );
        
        // return LoggedInUser(
        //         userId: result[0][0] as String,
        //         username: result[0][3] as String,
        //         firstName: result[0][5] as String,
        //         lastName: result[0][6] as String,
        //         isAdmin: result[0][2] as bool,
        //         isTempPassword: result[0][4] as bool);
      } else {
        return null;
      }
    } catch (e) {
      print('[UserRepository] Error fetching user $username');
      rethrow;
    }
  }

  /// Verifies a users password by first querying them through the [fetchUser] 
  /// function (just the one that takes a [username])
  Future<bool> verifyPassword(String username, String password) async {
    try {
      final result = await Database.fetchUser(username: username);
      if (result.length != 1) {
        return false; // User not found or multiple entries found
      }
      Map<String, dynamic> userData = result.first;
      String hashedPassword = userData['password'] as String;

      bool matched = BCrypt.checkpw(password, hashedPassword);
      print('[UserRepository] Password $password successfully hashed!');
      return matched;
    } catch (e) {
      print('Error verifying password ($password): $e');
      rethrow;
    }
  }
  
   Future<LoggedInUser?> getUserByUsername(String username) async {
    try {
      final result = await Database.fetchUser(username: username);
      if (result.isEmpty) {
        return null;
      }
      Map<String, dynamic> userData = result.first;
        return LoggedInUser.fromMap(userData);
      // return LoggedInUser(
      //   userId: userData['uuid_user'] as String,
      //   username: userData['username'] as String,
      //   firstName: userData['first_name'] as String,
      //   lastName: userData['last_name'] as String,
      //   isAdmin: userData['is_admin'] as bool,
      //   isTempPassword: userData['is_temp_password'] as bool,
      // );
    } catch (e) {
      print('Error fetching user by username: $e');
      rethrow;
    }
  }


  Future<void> updateUserPassword(String userId, String newPassword, bool isTempPassword) async {
    try {
      String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
      await Database.updateUserPasswordById(userId, hashedPassword, isTempPassword);
    } catch (e) {
      print('Error updating user password: $e');
      rethrow;
    }
  }
}
