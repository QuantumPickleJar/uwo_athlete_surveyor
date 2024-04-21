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
  
  DateTime? formDateCreated;
  late List<Question> questions;

  GenericForm({
    required this.formId,
    required this.formName,
    required this.sport,
    this.formDateCreated,
    required this.questions,
    this.attachments
  });


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