import "dart:io";

import "package:athlete_surveyor/models/interfaces/i_generic_form.dart";
import "package:athlete_surveyor/models/question.dart";
import "package:uuid/uuid.dart";

/// Concrete (but soft) implementation of IGenericForm.  
class Form implements IGenericForm {
  @override String formId;
  @override String formName;
  @override String sport;
  @override List<File>? attachments;
  
  @override
  void loadForm(String formId) {
    // TODO: determine if this should be in a different file
  }

  /// To be used in saving drafts, if at all.  May need to be 
  /// removed to respect SOLID principles.
  @override
  void saveForm() {
    // TODO: Implement saveForm
  }

  DateTime? formDateCreated;
  List<Question> questions;

  Form({
    required this.formId,
    required this.formName,
    required this.sport,
    this.formDateCreated,
    required this.questions,
  });

}