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
  void loadForm(Uuid formId) {
    // TODO: Implement loadForm
  }

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