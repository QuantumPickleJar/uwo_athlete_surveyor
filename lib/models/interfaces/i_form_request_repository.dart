import 'package:athlete_surveyor/models/form_request.dart';

/// handles the assignment of forms to students by staff, as well as completion of 
/// said requests with respect to their issuing date.
abstract class IFormRequestRepository {

  /// Queries staff-assigned Form Requestrs for a given student's [studentId]
  Future<List<FormRequest>> getFormRequestsForStudent(String studentId);
  
  /// Queries user-made requests for staff with id [userId]
  Future<List<FormRequest>> getUserAuthoredFormRequests(String userId);


}
