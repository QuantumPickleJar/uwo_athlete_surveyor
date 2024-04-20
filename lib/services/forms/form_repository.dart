/// This file is a cobbled together SQL migrated form of the original plan to have Forms stored 
/// across Google Sheets.
import 'package:athlete_surveyor/models/interfaces/i_form_respository.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:postgres/postgres.dart';
import 'package:athlete_surveyor/services/db.dart';

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

    /// TODO: run the question query separately, in a tx
    ///  until we have a service for it
    // var result = await _connection.runTx((insertForm) {
    //   final persistedForm = await insertForm.execute()
    // });

   var result = await _connection.execute(
      sqlStatement, parameters: {
        'userId': 'user-id', // For now, since you don't have auth
        'formTitle': form.formName,
        'lastModified': DateTime.now(),
        'createDate': DateTime.now(), 
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
    /// provide feedback about the operation's success/failure
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
  
  /// similar to the insert method, but avoids an additional query by returning args over existing
  @override
  Future<Form> updateForm(Form form) async {
    // TODO: implement updateForm
    /// don't modify creation date, only the modification date
    String sqlStatement = """UPDATE public.tbl_forms
                    SET user_id=?, form_title='', last_modified=current_date()
                    WHERE form_id=gen_random_uuid();""";
       var result = await _connection.execute(
        sqlStatement, parameters: {
          'userId': 'user-id', // For now, since you don't have auth
          'formTitle': form.formName,
          'lastModified': DateTime.now(),
          'createDate': DateTime.now()
      }
    );
    if (result.isEmpty) {
      print(form);
      throw Exception("Failed to update the form!");
    } else {
      return _mapRowToForm(result.first.toColumnMap());
    }
  }
}
