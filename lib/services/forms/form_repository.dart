/// This file is a cobbled together SQL migrated form of the original plan to have Forms stored 
/// across Google Sheets.
import 'package:athlete_surveyor/models/interfaces/i_form_respository.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/services/sports/sports_repository.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:athlete_surveyor/services/db.dart';
import 'package:uuid/uuid.dart';

// Concrete implementation of the FormRepository
class FormRepository implements IFormRepository {
  // final Connection _connection;
  Future<Connection> get _connection async => await PostgresDB.getConnection();
  FormRepository(this._sportRepository);

  final SportsRepository _sportRepository;
  /// used temporarily to streamline the demo
  /// TODO: replace with Adam In's id
  final String DEVELOPER_UUID = "a23e1679-d5e9-4d97-9902-bb338b38e468";
 
 @override
Future<GenericForm> createForm(GenericForm form) async {
    var db = await PostgresDB.getConnection();
    try {
      debugPrint('[FormRepository] Starting transaction to insert new form.');

      return await db.runTx((tx) async {
        String formSql = """
          INSERT INTO tbl_forms (user_id, form_title, last_modified, create_date)
          VALUES (@userId, @formTitle, @lastModified, @createDate) 
          RETURNING *;
        """;

        var formResult = await tx.execute(Sql.named(formSql), parameters: {
          'userId': DEVELOPER_UUID,
          'formTitle': form.formName,
          'lastModified': DateTime.now().toIso8601String(),
          'createDate': DateTime.now().toIso8601String(),
        });

        if (formResult.isEmpty || formResult.first.isEmpty) {
          debugPrint('[FormRepository] No rows returned after attempting to insert form.');
          throw Exception('Failed creating form. No data returned.');
        }

        // var formId = formResult.first.toColumnMap()['form_id'] as String;
        var formId = formResult.first[0];

        debugPrint('[FormRepository] Checking for sport...');
        var sportId = await _sportRepository.getSportIdByName(form.sport);

        if (sportId == null) {
          debugPrint('[FormRepository] Sport not found: ${form.sport}');
          throw Exception('Sport not found: ${form.sport}');
        }

        
        debugPrint('[FormRepository] Linking $formId with $sportId');
        String junctionSql = """
          INSERT INTO tbl_form_sports (form_id, sport_id)
          VALUES (@formId, @sportId);
        """;
        await tx.execute(Sql.named(junctionSql), parameters: {
          'formId': formId,
          'sportId': sportId,
        });

        debugPrint('[FormRepository] Form created with ID: $formId');
        return _mapRowToForm(formResult.first.toColumnMap(), activity: form.sport);
      });
    } catch (e) {
      debugPrint('[FormRepository] Exception caught during form creation: $e');
      rethrow;
    } finally {
      await PostgresDB.closeConnection();
      debugPrint('[FormRepository] Database connection closed.');
    }
  }


  /// Helper function to convert a database row to a Form object.
  /// Does NOT handle the resolution of questions
  GenericForm _mapRowToForm(Map<String, dynamic> row, {String? activity}) {
  // GenericForm _mapRowToForm(Map<String, dynamic> row) {

    debugPrint('[FormRepository] Mapping row to GenericForm object...'); // #debug
    debugPrint('[FormRepository] user_id: ${row['user_id']}');
    debugPrint('[FormRepository] form_id: ${row['form_id']}');
    debugPrint('[FormRepository] form_title: ${row['form_title']}');
    debugPrint('[FormRepository] create_date: ${row['create_date']}');
    // debugPrint('[FormRepository] sport: ${row['sport']}');
    
    return GenericForm(
      formId: row['form_id'],
      formName: row['form_title'] ?? 'SQLERR_title_parse_fail',
      sport: activity ?? 'unfetched',
      formDateCreated: row['create_date'],
      questions: [], // This needs to be filled with actual questions from a related query
    );
  }
  
