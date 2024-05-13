// ignore_for_file: avoid_print

import 'package:postgres/postgres.dart';

/// Static database class to handle all SQL transactions.
/// TODO: consolidate common SQL query methods
class Database 
{
  static const String _dbHost = "cs361-lab3-13043.5xj.gcp-us-central1.cockroachlabs.cloud";
  static const int _dbPort = 26257;
  static const String _dbName = "uwo_forms_docs_test";
  static const String _dbUser = "joshhill";
  static const String _dbPass = "0LMiuWwPzCfrlub7YlKxpw";
  // SQL fetch query strings.
  static const String _getEmailsQuery = "SELECT date_received, from_uuid, subject_line, body, first_name, last_name FROM tbl_inbox ti LEFT JOIN tbl_users tu ON ti.from_uuid = tu.uuid_user;";
  static const String _getStudentList = "SELECT student_name, grade, sport FROM tbl_studentList"; 
  static const String _getPreviousFormsQuery = "SELECT form_name, associated_sport, date_received, date_completed FROM tbl_previous_forms_temp;";
  static const String _insertAthlete = "INSERT INTO tbl_studentlist (student_name, grade, sport) VALUES (@studentName, @grade, @sport)";
  static const String _getUserPassword = "SELECT * FROM tbl_users WHERE username = @username";
  static const String _insertNewUser = "INSERT INTO tbl_users (username,password,is_admin) VALUES (@username,@password,@is_admin)";

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

  /// Get all Emails from the database.
  static Future<Result> fetchEmails() async 
  { 
    Connection? conn; 
    try 
    { 
      conn = await getOpenConnection(); 
      final Result result = await conn.execute(_getEmailsQuery);
      return result;
    } 
    catch (e) 
    { 
      print('Error fetching data: $e'); 
      rethrow;
    } 
    finally 
    { 
      conn?.close();
    } 
  }

  /// Get all Emails from the database.
  static Future<Result> fetchPreviousForms() async 
  { 
    Connection? conn; 
    try 
    { 
      conn = await getOpenConnection(); 
      final Result result = await conn.execute(_getPreviousFormsQuery);
      return result;
    } 
    catch (e) 
    { 
      print('Error fetching data: $e'); 
      rethrow;
    } 
    finally 
    { 
      conn?.close();
    } 
  }

  //fetching the student list
  static Future<Result> fetchStudents() async 
  { 
    Connection? conn; 
    try 
    { 
      conn = await getOpenConnection(); 
      final Result result = await conn.execute(_getStudentList);
      return result;
    } 
    catch (e) 
    { 
      print('Error fetching data: $e'); 
      rethrow;
    } 
    finally 
    { 
      conn?.close();
    } 
  }

  //connects the app to the data base and gets the athletes put in on the app into the database
  static Future<void> insertAthlete(String studentName, String grade, String sport) async 
  {
    Connection? conn;
    try
    {
      conn = await getOpenConnection(); 
      await conn.execute
      (
        Sql.named(_insertAthlete),
        parameters: {'student_name': studentName, 'grade': grade, 'sport': sport}
      );
        print('Connected successfully.');
    }
    catch (e)
    {
      print('Error inserting data: $e');
      rethrow;
    }
    finally
    {
      conn?.close();
    } 
  }

  /// Get a user's password based on their provided username (usually to check against the password they provided for login).
  static Future<Result> fetchUserPassword(String userName) async
  {
    Connection? conn;
    try
    {
      conn = await getOpenConnection(); 
      return await conn.execute
      (
        Sql.named(_getUserPassword),
        parameters: {'username': userName}
      );
    }
    catch (e)
    {
      print('Error fetching data: $e');
      rethrow;
    }
    finally
    {
      conn?.close();
    } 
  }

  /// Insert a new user to the DB; bool response shows whether or not it was successful.
  static Future<bool> insertNewUser(String username, String password, bool isAdmin) async
  {
    Connection? conn;
    try
    {
      conn = await getOpenConnection(); 
      await conn.execute
      (
        Sql.named(_insertNewUser),
        parameters: {'username': username, 'password': password, 'is_admin': isAdmin}
      );
    }
    catch (e)
    {
      print('Error inserting data: $e');
      return false; // insertion not successful
    }
    finally
    {
      conn?.close();
    } 

    return true;
  }
}