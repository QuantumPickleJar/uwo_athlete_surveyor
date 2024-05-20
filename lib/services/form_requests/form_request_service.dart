import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/interfaces/i_form_request_repository.dart';
import 'package:athlete_surveyor/models/interfaces/i_form_repository.dart';
import 'package:athlete_surveyor/models/interfaces/i_user_repository.dart';
import 'package:athlete_surveyor/models/student_model.dart';
import 'package:athlete_surveyor/services/db.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

class FormRequestService {
  final IFormRepository _formRepository;
  final IFormRequestRepository _formRequestRepository;
  final IUserRepository _userRepository;


  /// TODO: implement a UserRepository for cohesive readability
  FormRequestService(this._formRepository, this._formRequestRepository, this._userRepository);

  /// Creates a new form request and assigns it to the given recipients
  Future<void> createFormRequest(String formId, String requestingUserId, List<String> recipientIds) async {
    var db = await PostgresDB.getConnection();
    try {
      // Start a transaction
      await db.runTx((tx) async {
        // Create a new form request
        String requestId = Uuid().v4();
        String sqlCreateFormRequest = """
          INSERT INTO tbl_form_requests (form_id, request_id, requesting_user_id, create_date)
          VALUES (@formId, @requestId, @requestingUserId, @createDate);
        """;
        await tx.execute(Sql.named(sqlCreateFormRequest), parameters: {
          'formId': formId,
          'requestId': requestId,
          'requestingUserId': requestingUserId,
          'createDate': DateTime.now().toIso8601String(),
        });

        // Assign the form request to recipients
        for (String recipientId in recipientIds) {
          String sqlAssignRecipient = """
            INSERT INTO tbl_request_recipients (request_id, student_id)
            VALUES (@requestId, @studentId);
          """;
          await tx.execute(Sql.named(sqlAssignRecipient), parameters: {
            'requestId': requestId,
            'studentId': recipientId,
          });
        }
      });
    } catch (e) {
      print('Error creating form request: $e');
      rethrow;
    } finally {
      await PostgresDB.closeConnection();
    }
  }

  /// Retrieves all form requests for a specific user
  Future<List<Future<GenericForm>>> getFormRequestsByUserId(String userId) async {
    try {
      var formRequests = await _formRequestRepository.getUserAuthoredFormRequests(userId);
      return formRequests.map((request) async {
        print('Retreived requests ${formRequests}');
        
        var form = await _formRepository.getFormById(request.formId);
        return form!;
      }).toList();
    } catch (e) {
      print('Error fetching form requests for user with id $userId: $e');
      rethrow;
    }
  }
}
