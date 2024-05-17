// ignore_for_file: override_on_non_overriding_member

import "dart:io";
import "package:athlete_surveyor/models/interfaces/i_generic_form.dart";
import "package:athlete_surveyor/models/question.dart";
import "package:flutter/material.dart";
import "package:uuid/uuid.dart";

/// Concrete (but soft) implementation of IGenericForm.  
/// Abstract base class that we use for keeping in line with DRY + Liskov's Substitution
class GenericForm extends ChangeNotifier implements IGenericForm {
  @override final String formId;
  @override final String formName;
  @override final String sport;
  @override final List<File>? attachments;
  /// assert that forms will have a date
  @override DateTime formDateCreated;
  @override late List<Question> questions;
  
  GenericForm({
    this.formId = '',       /// default to having no id for easier traces
    required this.formName,
    required this.sport,
    this.attachments,
    DateTime? formDateCreated,
    required this.questions,
  }) : /// set the date if it came in null for some reason
     formDateCreated = formDateCreated ?? DateTime.now();




  /// To be used in saving drafts, if at all.  May need to be 
  /// removed to respect SOLID principles.
  @override
  void saveForm() {
    /// TODO: Implement saveForm
    notifyListeners();
  }
  
  @override
  set attachments(List<File>? _attachments) {
    /// TODO: implement attachments
  }
  
}