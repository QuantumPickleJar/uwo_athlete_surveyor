import 'dart:io';
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
class StaffForm implements IGenericForm {

  @override final String formId;            // from super
  @override final String formName;        // from super
  @override final String sport;           // from super

  /// TODO: this should be populated by the form_file_service, if not form_service
  @override List<File>? attachments = [];
  
  final DateTime? formDateCompleted;

  // Map<Question, List<Response>> used later in analytics, ABOVE this scope
  List<Question> questions = [];

  /// Constructs a new StudentForm
  StaffForm({
    required this.formId,
    required this.formName,
    required this.sport,
    this.formDateCompleted,
  });
  
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
}