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
  static const String _getEmailsQuery = "SELECT date_received, address_from, subject_line, body FROM tbl_inbox;";
  static const String _getStudentList = "SELECT student_name, grade, sport FROM tbl_studentList"; 
  static const String _getPreviousFormsQuery = "SELECT form_name, associated_sport, date_received, date_completed FROM tbl_previous_forms_temp;";
  static const String _getSpecificUser = "SELECT * FROM tbl_users WHERE username = @username";
  // SQL insert query strings. ***Note on inserts; add "RETURNING <column_name>" to end of insert queries to get a Result from them, with <column name> usually being the ID that gets assigned to it.
  static const String _insertAthlete = "INSERT INTO tbl_studentlist (student_name, grade, sport, student_id) VALUES (@studentName, @grade, @sport, @id)";
  //static const String _getUserPassword = "SELECT * FROM tbl_users WHERE username = @username";
  static const String _insertNewUser = "INSERT INTO tbl_users (username,password,is_admin) VALUES (@username,@password,@is_admin)";
  //static const String _deleteAthlete = " DElETE FROM tbl_studentlist WHERE student_name =  @name AND grade = @grade AND sport = @sport";
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
  static Future<Result> executeSQLCommand(String query, Object? optionalParameters) async
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

  /// Get all Emails from the database.
  static Future<Result> fetchEmails() async { return executeSQLCommand(_getEmailsQuery,null); }

  /// Get all previously completed forms from the database.
  static Future<Result> fetchPreviousForms() async { return executeSQLCommand(_getPreviousFormsQuery,null); }

  /// Fetching the student list
  static Future<Result> fetchStudents() async { return executeSQLCommand(_getStudentList,null); }

  /// Get a user's profile based on their provided username.
  static Future<Result> fetchUser(String username) async
  {
    // return executeSQLCommand(_getSpecificUser, 
    //                         {'username':username});
    return executeSQLCommand(_getSpecificUser, 
                            {'username':username});
  }

  /// Connects the app to the data base and gets the athletes put in on the app into the database
  static Future<Result> insertAthlete(String studentName, String grade, String sport, String id) async 
  {
    return executeSQLCommand(_insertAthlete, 
                            {'student_name':studentName, 'grade':grade, 'sport':sport, 'student_id': id});
  }

  /// Insert a new user to the DB; bool response shows whether or not it was successful.
  static Future<Result> insertNewUser(String username, String password, String firstName, String lastName, bool isAdmin) async
  {
    return executeSQLCommand(_insertNewUser, 
                            {'username':username, 'password':password, 'first_name':firstName, 'last_name':lastName, 'is_admin':isAdmin});
  }

}
