import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/models/form_request.dart';

abstract class IUserRepository {
  Future<LoggedInUser?> fetchUser({required String username, required String password});
  Future<List<FormRequest>> getStudentFormRequests(String studentId);
  Future<List<FormRequest>> getStaffAuthoredFormRequests(String userId);
  Future<LoggedInUser?> getUserByUsername(String username);
  Future<bool> verifyPassword(String username, String password);

}


