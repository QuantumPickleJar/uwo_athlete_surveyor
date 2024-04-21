import 'dart:io';
import 'package:athlete_surveyor/models/interfaces/i_generic_form.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
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
class StaffForm extends GenericForm {

  final DateTime? formDateCreated;

  // Map<Question, List<Response>> used later in analytics, ABOVE this scope
  final List<Question> questions;

  /// Constructs a new StaffForm, loaded with [questions]
  // ignore: use_super_parameters
  StaffForm(this.questions, {
    required formId,
    required formName,
    required sport,
    super.attachments,
    this.formDateCreated
  }) : super(
        formId: formId,
        formName: formName,
        sport: sport,
        formDateCreated: formDateCreated,
        questions: [],
      );

  /// Constructs a new StaffForm from an existing [IGenericForm].
  /// Intended to be used when creating new forms, NOT on existing
  StaffForm.fromGenericForm(IGenericForm genericForm, this.formDateCreated, this.questions):
  super( 
      formId : genericForm.formId,
      formName : genericForm.formName,
      sport: genericForm.sport,
      questions: [],
      attachments: genericForm.attachments,
      formDateCreated: formDateCreated
      );

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

  // void updateFormTitle(String newTitle) {
  //   super() = newTitle;
  //   notifyListeners();
  // }

  void addQuestion(Question question) {
    questions.add(question);
    notifyListeners();
  }

  void removeQuestion(Question question) {
    questions.remove(question);
    notifyListeners();
  }
  
  @override
  set attachments(List<File>? attachments) {}
}