  /// Deletes a form and its questions from tbl_forms + tbl_questions
  @override
  Future<bool> deleteForm(String formId) async {
    var db = await PostgresDB.getConnection();
    try { 
      String sqlStatement = "DELETE FROM tbl_forms WHERE form_id = @formId";
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
        await PostgresDB.closeConnection();
    }
  }
  
  
  @override
  Future<List<GenericForm>> getAllForms() async {
    var db = await PostgresDB.getConnection();
    try {
    String sqlStatement = """SELECT 
    f.form_id, f.user_id, f.form_title, f.last_modified, f.create_date, s.activity AS sport
        FROM tbl_forms f
        LEFT JOIN tbl_form_sports fs ON f.form_id = fs.form_id
        LEFT JOIN tbl_sports s ON fs.sport_id = s.sport_id;
      """;
      
    final result = await db.execute(Sql.named(sqlStatement));

    /// invoke [_mapRowToForm] on each row of result, and then again on ['sport']
    return result.map((row) => _mapRowToForm(row.toColumnMap(),
                                             activity: row.toColumnMap()['sport'])).toList();
    } finally {
        await PostgresDB.closeConnection();
    }
  } 
  
  /// Retrieves a form by the id of the user that authored it
  @override
  Future<List<GenericForm>> getFormsByUserId({required String userId}) async {
    var db = await PostgresDB.getConnection();
    try {
      // TODO: implement getFormById
      // return _forms.firstWhere((form) => form.formId == formId, orElse: () => null as Form?);
      String sqlStatement = """SELECT  SELECT f.form_id, f.form_title, f.last_modified, f.create_date, s.activity AS sport
        FROM tbl_forms f
        LEFT JOIN tbl_form_sports fs ON f.form_id = fs.form_id
        LEFT JOIN tbl_sports s ON fs.sport_id = s.sport_id
        WHERE f.user_id = @userId;
      """;
      var result = await db.execute(Sql.named(sqlStatement), parameters: {'userId' : userId });
      
      /// extracting the query result
      return result.map((row) => _mapRowToForm(row.toColumnMap(),
                                             activity: row.toColumnMap()['sport'])).toList();     
      } finally {
         await PostgresDB.closeConnection();

    }
  }
  

  /// Retrieves a form by its id, if it exists
  @override
  Future<GenericForm?> getFormById(String formId) async {
    var db = await PostgresDB.getConnection();

    if (!Uuid.isValidUUID(fromString: formId)) {
    debugPrint("[FormRepository]: Invalid UUID: $formId");
    return null;
    }
    try {
      String sqlStatement = """
        SELECT f.form_id, f.form_title, f.last_modified, f.create_date, s.activity AS sport
        FROM tbl_forms f
        LEFT JOIN tbl_form_sports fs ON f.form_id = fs.form_id
        LEFT JOIN tbl_sports s ON fs.sport_id = s.sport_id
        WHERE f.form_id = @formId;
      """;
      var result = await db.execute(Sql.named(sqlStatement), parameters: { 'formId': formId });
      
      if(result.isEmpty) {
        return null;
      }
      /// we don't need to map out the sport this time, just the [GenericForm] itself
      return _mapRowToForm(result.first.toColumnMap(),
                           activity: result.first.toColumnMap()['sport']);
     } finally {
         await PostgresDB.closeConnection();

    }
  }
  
  /// similar to the insert method, but avoids an additional query by returning args over existing
  /// TODO: revisit after implementing SQL-ized [Sport] selection
  @override
  Future<GenericForm> updateForm(GenericForm form) async {
    var db = await PostgresDB.getConnection();
    try {
      /// don't modify creation date, only the modification date
      String sqlStatement = """UPDATE public.tbl_forms
                      SET user_id = @userId, form_title = @formTitle, 
                          last_modified = current_date() 
                      WHERE form_id = @formId""";
      var result = await db.execute(Sql.named(sqlStatement), parameters: {
          'formId': form.formId, /// TODO: adjust query and remove
          'userId': DEVELOPER_UUID, 
          'formTitle': form.formName,
          'lastModified': DateTime.now().toIso8601String(),
          // 'createDate': DateTime.now().toIso8601String()
      });
      if (result.isEmpty || result.first.isEmpty) {
        debugPrint('[FormRepository] No rows returned after attempting to update form (formId = ${form.formId}).');
          throw Exception('Failed creating form. No data returned.');
      } else {
        debugPrint('[FormRepository] Form created with ID: ${result.first.toColumnMap()['form_id']}');
        return _mapRowToForm(result.first.toColumnMap());
      } 
    } finally {
      await PostgresDB.closeConnection();
    }
  }
 
}
