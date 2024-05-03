/// This file is a cobbled together SQL migrated form of the original plan to have Forms stored 
/// across Google Sheets.
import 'package:athlete_surveyor/models/interfaces/i_form_respository.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:postgres/postgres.dart';
import 'package:athlete_surveyor/services/db.dart';
import 'package:uuid/v4.dart';

// Concrete implementation of the FormRepository
class FormRepository implements IFormRepository {
  // final Connection _connection;
  Future<Connection> get _connection async => await PostgresDB.getConnection();
  // static FormRepository? _db_instance;

  FormRepository();
  
  /// Private constructor
  FormRepository._internal();

  /// used temporarily to streamline the demo
  final String DEVELOPER_UUID = "a23e1679-d5e9-4d97-9902-bb338b38e468";
  
  @override
  Future<GenericForm> createForm(GenericForm form) async {
    try {// Insert form into the database and return the inserted form
    String sqlStatement = """INSERT INTO tbl_forms 
                            (user_id, form_title, last_modified, create_date)
                            VALUES (@userId, @formTitle, @lastModified, @createDate) 
                            RETURNING *;""";

    
    var db = await _connection;
    var result = await db.execute(
        // Sql.named(sqlStatement), parameters: {
        /// TODO: remove the LOGICAL reliance on a hard-coded UUID
        Sql.named(sqlStatement), parameters: {
          'userId': DEVELOPER_UUID, // For now, since you don't have auth
          'formTitle': form.formName,
          'lastModified': DateTime.now().toIso8601String(),
          'createDate': DateTime.now().toIso8601String(), 
        }

        
      );
    if (result.isEmpty) {
      throw Exception('Failed creating form.');
    } 
    /// use our helper function to map the resulting columns out to a [Form]
    return _mapRowToForm(result.first.toColumnMap());
    } finally {
      PostgresDB.closeConnection();
    }
  }

  /// Hhelper function to convert a database row to a Form object
  GenericForm _mapRowToForm(Map<String, dynamic> row) {
    return GenericForm(
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
    try { 
      String sqlStatement = "DELETE FROM tbl_forms WHERE form_id LIKE @formId";
      var db = await _connection;
      var result = await db.execute(
        Sql.named(sqlStatement), parameters: { 'formId': formId }
      );
      /// provide feedback about the operation's success/failure
      if (result.affectedRows > 0) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } finally {
      PostgresDB.closeConnection();
    }
  }
  
  
  @override
  Future<List<GenericForm>> getAllForms() async {
    try {

    String sqlStatement = "SELECT form_id, user_id, form_title, last_modified, create_date FROM public.tbl_forms;";
    var db = await _connection;
    final result = await db.execute(Sql.named(sqlStatement));

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
    } finally {
      PostgresDB.closeConnection();
    }
  }
  
  /// Retrieves a form by its id
  @override
  Future<GenericForm?> getFormById(String formId) async {
    try {
      // TODO: implement getFormById
      // return _forms.firstWhere((form) => form.formId == formId, orElse: () => null as Form?);
      String sqlStatement = "SELECT form_title, last_modified, create_date FROM public.tbl_forms WHERE form_id LIKE @formId;";
      var db = await _connection;
      
      var result = await db.execute(Sql.named(sqlStatement), parameters: { 'formId': formId });
      if(result.isEmpty) {
        return null;
      }
      return _mapRowToForm(result.first.toColumnMap());
     } finally {
      PostgresDB.closeConnection();
    }
  }
  
  /// similar to the insert method, but avoids an additional query by returning args over existing
  @override
  Future<GenericForm> updateForm(GenericForm form) async {
    try {
      /// don't modify creation date, only the modification date
      String sqlStatement = """UPDATE public.tbl_forms
                      SET user_id = @userId, form_title = @formTitle, 
                          last_modified = current_date() 
                      WHERE form_id = @formId""";
      var db = await _connection;
      var result = await db.execute(
        Sql.named(sqlStatement), parameters: {
          'formId': null, /// TODO: adjust query and remove
          'userId': 'user-id', // For now, since you don't have auth
          'formTitle': form.formName,
          'lastModified': DateTime.now(),
          'createDate': DateTime.now()
      });
      if (result.isEmpty) {
        print(form);
        throw Exception("Failed to update the form!");
      } else {
        return _mapRowToForm(result.first.toColumnMap());
      } 
    } finally {
      PostgresDB.closeConnection();
    }
  }
}
