// ignore_for_file: dangling_library_doc_comments, avoid_print

/// Name: Vincent, Joshua
/// Date: 5/16/2024
/// Description:
/// Bugs:
/// Reflection:

/// This file is a cobbled together SQL migrated form of the original plan to have Forms stored 
/// across Google Sheets.
import 'package:athlete_surveyor/models/interfaces/i_form_respository.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:uuid/uuid.dart';
import 'package:athlete_surveyor/database.dart';

// Concrete implementation of the FormRepository
class FormRepository implements IFormRepository 
{
  FormRepository();
  
  /// Used temporarily to streamline the demo
  final String developerUuid = "a23e1679-d5e9-4d97-9902-bb338b38e468";
  
  /// 
  @override
  Future<GenericForm> createForm(GenericForm form) async 
  {
    // query 1 of 2: inserting the form into the database
    var insertResult = await Database.insertNewForm(developerUuid, // TODO: get user's ID dynamically
                                                    form.formName, 
                                                    DateTime.now().toIso8601String(), 
                                                    DateTime.now().toIso8601String());

    print("Database returned: ${insertResult.first.toColumnMap()}");

    if (insertResult.isEmpty || insertResult.first.isEmpty) { throw Exception('Failed creating form.'); }

    return _mapRowToForm(insertResult.first.toColumnMap());
  }

  /// Helper function to convert a database row to a Form object
  GenericForm _mapRowToForm(Map<String, dynamic> row) 
  {
      /// temporary debugging code: 
      assert(row['form_id'] != null, 'Database returned null for form_id');
      assert(row['form_title'] != null, 'Database returned null for form_title');

      if (row['form_id'] == null || row['form_title'] == null) {
        throw Exception('Database returned null for a required field.');
      }
        
    
    return GenericForm(
      formId: row['form_id'],
      formName: row['form_title'] ?? 'SQLERR_title_parse_fail',
      sport: row['sport'] ?? 'Unfetched', // Replace with actual value if it's available
      formDateCreated: row['create_date'] ?? DateTime.now(),
      questions: [], // This needs to be filled with actual questions from a related query
    );
  }
  
  /// Deletes a form and its questions from tbl_forms
  @override
  Future<bool> deleteForm(String formId) async 
  {
    var result = await Database.deleteFormById(formId);
    
    // Provide feedback about the operation's success/failure
    return result.affectedRows > 0 ? Future.value(true)
                                   : Future.value(false);
  }
  
  /// 
  @override
  Future<List<GenericForm>> getAllForms() async 
  {
    final result = await Database.fetchAllForms();

    return result.map((row) => _mapRowToForm(row.toColumnMap())).toList();
  }
  
  /// Retrieves a form by its id
  @override
  Future<GenericForm?> getFormById(String formId) async 
  {
    if (!Uuid.isValidUUID(fromString: formId)) 
    {
      print("[FORM_REPO] Invalid UUID: $formId");
      return null; 
    }

    var result = await Database.fetchFormById(formId);

    return result.isEmpty ? null 
                          : _mapRowToForm(result.first.toColumnMap());
  }
  
  /// Similar to the insert method, but avoids an additional query by returning args over existing
  @override
  Future<GenericForm> updateForm(GenericForm form) async 
  {
    var result = await Database.updateFormById(null,      // TODO: adjust query and remove
                                               'user-id', // For now, since you don't have auth
                                               form.formName, 
                                               DateTime.now(), 
                                               DateTime.now());

      if (result.isEmpty) 
      {
        print(form);
        throw Exception('Failed to update the form!');
      } 
      else 
      {
        return _mapRowToForm(result.first.toColumnMap());
      }
  }

}
