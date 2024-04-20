/// This file is a cobbled together SQL migrated form of the original plan to have Forms stored 
/// across Google Sheets.
// file: form_repository.dart
import 'package:athlete_surveyor/models/interfaces/i_form_respository.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:postgres/postgres.dart';

// Concrete implementation of the FormRepository
class FormRepository implements IFormRepository {
  static final FormRepository _db_instance = FormRepository._internal();

  factory FormRepository() {
    return _db_instance;
  }

  FormRepository._internal();

  // Implement the database operations using whatever database package you are using
  // ...

  @override
  Future<Form> createForm(Form form) async {
    // Insert form into the database and return the inserted form
    
  }
  
  @override
  Future<void> deleteForm(String formId) {
    // TODO: implement deleteForm
    throw UnimplementedError();
  }
  
  @override
  Future<List<Form>> getAllForms() {
    // TODO: implement getAllForms
    throw UnimplementedError();
  }
  
  @override
  Future<Form?> getFormById(String formId) {
    // TODO: implement getFormById
    throw UnimplementedError();
  }
  
  @override
  Future<void> updateForm(Form form) {
    // TODO: implement updateForm
    throw UnimplementedError();
  }

  /// Establishes a connection to the forms db using the provided
  /// host, database name, port, username, and password. It returns a [Connection]
  /// object that can be used to interact with the database.
  /// 
  /// Returns:
  ///   A [Future] that completes with a [Connection] object.
  Future<Connection> getConnString() async {
    return await Connection.open(
      Endpoint(
        host: 'cs361-lab3-13043.5xj.gcp-us-central1.cockroachlabs.cloud',
        // host: dotenv.env['COCKROACH_DB_HOST'] ?? "Bad Host!",
        database: 'uwo_forms_docs_test',
        port: 26257,
        password: 'cn9T0AvFn056o6Dz1ziyRg',
        // password: dotenv.env['COCKROACH_DB_PASSWORD'] ?? "Password Missing!",
        username: 'quantumpicklejar'
      )
    );
  }
}
