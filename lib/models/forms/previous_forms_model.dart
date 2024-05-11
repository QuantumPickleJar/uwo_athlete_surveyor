import 'package:athlete_surveyor/data_objects/previous_form.dart';
import 'package:athlete_surveyor/database.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/services/db.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:flutter/material.dart';

// Temporary model; subject to change.
class AuthoredFormsModel extends ChangeNotifier {
  final List<GenericForm> formsList = [];
  late final FormService _formService; 

  /// Get all inbox messages from the database and insert into internal list.
  Future<void> getPreviousFormsFromDatabase({required String userId}) async 
  {
    print("[AuthoredFormsModel] Fetching $userId's forms...");
    var authoredForms = await _formService.getFormsByUserId(userId: userId);
    
    formsList.clear();
    formsList.addAll(authoredForms);

    notifyListeners();
  }
}