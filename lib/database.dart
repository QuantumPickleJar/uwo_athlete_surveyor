// ignore_for_file: avoid_print, dangling_library_doc_comments

/// Name: Joshua T. Hill, Amanda Dorsey
/// Date: 5/15/2024
/// Description: The file representing the Database layer of our application.
/// Bugs: n/a
/// Reflection: left the const Strings here instead of moving to constants file as it didn't feel appropriate.

import 'package:athlete_surveyor/models/response_type.dart';
import 'package:postgres/postgres.dart';

/// Static database class to handle all SQL transactions.
class Database 
{
  /// Database connection credentials.
  static const String _dbHost = "cs361-lab3-13043.5xj.gcp-us-central1.cockroachlabs.cloud";
  static const int _dbPort = 26257;
  static const String _dbName = "uwo_forms_docs_test";
  static const String _dbUser = "joshhill";
  static const String _dbPass = "0LMiuWwPzCfrlub7YlKxpw";
  // static const String _dbHost = 'cs361-lab3-13043.5xj.gcp-us-central1.cockroachlabs.cloud';
  // static const String _dbPass = 'cn9T0AvFn056o6Dz1ziyRg';
  // static const String _dbUser = 'quantumpicklejar';
  
  /// SQL fetch query strings.
  static const String _getMessagesById = "SELECT date_received, from_uuid, subject_line, body, first_name, last_name FROM tbl_inbox ti LEFT JOIN tbl_users tu ON ti.from_uuid = tu.uuid_user WHERE ti.to_uuid = @userId;";
  static const String _getStudentList = "SELECT student_name, grade, sport, student_id FROM tbl_studentList"; 
  static const String _getPreviousForms = "SELECT form_name, associated_sport, date_received, date_completed FROM tbl_previous_forms_temp;";
  static const String _getSpecificUser = "SELECT * FROM tbl_users WHERE username = @username";
  static const String _getQuestionByQuestionId = """SELECT content, order_in_form, form_id, question_id, response_enum FROM public.tbl_questions WHERE question_id = @questionId;""";
  static const String _getAllQuestionsQuery = """SELECT * FROM tbl_questions""";
  static const String _getAllQuestionsByFormId = """SELECT * from tbl_questions WHERE form_id = @formId""";
  static const String _getAllForms = "SELECT form_id, user_id, form_title, last_modified, create_date FROM public.tbl_forms;";
  static const String _getFormById = """SELECT form_id, form_title, last_modified, create_date FROM public.tbl_forms WHERE form_id = @formId;""";
  static const String _getEmailServiceApiKey = "SELECT key FROM tbl_api_keys WHERE name='sendgrid'";
  /// SQL insert query strings. ***Note on inserts; add "RETURNING <column_name>" to end of insert queries to get a Result from them, with <column name> usually being the ID that gets assigned to it.
  static const String _insertAthlete = "INSERT INTO tbl_studentlist (student_name, grade, sport, student_id) VALUES (@studentName, @grade, @sport, @id)";
  static const String _insertNewUser = "INSERT INTO tbl_users (username,password,first_name,last_name,is_admin) VALUES (@username,@password,@first_name,@last_name,@is_admin) RETURNING uuid_user";
  static const String _insertNewQuestionByFormId = """INSERT INTO public.tbl_questions (content, order_in_form, form_id, response_enum VALUES (@content, @order, @formId, @responseEnum) RETURNING *;""";
  static const String _insertNewQuestions = "INSERT INTO public.tbl_questions (content, order_in_form, form_id, response_enum) VALUES @values";
  static const String _insertNewForm = """INSERT INTO tbl_forms (user_id, form_title, last_modified, create_date) VALUES (@userId, @formTitle, @lastModified, @createDate) RETURNING form_id, form_title, create_date;""";
  /// SQL delete query strings.
  static const String _deleteQuestion = """DELETE * FROM public.tbl_questions WHERE question_id = @questionId;""";
  static const String _deleteAllQuestionsWithFormId = "DELETE FROM public.tbl_questions WHERE form_id = @formId";
  static const String _deleteFormById = "DELETE FROM tbl_forms WHERE form_id = @formId";
  /// SQL update query strings.
  static const String _updateQuestion = """UPDATE public.tbl_questions SET content = @content, order_in_form = @order, form_id = @formId, response_enum = @responseEnum WHERE question_id = @questionId;""";
  static const String _updateFormById = """UPDATE public.tbl_forms SET user_id = @userId, form_title = @formTitle, last_modified = current_date() WHERE form_id = @formId""";
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

  /// Get all previously completed forms from the database.
  static Future<Result> fetchPreviousForms() async { return _executeSQLCommand(_getPreviousForms,null); }

