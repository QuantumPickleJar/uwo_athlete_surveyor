import 'package:postgres/postgres.dart';

/// Static database class to handle all SQL transactions.
class Database 
{
  static const String _dbHost = "cs361-lab3-13043.5xj.gcp-us-central1.cockroachlabs.cloud";
  static const int _dbPort = 26257;
  static const String _dbName = "uwo_forms_docs_test";
  static const String _dbUser = "joshhill";
  static const String _dbPass = "0LMiuWwPzCfrlub7YlKxpw";

  static const String _getEmailsQuery = "SELECT date_received, address_from, subject_line, body FROM tbl_inbox;";
  static const String _getStudentList = "SELECT student_name, grade, sport FROM tbl_studentList"; 
  static const String _getPreviousFormsQuery = "SELECT form_name, associated_sport, date_received, date_completed FROM tbl_previous_forms_temp;";
  static const String _insertAthlete = "INSERT INTO tbl_studentlist (student_name, grade, sport) VALUES (@studentName, @grade, @sport)";

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
}