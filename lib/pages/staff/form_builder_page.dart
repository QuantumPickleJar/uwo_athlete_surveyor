import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/forms/staff_form.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Page responsible for creating and modifying forms. 
/// 
/// Per the object family defined, the presented form is built from
/// a [GenericForm] holding (existing, if any) data, which is then 
class FormBuilderPage extends StatefulWidget {
  final String? formId;  // id linking page to the form
  // final StaffForm currentForm;    /// the form currently opened
  const FormBuilderPage({Key? key, required this.formId}) : super(key: key);

  @override
  _FormBuilderPageState createState() => _FormBuilderPageState();
}


class _FormBuilderPageState extends State<FormBuilderPage> {
  late double _sliderValue;
  late bool _isOpenedFormNew;  

  /// looks at formName to determine if the name is still untouched\
  /// e.g if (formName.contains("New Form")){ ... }
  late final FormService _formService;
  late StaffForm _currentForm;

  /// the form currently being modified

  /// Temporary placeholder to allow the slider to be enabled
  void _onSliderTap() {
    return;
  }

  @override
  void initState() {
    super.initState();
    print(widget.formId);  // Ensure this prints the expected UUID
    _formService = Provider.of<FormService>(context, listen: false);
    // _loadForm(widget.formId!) as StaffForm;
    /// if this is a **NEW** form, it'll (briefly) have a null `form_id`
    _isOpenedFormNew = widget.formId == null || widget.formId!.isEmpty;
  }

  Future<StaffForm> _loadForm(String formId) async {
      try {
        GenericForm loadedForm = await _formService.fetchOrCreateForm(formId: formId);
        
        // setState(() {
          /// Set the loaded form to the current form
          // _currentForm = StaffForm.fromGenericForm(loadedForm); 
        // });
         if (loadedForm is StaffForm) {
          return loadedForm;
         } else {
          // Convert GenericForm to StaffForm using the dedicated constructor
          return StaffForm.fromGenericForm(loadedForm);
        }
      } catch (e) { /// an exception will occur if not found
        print('Error loading form: $e');
      /// check if we need to make an additional call to the DB (should happen behind)
      // _isOpenedFormNew = widget.formId!.isEmpty;
      throw Exception('Failed to load form: ${e.toString()}');
      }
    }
  

  @override
  Widget build(BuildContext context) {
    /// give [_sliderValue] a valid number
    _sliderValue = 0.5;
    /// update [_currentForm]
    return FutureBuilder<StaffForm>(
      future: _loadForm(widget.formId!),
      builder: (context, snapshot) {
        // _currentForm = _formService.;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(height: 35, width: 35,child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return Text('Error: ${snapshot.error ?? "No data available for the form."}');
          // return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {  
          /// we KNOW it will have a form inside, so we use '!'
        
          return Scaffold(
            appBar: AppBar(title: Text('Form Builder - ${snapshot.data!.formName}')),
            body: buildQuestions(snapshot.data!),
            floatingActionButton: FloatingActionButton(
              onPressed: _addNewQuestion(),tooltip: 'Add Question',
              child: const Icon(Icons.add_circle)),
          );
        } else {
          return Text('No data available for the form.');
        }
      } 
    );
  }

  
  /// Builds the scaffold for displaying a StaffForm's [questions] .
  ///
  /// Takes a [StaffForm] object and returns a [Scaffold]  widget that
  /// displays the questions in a [ListView.builder].
  ///
  /// Each question is displayed as a [ListTile] with the question
  /// header as the title and the question content as the subtitle.
  Widget buildQuestions(StaffForm form) {
    return ListView.builder(
      itemCount: form.questions.length,
      itemBuilder: (context, index) {
      Question question = form.questions[index];

      /// this is where we unpack the contents of the question
      return Card(
      child: ListTile(
        title: Text(question.header),
        subtitle: Text(question.content),
      ),
    );
   });
  }
}
