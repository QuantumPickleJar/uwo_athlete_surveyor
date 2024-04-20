import "package:athlete_surveyor/models/question.dart";

/// Concrete (but soft) implementation of IGenericForm.  
class Form {
  String formId;
  String formTitle;
  String sport;
  DateTime? formDateCreated;
  List<Question> questions;

  
  Form({
    required this.formId,
    required this.formTitle,
    required this.sport,
    this.formDateCreated,
    required this.questions,
  });
}