  /// Fetching the student list
  static Future<Result> fetchStudents() async { return _executeSQLCommand(_getStudentList,null); }

  /// 
  static Future<Result> fetchAllQuestions() async { return _executeSQLCommand(_getAllQuestionsQuery,null); }

  /// 
  static Future<Result> fetchAllForms() async { return _executeSQLCommand(_getAllForms,null); }

  /// 
  static Future<Result> fetchEmailServiceApiKey() async { return _executeSQLCommand(_getEmailServiceApiKey,null); }

  /// Get a user's profile based on their provided username.
  static Future<Result> fetchUser(String username) async
  {
    return _executeSQLCommand(_getSpecificUser, 
                             {'username':username});
  }

  /// Get question with matching Id.
  static Future<Result> fetchQuestionByQuestionId(String questionId) async
  {
    return _executeSQLCommand(_getQuestionByQuestionId, 
                             {'questionId':questionId});
  }

  ///
  static Future<Result> fetchQuestionsByFormId(String formId) async
  {
    return _executeSQLCommand(_getAllQuestionsByFormId, 
                             {'formId':formId });
  }

  /// 
  static Future<Result> fetchFormById(String formId) async
  {
    return _executeSQLCommand(_getFormById, 
                             {'formId':formId});
  }

    /// Get all messages for the given user from the database.
  static Future<Result> fetchMessagesById(String userId) async 
  { 
    return _executeSQLCommand(_getMessagesById,
                             {'userId':userId});
  }

  /// Connects the app to the data base and gets the athletes put in on the app into the database
  static Future<Result> insertAthlete(String studentName, String grade, String sport, String id) async 
  {
    return _executeSQLCommand(_insertAthlete, 
                             {'student_name':studentName, 'grade':grade, 'sport':sport, 'student_id': id});
  }

  /// Insert a new user to the DB; returns the new user's DB UUID for reference.
  static Future<Result> insertNewUser(String username, String password, String firstName, String lastName, bool isAdmin) async
  {
    return _executeSQLCommand(_insertNewUser, 
                             {'username':username, 'password':password, 'first_name':firstName, 'last_name':lastName, 'is_admin':isAdmin});
  }

  /// Insert a new question into the DB associated with a form that has an Id of formId.
  static Future<Result> insertNewQuestionByFormId(String questionContent, int? questionOrdinal, String formId, ResponseWidgetType questionResFormat) async
  {
    return _executeSQLCommand(_insertNewQuestionByFormId, 
                             {'content':questionContent, 'order':questionOrdinal, 'formId':formId, 'responseEnum':questionResFormat});
  }

  /// 
  static Future<Result> insertNewQuestions(String concatenatedValues) async
  {
    return _executeSQLCommand(_insertNewQuestions, 
                             {'values':concatenatedValues});   
  }

  /// 
  static Future<Result> insertNewForm(String userId, String formTitle, String lastModified, String createDate) async
  {
    return _executeSQLCommand(_insertNewForm, 
                             {'userId':userId, 'formTitle':formTitle, 'lastModified':lastModified, 'createDate':createDate});
  }

  /// Removes a question from the database by its id. 
  static Future<Result> deleteQuestion(String questionId) async
  {
    return _executeSQLCommand(_deleteQuestion,
                             {'questionId':questionId});
  }

  /// 
  static Future<Result> deleteAllQuestionsWithFormId(String formId) async
  {
    return _executeSQLCommand(_deleteAllQuestionsWithFormId,
                             {'formId':formId});
  }

  ///
  static Future<Result> deleteFormById(String formId) async
  {
    return _executeSQLCommand(_deleteFormById,
                             {'formId':formId});
  }

  /// 
  static Future<Result> updateQuestion(String questionContent, int? questionOrdinal, String questionFormId, ResponseWidgetType questionResFormat, String questionId) async
  {
    return _executeSQLCommand(_updateQuestion, 
                             {'content':questionContent, 'order':questionOrdinal, 'formId':questionFormId, 'responseEnum':questionResFormat, 'questionId':questionId});
  }

  /// 
  static Future<Result> updateFormById(String? formId, String userId, String formTitle, DateTime lastModified, DateTime createDate) async
  {
    return _executeSQLCommand(_updateFormById,
                             {'formId':formId, 'userId':userId, 'formTitle':formTitle, 'lastModified':lastModified, 'createDate':createDate});
  }

  /// 
  static Future<Result> updateUserPasswordById(String userId, String newPassword, bool isTempPassword)
  {
    return _executeSQLCommand(_updateUserPasswordById,
                             {'password':newPassword, 'is_temp_password': isTempPassword, 'uuid_user':userId});     
  }

}
