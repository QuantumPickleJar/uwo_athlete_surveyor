import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/forms/staff_form.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:athlete_surveyor/widgets/dialogs/edit_question_dialog.dart';
import 'package:athlete_surveyor/widgets/questions/question_item.dart';
import  'package:athlete_surveyor/models/response_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

/// Page responsible for creating and modifying forms. 
/// 
/// Per the object family defined, the presented form is built from
/// a [GenericForm] holding (existing, if any) data, which is then 
class FormBuilderPage extends StatefulWidget {
  final String? formId;  // id linking page to the form
 
  const FormBuilderPage({Key? key, required this.formId}) : super(key: key);

  @override
  _FormBuilderPageState createState() => _FormBuilderPageState();
}


class _FormBuilderPageState extends State<FormBuilderPage> {
  GenericForm? _currentForm;        /// the form currently opened
  late Future<GenericForm?> _formFuture;        /// the form currently opened
  late double _sliderValue;
  late bool _isCurrentFormNew;  
  bool _isFormDirty = false;  // Track if the form is modified
  
  /// Allows modifying a *single* [QuestionItem] at a time.  This *should*
  /// allow the transition to an expanded-style question widget as 
  /// opposed to the existing [AlertDialog]-based solution
  late final TextEditingController _questionTextController;
  
  /// looks at formName to determine if the name is still untouched\
  /// e.g if (formName.contains("New Form")){ ... }
  late final FormService _formService;

  /// the form currently being modified

