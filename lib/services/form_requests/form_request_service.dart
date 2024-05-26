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
    
      // return Future.wait(formRequests.map((request) async {
      //   var form = await _formRepository.getFormById(request.formId);
      //   return form!;
      // }).toList());
      
      return formRequests.map((request) async {
        print('[FormReqService] Processing FR {${request.requestId}, ${request.requestingUserId}}');
        
        var form = await _formRepository.getFormById(request.formId);
        return form!;
      }).toList();
    } catch (e) {
      print('Error fetching form requests for user with id $userId: $e');
      rethrow;
    }
  }


  /// Create a FormRequest from an [Email] being sent out, based on the students 
  /// listed as a recipient.
  /// 
  /// Since a form request may not necessarily be involved with the email, features
  /// a call to [sendEmail]
  Future<void> sendEmailWithFormRequest({
    required String senderId, 
    required List<String> recipientIds,
    required String subject,
    required String body,
    String? formId,
  }) async { 
    try {
      /// send the email 
      await sendEmail(
        senderId: senderId, 
        recipientIds: recipientIds, 
        subject: subject, 
        body: body
        );

      /// if [formId] is present, we'll need a new form request
      if (formId != null) {
        await createFormRequest(formId, senderId, recipientIds);
        /// TODO: might want to check for existing form requests matching [formId]
      }
    } catch (e) {
      print('Error sending email w/ form request: $e');
      rethrow;
    } finally {
      await PostgresDB.closeConnection();
    }
  }
  
  //// TODO: Might want to move this to an email service if things like read receipts are
  /// desired
  /// rudimentary email sending function
  Future<void> sendEmail(
    {required String senderId, 
    required List<String> recipientIds,
    required String subject,
    required String body}) async {
      try {
        var db = await PostgresDB.getConnection();
        await db.runTx((tx) async {
        // Insert email into the inbox
        for (String recipientId in recipientIds) {
          String sqlSendEmail = """
            INSERT INTO tbl_inbox (date_received, from_uuid, to_uuid, subject_line, body)
            VALUES (@dateReceived, @fromUuid, @toUuid, @subjectLine, @body);
          """;
          await tx.execute(Sql.named(sqlSendEmail), parameters: {
            'dateReceived': DateTime.now().toIso8601String(),
            'fromUuid': senderId,
            'toUuid': recipientId,
            'subjectLine': subject,
            'body': body,
          });
        }
      });
    } catch (e) {
      print('Error sending email: $e');
      rethrow;
    } finally {
      await PostgresDB.closeConnection();
    }
  }
}
