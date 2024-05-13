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

  /// updates the service instance whenever we need to
  void updateFormService(FormService newContext) {
    _formService = newContext;
  }

  /// Creates a new form with the given [title] and [sport].
  /// Returns a [Future] that completes with a [GenericForm] object.
  Future<GenericForm> createNewForm(String title, String sport) async {
    print("[authored-forms-model]: asking formService to create a new form with:");
    print("[authored-forms-model]: Title: $title\nSport : $sport");
    
    var newForm = await _formService.createNewForm(formName: title, sport: sport);
    return newForm;
  }
}