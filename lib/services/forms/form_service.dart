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
  
  /// TODO: make more specific get-based functions that query smaller 
  /// subsets, such as ones suited for students vs staff for example
  FormService(this._formRepository, this._questionRepository);
    // _init(spreadsheetId);
    // return _formRepository.getAllForms();
  
  Future<GenericForm?> getFormById(String formId) async{
    try {
      var retrievedForm = await _formRepository.getFormById(formId);
      
      if (retrievedForm != null) {
        /// TODO: check if there are any questions to be retrieved:
        /// for now this if from tbl_questions, but will eventually be from tbl_form_question
        retrievedForm.questions = await _questionRepository.resolveQuestionsByFormId(formId: formId);
        return retrievedForm;
      }
    } on Exception catch (e) {
      print('Error getting Form with id $formId: \n Error: $e');
    }
    return null;
  }

  /// Creates a new form in the database, returning an instance containing
  /// the id assigned from the SQL server.
  Future<GenericForm> createNewForm(String formName, String sport) async {
    /// TODO: ensure another form with this name doesn't exist
    IGenericForm newForm = _formFactory.createStaffForm(formName: formName, sport: sport);

    /// [IGenericForm] can't store a formId, so we must inject the newly spawned one:
    GenericForm persistedForm = await _formRepository.createForm(newForm as GenericForm);
    return persistedForm;
  }


  /// Checks if [existingForm]'s questions contain all that [questions] does by 
  /// leveraging the fact that a [Question] knows its order in a form: allowing 
  /// the conversion of the List to a Set
  bool _areFormQuestionsEqual(GenericForm existingForm, List<Question> questions) {
    var setA = existingForm.questions.toSet();
    var setB = questions.toSet();

    return setA.containsAll(setB) && setB.containsAll(setA);
  }

  /// When 
  // Future<GenericForm> createFormWithQuestions(GenericForm form, List<Question> questions) async {
  Future<void> saveFormQuestions({required GenericForm existingForm, 
                                         required List<Question> newQuestions}) async {
    try {
      // GenericForm newForm = await _formRepository.createForm(form);    // form needs the id from DB first
        
      /// make sure all of [newQuestions] is present in [existingForm] before making req. to DB
      if (!_areFormQuestionsEqual(existingForm, newQuestions)) { /// add them if not 
        /// note that existing questions should contain formId from Widget Tree (in form_builder_page) 
        await _questionRepository.updateFormQuestions(questions: newQuestions, formId: existingForm.formId);    
      }
    } catch (e) {
      throw Exception('Form ID was null on the attempted operation.');
    }
  }

  // /// TODO: implement
  // Future<GenericForm?> getFormDetails(String formId) async {
  //   /// TODO: wrap with safe uuid parse
  //   return _formRepository.getFormById(formId);
  // }

  /// Called when updates to the form's responses have been made 
  Future<GenericForm> saveForm(GenericForm form) async {
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
  Future<IGenericForm> fetchOrCreateForm({required String formId, String? formName, String? sport}) async {
    /// route to [_formFactory] if [formId] is null
    if(formId.isEmpty) {
      /// TODO: if this throws null ptr, init params to "Untitled Foo" etc
      StaffForm? newForm = _formFactory.createStaffForm(
        formName: (formName != null && formName.isNotEmpty) ? formName : 'New Form',
        sport: (sport != null && sport.isNotEmpty) ? sport : 'untitled sport') as StaffForm?;


      /// now we'll grab the form's newly assigned id, and its questions
      var persistedForm = await createNewForm(formName ?? 'New Form (f_svc)', sport ?? 'New Sport (f_svc)');
      List<Question> formQuestions = await _questionRepository.resolveQuestionsByFormId(formId: formId);
      
      // newForm.formId = persistedForm.formId;  /// ...and update [newForm] to match
      // verify the conversion was successful
      print("dates: ${newForm?.formDateCreated.toString()} and ${persistedForm.formDateCreated.toString()}");
      
      return persistedForm;

    } else {  /// fetch the Form
      var existingForm = await getFormById(formId);
      
        /// TODO: adjust to have questions resolved through [_questionRepository]
      if (existingForm != null) {
        /// if the questions should be a parameter of the [FormFactory]:
        /// return _formFactory.createStaffForm(formName: formName, sport: sport)       
      
        return StaffForm(existingForm.questions, 
          formId: formId,
          formName: (formName != null && formName.isNotEmpty) ? formName : 'Untitled form (f_svc)',
          sport: (sport != null && sport.isNotEmpty) ? sport : 'untitled sport (f_svc)',
          attachments: [],
          formDateCreated: DateTime.now()
        ); /// cast because [IGenericForm] expected
      } else {
        /// temporary for milestone demo: the "or create" part.  In really bad spot...
        /// ad-hoc; make a new one on the fly
        StaffForm newForm = StaffForm([], /// empty list of questions
          formId: formId,
          formName: (formName != null && formName.isNotEmpty) ? formName : 'New Form (f_svc)',
          sport: (sport != null && sport.isNotEmpty) ? sport : 'untitled sport (f_svc)',
          attachments: [],
          formDateCreated: DateTime.parse(DateTime.now().toIso8601String())); 
        return newForm;
       /// throw Exception('Unable to find the form, or not the right form type!');
      }
    }
  } 

}