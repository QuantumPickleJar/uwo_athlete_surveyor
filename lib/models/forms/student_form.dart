import 'dart:io';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/interfaces/i_generic_form.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:uuid/uuid.dart';


/// A concrete implementation of [IGenericForm], tailored for what students will see.
/// This includes the loading of a form to *take* a survey, as well as the ability to 
/// use the data to render thumbnails (possibly)
/// 
/// Key differences from the [StaffForm] include:
/// Rather than performing sequential *UPDATES* to a form (even if they are spaced out/ use
/// a separate sheet for drafting) to reflect modifications, the form's content is fetched 
/// and cached to the device as a draft FormResult so that the student can return to finish 
/// questions later. 
/// 
/// The nested [ResponseType] is intended be read by something on the UI layer to provide
/// a widget based on the question being viewed.
class StudentForm extends GenericForm {
  
  late final DateTime? formDateReceived;
  // late final DateTime? formDateCompleted;
  
  /// TODO: this should be populated by the form's Attachments
  // @override
  // List<File>? attachments;
  // List<Question> questions = [];

  /// Constructs a new StudentForm
  StudentForm({
    required formId,
    required formName,
    required sport,
    this.formDateReceived,
    // this.formDateCompleted,
    super.attachments, 
    required super.questions
  }) : super(formId: formId, formName: formName, sport: sport);
  
    /// Called when updates to the form's responses have been made 
  @override 
  void saveForm() {
    // Save logic for the form, including saving drafts to local cache + remote storage
    notifyListeners();
  }

  /// Constructs a new [StudentForm] from an existing [IGenericForm].
  /// When used with a concrete [GenericForm], the [questions] field will try to 
  /// bind if it's not null, as will the [formId] field.
  StudentForm.fromGenericForm(IGenericForm genericForm, {List<Question>? questions, String? suppliedFormId}) : super(
    formId: suppliedFormId ?? genericForm.formId,
    formName: genericForm.formName,
    sport: genericForm.sport,
    attachments: genericForm.attachments,
    formDateCreated: (genericForm is GenericForm) ? genericForm.formDateCreated : DateTime.now(),
    questions: questions ?? genericForm.questions,
  ) { 
    print("[StudentForm] building from GenericForm with formId: $formId"); 
    }
  // /// Loads the form content and any existing drafts for the questions
  // @override
  // void loadForm(Uuid formUuid) {
  //   // Load form data from a remote source or local cache
  //   // This would populate the questions list with existing data, including drafts
  //   notifyListeners();
  // }

}