/// This file is a cobbled together SQL migrated form of the original plan to have Forms stored 
/// across Google Sheets.
// file: form_repository.dart
import 'package:athlete_surveyor/models/interfaces/i_form_respository.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:postgres/postgres.dart';

// Concrete implementation of the FormRepository
class FormRepository implements IFormRepository {
  final Connection _connection;
  static FormRepository? _db_instance;

  static FormRepository getInstance(Connection connection) {
    _db_instance ??= FormRepository._internal(connection);
    return _db_instance!;
  }
  
  /// Private constructor
  FormRepository._internal(this._connection);

  @override
  Future<Form> createForm(Form form) async {
    // Insert form into the database and return the inserted form
    String sqlStatement = """INSERT INTO tbl_forms 
                            (form_id, user_id, form_title, last_modified, create_date)
                            VALUES (@formId, @userId, @formTitle, @lastModified, @createDate) 
                            RETURNING *;""";
    var result = await _connection.execute(
      sqlStatement, parameters: {
        'formId': form.formId,
        'userId': 'user-id', // For now, since you don't have auth
        'formTitle': form.formName,
        'lastModified': DateTime.now(),
        'createDate': DateTime.now()
      }
    );
    if (result.isEmpty) {
      throw Exception('Failed creating form.');
    } 
    /// use our helper function to map the resulting columns out to a [Form]
    return _mapRowToForm(result.first.toColumnMap());
  }

  /// Hhelper function to convert a database row to a Form object
  Form _mapRowToForm(Map<String, dynamic> row) {
    return Form(
      formId: row['form_id'],
      formName: row['form_title'],
      sport: 'Sport Placeholder', // Replace with actual value if it's available
      formDateCreated: row['create_date'],
      questions: [], // This needs to be filled with actual questions from a related query
    );
  }
  
  /// Deletes a form and its questions from tbl_forms
  @override
  Future<bool> deleteForm(String formId) async {
    String sqlStatement = "DELETE FROM tbl_forms WHERE form_id LIKE @formId";
    var result = await _connection.execute(
      Sql.named(sqlStatement), parameters: { 'formId': formId }
    );

    if (result.affectedRows > 0) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }
  
  
  @override
  Future<List<Form>> getAllForms() async {
    String sqlStatement = "SELECT form_id, user_id, form_title, last_modified, create_date FROM public.tbl_forms;";
    final result = await _connection.execute(Sql.named(sqlStatement));

    // if(result.isNotEmpty) {
    //   for (var row in result) {
    //     var cols = row.toColumnMap(); // unpack the columns into an object
    //     // _forms.add(
    //     results.add(
    //       Form(formId: cols['form_id'], formName: cols['form_title'], sport: "NOT_STORED_IN_TABLE", questions: [])
    //     );
    //   }
    // }
    
    return result.map((row) => _mapRowToForm(row.toColumnMap())).toList();
  }
  
  /// Retrieves a form by its id
  @override
  Future<Form?> getFormById(String formId) async {
    // TODO: implement getFormById
    // return _forms.firstWhere((form) => form.formId == formId, orElse: () => null as Form?);
    String sqlStatement = "SELECT form_title, last_modified, create_date FROM public.tbl_forms WHERE form_id LIKE @formId;";
    var result = await _connection.execute(sqlStatement, parameters: formId);
    if(result.isEmpty) {
      return null;
    }
    return _mapRowToForm(result.first.toColumnMap());
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
