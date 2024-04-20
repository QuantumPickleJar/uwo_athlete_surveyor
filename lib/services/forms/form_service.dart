import 'package:athlete_surveyor/models/student_form.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:uuid/uuid.dart';

class FormService {
  final FormRepository _formRepository;

  /// Gets ALL forms
  /// TODO: make more specific get-based functions that query smaller 
  /// subsets, such as ones suited for students vs staff for example
  FormService(this._formRepository) {
    // _init(spreadsheetId);
    return _formRepository.getAllForms();
  }
/* 
  Future<Form> createNewForm(Form form) {

  }

  Future<Form?> getFormDetails(Uuid formId) async {

    return _formRepository.getFormById(formId);
  }

  /// if we *DO* need this, it'd probably be used post-construction
  // Future<void> _init() async {
  // }
*/


  Future<void> writeQuestion(Question question, Uuid formUuid) async {
      /// Ex:
   ///   await formSheet.values.appendRow([
   ///   formUuid,
   ///   question.ordinal.toString(),
   ///   question.header,
   ///   question.content,
   ///   question.res_required.toString(),
   ///   question.resFormat.widgetType.toString(),
   ///   question.linkedFile?.path ?? ''
   /// ]);
  }

  /// Called when updates to the form's responses have been made 
  @override 
  void saveForm() {
    if()
  }

  /// using the supplied [formUuid] as an indexing key of sorts, queries the spreadsheet
  /// accordingly so that the content can be loaded for a **specific student**
  StudentForm? loadForm(Uuid formUuid) {
    // TODO: implement loadForm
    /// List<Question>? questions = (get from query);
    
    /// based on questions, load into a [StudentForm]
  }

  // Example helper methods (to be implemented)
  Map<String, dynamic>? _fetchFormData(Uuid formUuid) {
    // Implementation to fetch form data
  }

  /// handles the saving of a draft, called when either:
  /// - a form's content is modified in any way (staff only)
  /// - a question's response has been marked complete/hits next
  /// - a question's unfinished response has been modified, update draft
  void _saveFormData(StudentForm form) {
    // Implementation to save form data
  }

}