import 'dart:io';
import 'package:flutter/material.dart';

import '../interfaces/i_generic_form.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:uuid/uuid.dart';

/// A concrete implementation of [IGenericForm], tailored for what students will see.
/// This includes the loading of a form to *take* a survey, as well as the ability to 
/// use the data to render thumbnails (possibly)
/// 
/// Key differences from the [StaffForm] include:
/// Rather than performing sequential *UPDATES* to a form (even if they are spaced out/ use
/// a separate sheet for drafting) to reflect modifications,  the form's content is fetched 
/// and cached to the device as a draft FormResult so that the student can return to finish 
/// questions later. 
/// 
/// The nested [ResponseType] is intended be read by a service on the Form Editor page that 
/// would allow the alteration of the desired format. 
class StaffForm extends ChangeNotifier implements IGenericForm {

  @override String formId;            // from super
  @override String formName;        // from super
  @override String sport;           // from super

  /// TODO: this should be populated by the form_file_service, if not form_service
  @override List<File>? attachments;
  
  DateTime? formDateCreated;

  // Map<Question, List<Response>> used later in analytics, ABOVE this scope
  List<Question> questions;

  /// Constructs a new StaffForm, loaded with [questions]
  StaffForm({
    required this.formId,
    required this.formName,
    required this.sport,
    this.formDateCreated,
    required this.questions
  });
  
  /// Constructs a new StaffForm from an existing [IGenericForm].
  /// Intended to be used when creating new forms, NOT on existing
  StaffForm.fromGenericForm(IGenericForm genericForm): 
      formId = genericForm.formId,
      formName = genericForm.formName,
      sport = genericForm.sport,
      attachments = genericForm.attachments,
      formDateCreated = null,
      questions = [];
  
    /// Called when updates to the form's responses have been made 
  @override 
  void saveForm() {
    // Save logic for the form, including saving drafts to local cache + remote storage
  }

  /// Loads the form content and any existing drafts for the questions
  @override
  void loadForm(Uuid formUuid) {
    // Load form data from a remote source or local cache
    // This would populate the questions list with existing data, including drafts
  }

  void updateFormTitle(String newTitle) {
    formName = newTitle;
    notifyListeners();
  }

  void addQuestion(Question question) {
    questions.add(question);
    notifyListeners();
  }

  void removeQuestion(Question question) {
    questions.remove(question);
    notifyListeners();
  }
}