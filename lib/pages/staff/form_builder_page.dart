// ignore_for_file: dangling_library_doc_comments, avoid_print, library_private_types_in_public_api, unused_field, unused_local_variable, unused_element

/// Name:
/// Date:
/// Description:
/// Bugs:
/// Reflection:

import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/forms/staff_form.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:athlete_surveyor/widgets/question_item.dart';
import  'package:athlete_surveyor/models/response_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

/// Page responsible for creating and modifying forms. 
/// 
/// Per the object family defined, the presented form is built from
/// a [GenericForm] holding (existing, if any) data, which is then 
class FormBuilderPage extends StatefulWidget {
  final String? formId;  // id linking page to the form
 
  const FormBuilderPage({super.key, required this.formId});

  @override
  _FormBuilderPageState createState() => _FormBuilderPageState();
}


class _FormBuilderPageState extends State<FormBuilderPage> {
  GenericForm? _currentForm;        /// the form currently opened
  late Future<GenericForm?> _formFuture;        /// the form currently opened
  late double _sliderValue;
  late bool _isOpenedFormNew;  
  
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
    _isOpenedFormNew = widget.formId == null || widget.formId!.isEmpty;
    // _loadForm(widget.formId!);
    _formFuture = _loadForm();
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
       GenericForm? loadedForm = await _formService.fetchOrCreateForm(formId: widget.formId);
          // setState(() {
          //   _currentForm = loadedForm; // Update the state with loaded form
          // // Convert GenericForm to StaffForm using the dedicated constructor
          // });
        return loadedForm;
      } catch (e) { 
        /// an exception will occur if not found
        print('Error loading form: $e');
        /// check if we need to make an additional call to the DB (should happen behind)
        /// _isOpenedFormNew = widget.formId!.isEmpty;
        return null;
        }
      }

      return null;
    }
  
  
  /// Builds the scaffold for displaying a StaffForm's [questions] .
  ///
  /// Takes a [StaffForm] object and returns a [Scaffold]  widget that
  /// displays the questions in a [ListView.builder].
  ///
  /// Each question is displayed as a [ListTile] with the question
  /// header as the title and the question content as the subtitle.
  Widget buildQuestions(List<Question>? questions) {
    return ListView.builder(
      itemCount: questions?.length ?? 0,
      itemBuilder: (context, index) {
        Question? question = questions?[index]; 

      /// this is where we unpack the contents of the question.
      return Card(
      child: ListTile(
        title: Text(question?.header ?? 'New Question'),
        subtitle: Text(question?.content ?? 'no content provided'),
      ),
    );
   });
  }

  Column launchQuestionEditor(Question? question) { 
    _questionTextController.text = question?.content ?? '';
    ResponseWidgetType selectedResponseType = question?.resFormat as ResponseWidgetType;

    return Column(
      children: [
        TextField(
          controller: _questionTextController,
          decoration: const InputDecoration(
            labelText: 'Question Content',
          ),
        ),
        DropdownButton<ResponseType>(
          value: selectedResponseType as ResponseType,
          onChanged: (ResponseType? newValue) {
            setState(() {
              selectedResponseType = newValue! as ResponseWidgetType;
            });
          },
          items: ResponseWidgetType.values.map<DropdownMenuItem<ResponseType>>(
            (ResponseWidgetType responseType) {
            return DropdownMenuItem<ResponseType>(
              value: responseType as ResponseType,
              child: Text(responseType.toString()), // shouldn't this use the .name? 
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
  }
  
  /// Adds an empty question to the currently loaded form.
  /// Collects necessary parameters from an awaited call to
  /// an [AlertDialog] configured to return a [Question] 
  Future<void> _addOrEditQuestion(Question? question) async {
    // If we're editing an existing question, set the text controller to the question's content
    if (question != null) {
      _questionTextController.text = question.content;
    } else {
      _questionTextController.clear();
    }

    final Question? modifiedQuestion = await showDialog<Question>(
      context: context, 
      builder: (BuildContext context) {
          return AlertDialog(
          title: Text(question == null ? 'Add New Question' : 'Edit Question'),
          content: 
          // EditQuestionWidget(question), 

            Builder(
              builder: (context) => launchQuestionEditor(question),
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
                var newQuestion = Question(
                  formId: widget.formId!,
                  /// generate a new Id if we have to
                  questionId: question?.questionId ?? const Uuid().v4(),
                  ordinal: question?.ordinal ?? -1,
                  header: question?.header ?? getHeader(question),
                  content: _questionTextController.text,
                  // we only need the enum, none of the UI func that comes with it, hence this "as" 
                  resFormat: question?.resFormat ?? ResponseType.getDefaultWidgetType() as ResponseType,
                  resRequired: false,
                  linkedFileKey: null
                );
                Navigator.of(context).pop(question);
              },
            ),
          ],
        );
      }
    );
  }

  
  @override
  Widget build(BuildContext context) {
    /// give [_sliderValue] a valid number
    _sliderValue = 0.5;
    /// update [_currentForm]
    

    return FutureBuilder<GenericForm?>(
      future: _loadForm(),
      builder: (context, snapshot) {
        // _currentForm = _formService.;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 35, width: 35,child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error ?? "No data available for the form."}');
          // return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {  
          /// we KNOW it will have a form inside, so we use '!'
        
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
          return const Text('No data available for the form.');
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