 void _markFormAsDirty() {
    setState(() {
      _isFormDirty = true;
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.formId);  // Ensure this prints the expected UUID
    _formService = Provider.of<FormService>(context, listen: false);
    _questionTextController = TextEditingController();
    /// if this is a **NEW** form, it'll (briefly) have a null `form_id`
    _isCurrentFormNew = widget.formId == null || widget.formId!.isEmpty;
    _formFuture = _loadForm();
    // _formFuture ??= _loadForm();
  }

  /// needed for using the [TextEditingController]
  @override dispose() {
    _questionTextController.dispose();
    super.dispose();
  }

  /// reaches out and fetches form contents from the resolved [formId]
  Future<GenericForm?> _loadForm() async {
      if (widget.formId != null && widget.formId!.isNotEmpty) {
      try {
        print("Loading form data for formId: ${widget.formId}");
       GenericForm? loadedForm = await _formService.fetchOrCreateForm(formId: widget.formId);
        setState(() {
          _currentForm = loadedForm; // Update the state with loaded form
        });
        return loadedForm;
      } catch (e) { 
        /// an exception will occur if not found
        print('Error loading form: $e');
        /// check if we need to make an additional call to the DB (should happen behind)
        /// _isOpenedFormNew = widget.formId!.isEmpty;
        return null;
        }
      }
    }
    
  /// Builds the scaffold for displaying a StaffForm's [questions] .
  ///
  /// Takes a [StaffForm] object and returns a [Scaffold]  widget that
  /// displays the questions in a [ListView.builder].
  ///
  /// Each question is displayed as a [QuestionItem] with the question
  /// header as the title and the question content as the subtitle.
  Widget buildQuestions(List<Question>? questions) {
    return ListView.builder(
      itemCount: questions?.length ?? 0,
      itemBuilder: (context, index) {
        Question? question = questions?[index]; 
      print('Loaded question ${question?.questionId} on form ${_currentForm?.formId}');

      /// this is where we unpack the contents of the question.
      /// TODO: the button to modify a question should be inside the Card
      return QuestionItem( 
      onDelete: (Question qst) => _deleteQuestion(qst),
      onUpdate: (Question qst) => _editQuestion(qst),
      question: question ?? Question(
        content: 'Error question',
        formId: _currentForm!.formId,
        header: 'Failure',
        ordinal: _currentForm!.questions.length + 1,
        questionId: const Uuid().v4(),
        resFormat: ResponseType.getDefaultWidgetType(),
        resRequired: false
        ),
        // title: Text(question?.header ?? 'New Question'),
        // subtitle: Text(question?.content ?? 'no content provided'),
    );
   });
  }

  /// used to add a new EMPTY question at the tail end of [_currentForm]'s questions
  void _addNewQuestion() {
    print('[UI] Add Question Requested: ${_currentForm!.questions.length.toString()}');
    setState(() {
    Question newQuestion = Question(
      formId: _currentForm!.formId, 
      questionId: const Uuid().v4(),
      /// a new form starts with an ordinal of 1, otherwise it's size of [questions]
      ordinal: (_isCurrentFormNew) ? 1 : _currentForm!.questions.length + 1,   
      header:"Question ${_currentForm!.questions.length + 1}:",
      content: 'Enter contextual information for the student to respond to.',
      resRequired: false, /// TODO: implement a localized persistant setting allowing the desired init value
      resFormat: ResponseType.getDefaultWidgetType());

    _currentForm?.questions.add(newQuestion);
    });
  }

  
  void _editQuestion(Question question) async {    
    final Question? modifiedQuestion = await showDialog<Question>(
      context: context, 
      builder: (BuildContext context) {
        return EditQuestionDialog(question: question, 
          onCancel:  () { 
            /// on cancel, just pop [EditQuestionWidget] off the stack, being an [AlertDialogue]
            Navigator.of(context).pop();
          },
          onSave: (updatedQuestion) async { 
              /// send the question back through the Navigation stack
              Navigator.of(context).pop(updatedQuestion);
              debugPrint('[FormBuilderPage] Comparing ${question.questionId} to ${updatedQuestion.questionId}...');
              _currentForm!.questions.where((q) => q.questionId == question.questionId);      /// add to the local one for now
              /// but for sanity and peace-of-mind, we'll persist it right away just in case
              await _formService.saveFormQuestionsOverwrite(
                existingForm: _currentForm!, 
                newQuestions: _currentForm!.questions);
            }
        ); 
      }
    );
  
    if (modifiedQuestion != null) {
      /// question is modified, so find old one via questionId
      int index = _currentForm!.questions.indexWhere((Question q) => 
      q.questionId == question.questionId);
      if (index > -1) {
        setState(() {
          _currentForm?.questions[index] = modifiedQuestion;
          _markFormAsDirty();
        });
        /// Persist our changes to the database last
        _formService.saveQuestionOnForm(newQuestion: modifiedQuestion, existingForm: _currentForm!);
      }
      else {
        print('Failed to find the index of the targeted question ${question.questionId}');
      }
    }
  }


  /// removes a question from the form.  
  /// TODO: if content not empty, warn with dialogue
  void _deleteQuestion(Question selectedQuestion) {
    setState(() {
      _currentForm!.questions.remove(selectedQuestion);
      _markFormAsDirty();

    });
  }
  
  @override
  Widget build(BuildContext context) {
    /// give [_sliderValue] a valid number
    _sliderValue = 0.5;
    /// update [_currentForm]

    return PopScope(
      canPop: false,  /// allows the page to the user of unsaved data loss on back taps
      onPopInvoked: (bool didPop) async {
        /// TODO: implement a more smooth isDirty attribute of the form, perhaps on the model?
        showBackDialog(context);
        if (didPop) {
          Navigator.of(context).pop();
        }
      },
      child: FutureBuilder<GenericForm?>(
        future: _formFuture,
        builder: (context, snapshot) {
          // _currentForm = _formService.;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(height: 35, width: 35,child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {  
            /// we KNOW it will have a form inside, so we use '!'
            _currentForm = snapshot.data!;
            return Scaffold(
              // appBar: AppBar(title: Text('Form Builder - ${snapshot.data!.formName}')),
              appBar: AppBar(
                title: Text('Form Builder - ${_currentForm?.formName}'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () {
                    if (_isFormDirty) {
                      _formService.saveForm(_currentForm!);
                      setState(() {
                        _isFormDirty = false;
                      });
                    }
                  },
                  )
                ],
              ),
              body: buildQuestions(_currentForm?.questions),
              floatingActionButton: FloatingActionButton(
                onPressed: _addNewQuestion,
                tooltip: 'Add Question',
                child: const Icon(Icons.add_circle)),
            );
          } else {
            return Text('Snapshot was empty fetching data for the form.');
          }
        } 
      ),
    );
  }
  
  /// used to allow the shorthand ?? syntax in the onPressed for the dialog
  String getHeader(Question? question) {
    if (question != null) {
      return 'Question ${question.ordinal}';
    } else {
      return 'New Question';
    }
  }
}
