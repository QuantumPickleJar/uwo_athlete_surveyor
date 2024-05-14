/// This file is a cobbled together SQL migrated form of the original plan to have Forms stored 
/// across Google Sheets.
import 'package:athlete_surveyor/models/interfaces/i_form_respository.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:athlete_surveyor/services/db.dart';
import 'package:uuid/uuid.dart';

// Concrete implementation of the FormRepository
class FormRepository implements IFormRepository {
  // final Connection _connection;
  Future<Connection> get _connection async => await PostgresDB.getConnection();
  // static FormRepository? _db_instance;

  FormRepository();

  /// used temporarily to streamline the demo
  /// TODO: replace with Adam In's id
  final String DEVELOPER_UUID = "a23e1679-d5e9-4d97-9902-bb338b38e468";
 
 @override
 Future<GenericForm> createForm(GenericForm form) async {
    var db = await _connection;
    try {
      print('[FormRepository] Starting transaction to insert new form.');
      return await db.runTx((tx) async {
        String sqlStatement = """
          INSERT INTO tbl_forms (user_id, form_title, last_modified, create_date)
          VALUES (@userId, @formTitle, @lastModified, @createDate) 
          RETURNING *;
        """;

        var result = await tx.execute(Sql.named(sqlStatement), parameters: {
          'userId': DEVELOPER_UUID,  // Replace with dynamic value as needed
          'formTitle': form.formName,
          'lastModified': DateTime.now().toIso8601String(),
          'createDate': DateTime.now().toIso8601String(),
        });

        if (result.isEmpty || result.first.isEmpty) {
          print('[FormRepository] No rows returned after attempting to insert form.');
          throw Exception('Failed creating form. No data returned.');
        }

        print('[FormRepository] Form created with ID: ${result.first.toColumnMap()['form_id']}');
        return _mapRowToForm(result.first.toColumnMap());
      });
    } catch (e) {
      print('[FormRepository] Exception caught during form creation: $e');
      rethrow;
    } finally {
      await db.close();
      print('[FormRepository] Database connection closed.');
    }
  }


  /// Hhelper function to convert a database row to a Form object.
  /// 
  /// Does NOT handle the resolution of questions
  GenericForm _mapRowToForm(Map<String, dynamic> row) {

    debugPrint('[FormRepository] Mapping row to GenericForm object...'); // #debug
    
    debugPrint('[FormRepository] row_id: ${row['form_id']}');
    debugPrint('[FormRepository] form_title: ${row['form_title']}');
    debugPrint('[FormRepository] sport: ${row['sport']}');
    debugPrint('[FormRepository] create_date: ${row['create_date']}');
    
    return GenericForm(
      formId: row['form_id'],
      formName: row['form_title'] ?? 'SQLERR_title_parse_fail',
      sport: row['sport'] ?? 'Unfetched', // Replace with actual value if it's available
      formDateCreated: row['create_date'],
      // formDateCreated: row['create_date'],
      questions: [], // This needs to be filled with actual questions from a related query
    );
  }
  
  /// Deletes a form and its questions from tbl_forms + tbl_questions
  @override
  Future<bool> deleteForm(String formId) async {
    try { 
      String sqlStatement = "DELETE FROM tbl_forms WHERE form_id = @formId";
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

    return result.map((row) => _mapRowToForm(row.toColumnMap())).toList();
    } finally {
      PostgresDB.closeConnection();
    }
  }
  
  /// Retrieves a form by the id of the user that authored it
  @override
  Future<List<GenericForm>> getFormsByUserId({required String userId}) async {
    try {
      // TODO: implement getFormById
      // return _forms.firstWhere((form) => form.formId == formId, orElse: () => null as Form?);
      String sqlStatement = """SELECT form_id, form_title, last_modified, create_date FROM public.tbl_forms WHERE user_id = @userId;""";
      var db = await _connection;
      var result = await db.execute(Sql.named(sqlStatement), parameters: {'userId' : userId });
      
      /// invoke [_mapRowToForm] on each row of result
      return result.map((row) => _mapRowToForm(row.toColumnMap())).toList();
     } finally {
      PostgresDB.closeConnection();
    }
  }
  

  /// Retrieves a form by its id, if it exists
  @override
  Future<GenericForm?> getFormById(String formId) async {
        if (!Uuid.isValidUUID(fromString: formId)) {
        print("[FORM_REPO] Invalid UUID: $formId");
        return null;
    }
    try {
      // TODO: implement getFormById
      // return _forms.firstWhere((form) => form.formId == formId, orElse: () => null as Form?);
      String sqlStatement = "SELECT form_title, last_modified, create_date FROM public.tbl_forms WHERE form_id = @formId;";
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
  /// TODO: revisit after implementing SQL-ized [Sport] selection
  @override
  Future<GenericForm> updateForm(GenericForm form) async {
    try {
      /// don't modify creation date, only the modification date
      String sqlStatement = """UPDATE public.tbl_forms
                      SET user_id = @userId, form_title = @formTitle, 
                          last_modified = current_date() 
                      WHERE form_id = @formId""";
      var db = await _connection;
      var result = await db.execute(Sql.named(sqlStatement), parameters: {
          'formId': form.formId, /// TODO: adjust query and remove
          'userId': DEVELOPER_UUID, 
          'formTitle': form.formName,
          'lastModified': DateTime.now().toIso8601String(),
          'createDate': DateTime.now().toIso8601String()
      });
      if (result.isEmpty || result.first.isEmpty) {
        print('[FormRepository] No rows returned after attempting to insert form with id ${form.formId}.');
          throw Exception('Failed creating form. No data returned.');
      } else {
        print('[FormRepository] Form created with ID: ${result.first.toColumnMap()['form_id']}');
        return _mapRowToForm(result.first.toColumnMap());
      } 
    } finally {
      PostgresDB.closeConnection();
    }
  }
}
