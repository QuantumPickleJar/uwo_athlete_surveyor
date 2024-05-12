import 'package:athlete_surveyor/data_objects/previous_form.dart';
import 'package:athlete_surveyor/database.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/services/db.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:flutter/material.dart';


/// Model to represent a user's forms.  
/// 
/// For Staff members, this is used to
/// display their previously created forms.
/// 
/// For Students, this is used in conjuction with a black box to 
/// log student responses 
class AuthoredFormsModel extends ChangeNotifier {
  final List<GenericForm> formsList = [];
  FormService _formService; 

  AuthoredFormsModel(this._formService);

  /// Get all inbox messages from the database and insert into internal list.
  Future<void> getPreviousFormsFromDatabase({required String userId}) async 
  {
    print("[AuthoredFormsModel] Fetching $userId's forms...");
    var authoredForms = await _formService.getFormsByUserId(userId: userId);
    
    formsList.clear();
    formsList.addAll(authoredForms);

    notifyListeners();
  }

  void updateFormService(FormService newContext) {
    _formService = newContext;
  }

  /// Creates a new form with the given [description] and [title].
  /// Returns a [Future] that completes with a [GenericForm] object.
  Future<GenericForm> createNewForm(String description, String title) async {
    var newForm = await _formService.createNewForm(title, description);
    return newForm;
  }
}