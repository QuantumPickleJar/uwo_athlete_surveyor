import 'package:athlete_surveyor/models/form_factory.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/interfaces/i_generic_form.dart';
import 'package:athlete_surveyor/models/forms/student_form.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/services/questions/question_repository.dart';
import 'package:uuid/uuid.dart';
import 'form_repository.dart';

class FormService {
  final FormRepository _formRepository;
  final QuestionRepository _questionRepository;
  final FormFactory _formFactory = ConcreteFormFactory();
  
  final Uuid _uuid = const Uuid(); // finding out if we need this at the moment

  /// TODO: make more specific get-based functions that query smaller 
  FormService(this._formRepository, this._questionRepository);
  /// subsets, such as ones suited for students vs staff for example
    // _init(spreadsheetId);
    // return _formRepository.getAllForms();
  

  Future<Form> createNewForm(String formName, String sport) async {
    /// TODO: ensure another form with this name doesn't exist
    IGenericForm newForm = _formFactory.createStudentForm(formName: formName);

    await _formRepository.createForm(newForm as Form);
    return newForm;
  }

  Future<Form> createFormWithQuestions(Form form, List<Question> questions) async {
    Form newForm = await _formRepository.createForm(form);    // form needs the id from DB first
    for (var question in questions) {
      question.formId = newForm.formId;   // bind the question to the form it's adding into
      // newForm.questions.add(question);
      await _questionRepository.createQuestion(question, form.formId);    // now add this ref to tbl_questions
    }
    return newForm;
  }

  /// TODO: imp
  Future<Form?> getFormDetails(String formId) async {
    /// TODO: wrap with safe uuid parse
    return _formRepository.getFormById(formId);
  }

  /// Called when updates to the form's responses have been made 
  @override 
  Future<Form> saveForm(Form form) async {
    if (form.formId.isEmpty) {  /// do we need to create it?
      return await _formRepository.createForm(form);
    } else {
      return await _formRepository.updateForm(form);
    }
   
  }

  // /// using the supplied [formUuid] as an indexing key of sorts, queries the spreadsheet
  // /// accordingly so that the content can be loaded for a **specific student**
  // StudentForm? loadForm(String formUuid) {

  //   /// List<Question>? questions = (get from query);
    
  //   /// based on questions, load into a [StudentForm]
  // }

  // /// handles the saving of a draft, called when either:
  // /// - a form's content is modified in any way (staff only)
  // /// - a question's response has been marked complete/hits next
  // /// - a question's unfinished response has been modified, update draft
  // void _saveFormData(StudentForm form) {
  //   // Implementation to save form data
  // }

}