import 'package:athlete_surveyor/models/form_factory.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/forms/staff_form.dart';
import 'package:athlete_surveyor/models/interfaces/i_generic_form.dart';
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
  
  Future<Form?> getFormById(String formUuid) async{
    try {
      var retrievedForm = await _formRepository.getFormById(formUuid);
      
      if (retrievedForm != null) {
        /// TODO: implemement during auth stage
        /// based on questions, load into a [StudentForm] or [StaffForm]
        return retrievedForm;
      }
    } on Exception catch (e) {
      print("Error getting Form with id $formUuid: \n Error: $e");
    }
    return null;
  }

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

  /// TODO: implement
  Future<Form?> getFormDetails(String formId) async {
    /// TODO: wrap with safe uuid parse
    return _formRepository.getFormById(formId);
  }

  /// Called when updates to the form's responses have been made 
  Future<Form> saveForm(Form form) async {
    if (form.formId.isEmpty) {  /// do we need to create it?
      return await _formRepository.createForm(form);
    } else {
      return await _formRepository.updateForm(form);
    }
  }

  /// TEMPORARY FUNCTION FOR MILESTONE
  /// Called by FormBuilderPage when loading a form.  If an id isn't supplied, we know it's 
  /// a new form and can simply construct and return a [StaffForm] with the populated ID from 
  /// the DB.
  Future<IGenericForm> fetchOrCreateForm(String formId, String formName, String sport) async {
    /// route to [_formFactory] if [formId] is null
    if(formId.isEmpty) {
     return _formFactory.createStaffForm(formName: formName, sport: sport);
      /// now we'll grab the form's newly assigned id
      // var persistedForm = await createFormWithQuestions(newForm as Form, []) ;
      // // verify the conversion was successful
      // print("dates: ${newForm.formDateCreated.toString()} and ${persistedForm.formDateCreated.toString()}");
      
      // newForm.formId = persistedForm.formId;  /// ...and update [newForm] to match
      // return newForm;
    } else {  /// fetch the Form
      var existingForm = await _formRepository.getFormById(formId);
      /// TODO: examine necessity of this if statement
      if (existingForm != null) {
        return existingForm; /// cast because [IGenericForm] expected
      } else {
        throw Exception('Unable to find the form, or not the right form type!');
      }
    }
  } 

}