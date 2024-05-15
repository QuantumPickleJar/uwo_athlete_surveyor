// ignore_for_file: dangling_library_doc_comments

/// Name:
/// Date:
/// Description:
/// Bugs:
/// Reflection:

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