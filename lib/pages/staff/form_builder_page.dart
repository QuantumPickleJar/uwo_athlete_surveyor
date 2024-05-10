import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/forms/staff_form.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:athlete_surveyor/widgets/question_item.dart';
import  'package:athlete_surveyor/models/response_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  
  /// Allows modifying a *single* [QuestionItem] at a time.  This *should*
  /// allow the transition to an expanded-style question widget as 
  /// opposed to the existing [AlertDialog]-based solution
  late final TextEditingController _questionTextController;
  
  /// looks at formName to determine if the name is still untouched\
  /// e.g if (formName.contains("New Form")){ ... }
  late final FormService _formService;

  /// the form currently being modified

  // /// Temporary placeholder to allow the slider to be enabled
  // void _onSliderTap() {
  //   return;
  // }

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
        if (loadedForm != null) {
          // setState(() {
          //   _currentForm = loadedForm; // Update the state with loaded form
          // // Convert GenericForm to StaffForm using the dedicated constructor
          // });
          _currentForm = loadedForm;
          return loadedForm;
        } 
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

  /// Opens a dialog that contains controls for manipulating a question.
  Column launchQuestionDialog(Question? question) { 
    _questionTextController.text = question?.content ?? '';
    ResponseType selectedResponseType = question?.resFormat ?? ResponseType.getDefaultWidgetType();

    return Column(
      children: [
        TextField(
          controller: _questionTextController,
          decoration: const InputDecoration(
            labelText: 'Question Content',
          ),
        ),
        
        DropdownButton<ResponseType>(
          value: selectedResponseType,
          onChanged: (ResponseType? newValue) {
            setState(() {
              if (newValue != null) {
                print("Dropdown items: ${ResponseWidgetType.values.map(
                  (type) => ResponseType(widgetType: type)).toList()}");
                // selectedResponseType = newValue ?? ResponseType.getDefaultWidgetType();
                selectedResponseType = newValue;
                print("Selected value: ${selectedResponseType.widgetType.name}");
              }
            });
          },
          items: ResponseWidgetType.values.map((type) {
            return DropdownMenuItem<ResponseType>(
              value: ResponseType(widgetType: type),
              child: Text(type.name),
            );
          }).toList(),
        ),
        CheckboxListTile(
          title: const Text('Response Required'),
          value: question?.resRequired ?? false,
          onChanged: (bool? newValue) {
            setState(() {
              question?.resRequired = newValue!;
            });
          },
        ),
      ],
    );
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

  
  void _editQuestion(Question question) async{    
    final Question? modifiedQuestion = await showDialog<Question>(
      context: context, 
      builder: (BuildContext context) {
          return AlertDialog(
          title: const Text('Edit Question'),
          content: 
          /// TODO: make in edit_question (or, would it be `edit_question_widget`, since we just need UI elements for accepting input, preloaded with existing information on edit operations)
          // EditQuestionWidget(question), 
            Builder(
              builder: (context) => launchQuestionDialog(question),
            ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                print('Saving question ${question.questionId}...');
                setState(() {
                  int index = _currentForm!.questions.indexOf(question);
                  /// Load the question into the dialog by [index]
                  _currentForm!.questions[index] = Question(
                  formId: widget.formId!,
                  questionId: question.questionId,
                  ordinal: question.ordinal ?? -1,
                  header: getHeader(question),
                  content: _questionTextController.text,
                  // we only need the enum, none of the UI func that comes with it, hence this "as" 
                  resFormat: question.resFormat,
                  resRequired: false,
                  linkedFileKey: null
                  );
                });
                /// TODO: confirm the question adds from here
                Navigator.of(context).pop(question);
              },
            ),
          ],
        );
      }
    );

    /// question is modified, so find old one with via questionId
    int qstOrdinal = _currentForm!.questions.indexWhere((Question q) => 
      q.questionId == question.questionId);
      if (qstOrdinal > -1 && modifiedQuestion != null) {
        _currentForm?.questions[qstOrdinal] = modifiedQuestion;
      }
      else {
        print('Failed to find the index of the targeted question ${question.questionId}');
    }
  }


  /// removes a question from the form.  
  /// TODO: if content not empty, warn with dialogue
  void _deleteQuestion(Question selectedQuestion) {
    setState(() {
      _currentForm!.questions.remove(selectedQuestion);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    /// give [_sliderValue] a valid number
    _sliderValue = 0.5;
    /// update [_currentForm]

    return FutureBuilder<GenericForm?>(
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
            appBar: AppBar(title: Text('Form Builder - ${_currentForm?.formName}')),
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
