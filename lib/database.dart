// ignore_for_file: avoid_print
import 'package:postgres/postgres.dart';

/// Static database class to handle all SQL transactions.
class Database 
{
  // Database connection credentials.
  static const String _dbHost = "cs361-lab3-13043.5xj.gcp-us-central1.cockroachlabs.cloud";
  static const int _dbPort = 26257;
  static const String _dbName = "uwo_forms_docs_test";
  static const String _dbUser = "joshhill";
  static const String _dbPass = "0LMiuWwPzCfrlub7YlKxpw";
  // SQL fetch query strings.
  static const String _getEmailsByUserId = "SELECT date_received, from_uuid, subject_line, body FROM tbl_inbox WHERE to_uuid = @userId;";
  static const String _getEmailsQuery = "SELECT date_received, from_uuid, subject_line, body FROM tbl_inbox;";
  static const String _getStudentList = "SELECT first_name, last_name, grade, sport FROM tbl_studentList"; 
  static const String _getPreviousFormsQuery = "SELECT form_name, associated_sport, date_received, date_completed FROM tbl_previous_forms_temp;";
  static const String _getSpecificUser = "SELECT * FROM tbl_users WHERE username = @username";
  static const String _getQuestionById = """SELECT content, order_in_form, form_id, question_id, response_enum FROM public.tbl_questions WHERE question_id = @questionId;""";
  static const String _getAllQuestionsQuery = """SELECT * FROM tbl_questions""";
  static const String _getAllQuestionsByFormId = """SELECT * from tbl_questions WHERE form_id = @formId""";

  /// gets all [FormRequest]s that were AUTHORED by the staff user with [userId].
  /// Will not work for accessing student-bound [FormRequest]s.
  static const String _getFormRequestsByUserId = """"
  SELECT fr.request_id, fr.form_id, fr.create_date 
  FROM tbl_form_requests fr
  WHERE fr.requesting_user_id = @userId;""";
   // SQL fetch query strings.

    /// gets all [FormRequest]s assigned to the student with an id of [studentId].
  static const String _getStudentFormRequests = """
      SELECT fr.request_id, fr.form_id, fr.create_date 
      FROM tbl_form_requests fr
      JOIN tbl_request_recipients rr ON fr.request_id = rr.request_id
      WHERE rr.student_id = @studentId;""";

  // static const String _getAllForms = "SELECT form_id, user_id, form_title, last_modified, create_date FROM public.tbl_forms;";
  static const String _getFormById = """SELECT form_id, form_title, last_modified, create_date FROM public.tbl_forms WHERE form_id = @formId;""";

  // static const String _getFormsByUserId = """SELECT form_id, form_title, last_modified, create_date FROM public.tbl_forms WHERE form_id = @formId;""";
  static const String _getMessagesById = "SELECT date_received, from_uuid, subject_line, body, first_name, last_name FROM tbl_inbox ti LEFT JOIN tbl_users tu ON ti.from_uuid = tu.uuid_user WHERE ti.to_uuid = @userId;";

  static const String _getEmailServiceApiKey = "SELECT key FROM tbl_api_keys WHERE name='sendgrid'";
  /// SQL insert query strings. ***Note on inserts; add "RETURNING <column_name>" to end of insert queries to get a Result from them, with <column name> usually being the ID that gets assigned to it.
  static const String _insertAthlete = "INSERT INTO tbl_studentlist (first_name, last_name, grade, sport, student_id) VALUES (@firstName, @lastName, @grade, @sport, @id)";
  //static const String _getUserPassword = "SELECT * FROM tbl_users WHERE username = @username";
  static const String _insertNewUser = "INSERT INTO tbl_users (username,password,is_admin) VALUES (@username,@password,@is_admin)";
  //static const String _deleteAthlete = " DElETE FROM tbl_studentlist WHERE student_name =  @name AND grade = @grade AND sport = @sport";
  static const String _updateUserPasswordById = "UPDATE tbl_users SET password = @password, is_temp_password = @is_temp_password WHERE uuid_user = @uuid_user";

  /// Open connection to the database.
  static Future<Connection> getOpenConnection() async 
  { 
    return Connection.open( 
      Endpoint
      ( 
        port: _dbPort, 
        host: _dbHost, 
        database: _dbName, 
        username: _dbUser, 
        password: _dbPass
      ),
      settings: const ConnectionSettings
      (
        sslMode: SslMode.verifyFull
      ), 
    ); 
  }

