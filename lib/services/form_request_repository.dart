import 'package:athlete_surveyor/models/form_request.dart';
import 'package:athlete_surveyor/models/interfaces/i_form_request_repository.dart';
import 'package:athlete_surveyor/database.dart';
import 'package:postgres/postgres.dart';

class FormRequestRepository implements IFormRequestRepository{

  @override                 
  Future<List<FormRequest>> getFormRequestsForStudent(String studentId) async {
    try {
      final requests = await Database.fetchStudentFormRequests(studentId: studentId);
      return unpackRequests(requests);
    } catch (e) {
      print('[FormRequestRepo] Error fetching for student $studentId!');
      rethrow;
    }
  }
  
  @override
  Future<List<FormRequest>> getUserAuthoredFormRequests(String userId) async {
    try {
      /// poll them from the database
      final requests = await Database.fetchAuthoredFormRequests(userId: userId);
      return unpackRequests(requests);
    } catch (e) {
      print('[FormRequestRepo] Error fetching for staf f$userId!');
      rethrow;
    }
  }

  /// utility method: unpacks the rows from querying the SQL tables
  List<FormRequest> unpackRequests(Result requests) {
    return requests.map((row) => /// map the rows out from the ResultSet
      FormRequest.fromJson(row.toColumnMap())).toList();
  }
}