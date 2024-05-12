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

  /// Retrieves forms by the 
  Future<List<GenericForm>> getFormsByUserId({required String userId}) async {
    try {
      print("Fetching forms for $userId");
      var createdForms = await _formRepository.getFormsByUserId(userId: userId);
      if (createdForms != null) {
        return createdForms;
      }
      /// throw an arg-error if it's null
      throw ArgumentError.notNull('userId');
    } on Exception catch (e) {
      print("Error fetching forms for user with id $userId");
      throw UnimplementedError();
    }
  }
  
  Future<GenericForm?> getFormById(String formId) async{
    if (Uuid.isValidUUID(fromString: formId)) {
      try {
        var retrievedForm = await _formRepository.getFormById(formId);
        
        if (retrievedForm != null) {
          /// TODO: check if there are any questions to be retrieved:
          /// for now this if from tbl_questions, but will eventually be from tbl_form_question
          retrievedForm.questions = await _questionRepository.resolveQuestionsByFormId(formId: formId);
          return retrievedForm;
        } 
        
      } catch (e) {
        print('Error getting Form with id $formId: \n Error: $e');
      }
    } else {
        print('Invalid or missing formId: $formId');
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

  /// When [EditQuestionWidget] calls its onSave, it needs to add a single question to a form.
  /// This function checks that the desired question isn't already in the form.
  /// 
  /// While this could be optimized to query by the form's id, we'd need to have a list of questions by
  /// form_id readily available. Thus, we stick to passing a concrete [GenericForm]
  Future<void> saveQuestionOnForm({required Question newQuestion, required GenericForm existingForm}) {
    // make sure the question doesn't already exist on [existingForm]
    if (existingForm.questions.any((question) => question.content == newQuestion.content)) {
      return Future.error('Question already present when trying to add!');
    }
    
    // Check if ordinal is set, otherwise assign a default value
    if (newQuestion.ordinal == null) {
      // Calculate the next ordinal value based on existing questions
      int maxOrdinal = existingForm.questions.fold(0, (max, question) => 
        question.ordinal! > max ? question.ordinal! : max);
      newQuestion.ordinal = maxOrdinal + 1;
    }
    existingForm.questions.add(newQuestion);
    return Future.value('All good!');
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

  /// Called by FormBuilderPage when loading a form.  
  /// If an id isn't supplied, we know it's a new form and can simply construct and 
  /// return a [StaffForm] with the populated ID from the DB.
  Future<GenericForm> fetchOrCreateForm({String? formId, String? formName, String? sport}) async {
    /// route to [_formFactory] if [formId] is null
    if(formId == null || formId.isEmpty) {
      // Ensure newForm is a GenericForm and initialize its ID with the new ID from the DB.
      IGenericForm newForm = _formFactory.createStaffForm(
        formName:  formName ?? 'New Form', sport: sport ?? 'untitled sport');

      /// now we'll grab the form's newly assigned id, and its questions
      GenericForm persistedForm = await _formRepository.createForm(newForm as GenericForm);

      return persistedForm;
    } else {                    /// fetch an existing Form
      var existingForm = await getFormById(formId);
      
      if (existingForm != null) {
        existingForm.questions = await _questionRepository.resolveQuestionsByFormId(formId: formId);
        return existingForm;
      } else {
      throw Exception('Unable to find the form with id $formId');
      }
    }
  } 
}