  /// Generic SQL execution method; just need to supply query and any parameters which should exist as constants in this file.
  static Future<Result> _executeSQLCommand(String query, Object? optionalParameters) async
  {
    Connection? conn;
    try 
    { 
      conn = await getOpenConnection(); 
      final Result result = await conn.execute
      (
        Sql.named(query),
        parameters: optionalParameters
      );

      return result;
    } 
    catch (e) 
    { 
      print('Error executing SQL command: $e'); 
      rethrow;
    } 
    finally 
    { 
      conn?.close();
    } 
  }

  /// gets all [FormRequest]s assigned to the student with an id of [studentId].
  static Future<Result> fetchStudentFormRequests({required String studentId}) async {
     return _executeSQLCommand(_getStudentFormRequests, {'studentId' : studentId});
     }
  
  /// gets all [FormRequest]s that were AUTHORED by the staff user with [userId].
  /// Will not work for accessing student-bound [FormRequest]s.
  static Future<Result> fetchAuthoredFormRequests({required String userId}) async {
     return _executeSQLCommand(_getFormRequestsByUserId, {'userId' : userId});
     }

  /// Get all Emails from the database.
  static Future<Result> fetchEmails() async { return _executeSQLCommand(_getEmailsQuery,null); }

  /// Get all of a single user's emails from the database
  static Future<Result> fetchEmailsByUserId(userId) async { return _executeSQLCommand(_getEmailsByUserId, { 'userId': userId}); }

  /// Get all previously completed forms from the database.
  static Future<Result> fetchPreviousForms() async { return _executeSQLCommand(_getPreviousFormsQuery,null); }

  /// Fetching the student list
  static Future<Result> fetchStudents() async { return _executeSQLCommand(_getStudentList,null); }

  /// Safe user-fetching method that only needs their [username]
  static Future<List<Map<String, dynamic>>> fetchUser({required String username}) async {
    final Result result = await _executeSQLCommand(_getSpecificUser, {'username': username});
    return result.map((row) => row.toColumnMap()).toList();
  }

  /// Get question with matching Id.
  static Future<Result> fetchQuestionByQuestionId(String questionId) async {
    return _executeSQLCommand(_getQuestionById, 
                             {'questionId':questionId});
  }

  /// Get all of the questions associated with a specific Form ID.
  static Future<Result> fetchQuestionsByFormId(String formId) async {
    return _executeSQLCommand(_getAllQuestionsByFormId, 
                             {'formId':formId });
  }

  /// Get a Form by specifying its ID
  static Future<Result> fetchFormById(String formId) async {
    return _executeSQLCommand(_getFormById, 
                             {'formId':formId});
  }

    /// Get all messages for the given user from the database.
  static Future<Result> fetchMessagesById(String userId) async { 
    return _executeSQLCommand(_getMessagesById,
                             {'userId':userId});
  }

  /// Connects the app to the data base and gets the athletes put in on the app into the database
  static Future<Result> insertAthlete(String firstName, String lastName, String grade, String sport, String id) async 
  {
    return _executeSQLCommand(_insertAthlete, 
                            {'first_name':firstName, 'last_name': lastName, 'grade':grade, 'sport':sport, 'student_id': id});
  }

  /// Connects the app to the data base and gets the athletes put in on the app into the database
  /// Accepts a Map of column data, alternative to [insertAthlete].  See [user_types] for more
  static Future<Result> insertAthleteFromData(Map<String, dynamic> studentData) async 
  {
    return _executeSQLCommand(_insertAthlete, studentData);
                            
  }

  /// Insert a new user to the DB; bool response shows whether or not it was successful.
  /// For clarification between the [Student] and [Staff] types:
  /// [username] - the email for the user
  /// [password] - 
  /// [firstName[] ]
  static Future<Result> insertNewUser(String username, String password, String firstName, String lastName, bool isAdmin) async
  {
    return _executeSQLCommand(_insertNewUser, 
                            {'username':username, 'password':password, 'first_name':firstName, 'last_name':lastName, 'is_admin':isAdmin});
  }


  /// Update a user's password using their ID, which is made available in the data-object LoggedInUser passed from the initial login screen forward to other pages.
  static Future<Result> updateUserPasswordById(String userId, String newPassword, bool isTempPassword)
  {
    return _executeSQLCommand(_updateUserPasswordById,
                             {'password':newPassword, 'is_temp_password': isTempPassword, 'uuid_user':userId});     
  }

}
