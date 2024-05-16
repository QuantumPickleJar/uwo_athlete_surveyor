// ignore_for_file: dangling_library_doc_comments

/// Name: Vincent Morrill
/// Date: 3/20/24
/// Description: Abstractor for database connection handling
/// Bugs: SportsRepository silently fails 
/// Reflection: Making this might have been a bad idea, although it was hard to tell
/// for certain.  We had some serious issues performing reads due to being unable to 
/// perform any transactions that contained more than one query

import 'package:postgres/postgres.dart';
/// Abstracts the single connection to the database from the several
/// Repository classes
class PostgresDB {

  static Connection? _connection;

  /// Establishes a connection to the forms db using the provided
  /// host, database name, port, username, and password. It returns a [Connection]
  /// object that can be used to interact with the database.
  /// 
  /// Returns:
  ///   A [Future] that completes with a [Connection] object.
  static Future<Connection> getConnection() async {
    /// re-open connection if not done already
    if(_connection == null || !_connection!.isOpen) {
      _connection = await Connection.open(
      Endpoint(
        host: 'cs361-lab3-13043.5xj.gcp-us-central1.cockroachlabs.cloud',
        database: 'uwo_forms_docs_test',
        port: 26257,
        password: 'cn9T0AvFn056o6Dz1ziyRg',
        username: 'quantumpicklejar'
        )
      );
    }
    return _connection!;
  }

  /// closes the connection so other processes may use it
  static void closeConnection() {
    _connection?.close();
    _connection = null;
  }
}