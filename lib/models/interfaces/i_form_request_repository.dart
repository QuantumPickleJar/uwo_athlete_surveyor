import 'package:athlete_surveyor/models/form_request.dart';

/// handles the assignment of forms to students by staff, as well as completion of 
/// said requests with respect to their issuing date.
abstract class IFormRequestRepository {
  Future<List<FormRequest>> getFormRequestsByUserId(String userId);
}
