import 'dart:io';
import 'interfaces/IGenericForm.dart';
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
/// The nested [ResponseType] is intended be read by a service on the Form Editor page that 
/// would allow the alteration of the desired format. 
class StudentForm implements IGenericForm {

  final String formName;        // from super
  final String sport;           // from super
  
  late final DateTime? formDateReceived;
  final DateTime? formDateCompleted;
  
  /// TODO: this should be populated by the form_file_service
  List<File>? attachments = [];

  // Map<Question, List<Response>> used later in analytics, ABOVE this scope
  List<Question> questions = [];

  /// Constructs a new StudentForm
  StudentForm({
    required this.formName,
    required this.sport,
    this.formDateReceived,
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