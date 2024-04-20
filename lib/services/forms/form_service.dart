import 'package:athlete_surveyor/models/form_factory.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/interfaces/i_generic_form.dart';
import 'package:athlete_surveyor/models/forms/student_form.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:uuid/uuid.dart';
import 'form_repository.dart';

class FormService {
  final FormRepository _formRepository;
  final FormFactory _formFactory = ConcreteFormFactory();
  
  final Uuid _uuid = const Uuid(); // finding out if we need this at the moment

  /// TODO: make more specific get-based functions that query smaller 
  /// subsets, such as ones suited for students vs staff for example
  FormService(this._formRepository, _formFactory);
    // _init(spreadsheetId);
    // return _formRepository.getAllForms();
  

  Future<Form> createNewForm(String formName, String sport) async {
    
    /// TODO: ensure another form with this name doesn't exist
    IGenericForm newForm = _formFactory.createStudentForm(formName: formName);
    // var newForm = _formFacotForm(
    //   formId: _uuid.v4(), 
    //   formName: newForm.formName, 
    //   sport: newForm.sport, 
    //   questions: newForm.questions
    // );

    await _formRepository.createForm(newForm as Form);
    return newForm;
  }

  Future<Form?> getFormDetails(String formId) async {
    /// TODO: wrap with safe uuid parse
    return _formRepository.getFormById(formId);
  }

  /// if we *DO* need this, it'd probably be used post-construction
  // Future<void> _init() async {
  // }

  Future<void> writeQuestion(Question question, String formUuid) async {
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
    // if()
  }

  /// using the supplied [formUuid] as an indexing key of sorts, queries the spreadsheet
  /// accordingly so that the content can be loaded for a **specific student**
  StudentForm? loadForm(String formUuid) {
    // TODO: implement loadForm
    /// List<Question>? questions = (get from query);
    
    /// based on questions, load into a [StudentForm]
  }

  // Example helper methods (to be implemented)
  Map<String, dynamic>? _fetchFormData(String formUuid) {
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