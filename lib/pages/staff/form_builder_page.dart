import 'dart:convert';

import 'package:athlete_surveyor/models/form_factory.dart';
import 'package:athlete_surveyor/models/forms/staff_form.dart';
import 'package:athlete_surveyor/models/interfaces/i_generic_form.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:athlete_surveyor/widgets/ExpandedTextField.dart';
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
    _loadForm(widget.formId!) as StaffForm;
  }

  Future<void> _loadForm(String formId) async {
      try {
        Form loadedForm = (await _formService.fetchOrCreateForm(formId: formId)) as Form;
        setState(() {
          _currentForm = StaffForm.fromGenericForm(loadedForm as IGenericForm, [], DateTime.now()); // Set the loaded form to the current form
          /// could also call the form factor 
        });
      } catch (e) { /// an exception will occur if not found
        /// a bit dirty--we handle the not found case in the catch
        if(formId.isEmpty) {
        /// CREATE a new form if we didn't receive a `formId`
        setState(() {
          _currentForm = StaffForm(
            formId: '', 
            formName: 'Untitled Form', 
            sport: "SOME SPORT", 
            List.empty()
          );
        });

        } else { /// else it must be an UPDATE
          // TODO: consider an is loading here for displaying a spinner
          _formService.getFormById(widget.formId!);
        }
      /// check if we need to make an additional call to the DB (should happen behind)
      _isOpenedFormNew = widget.formId!.isEmpty;
      }
    }
  

  @override
  Widget build(BuildContext context) {
    /// give [_sliderValue] a valid number
    _sliderValue = 0.5;
    /// update [_currentForm]
    return Consumer<StaffForm>(
      builder: (context, form, child) {
        // _currentForm = _formService.;

        return buildQuestions(form);
      }, 
      child: Scaffold(
        appBar: AppBar(title: Text('Form Builder - ${_currentForm.formName}')),
        body: const Center(
         child: Column(children: [
            Row(children: [
              SizedBox(height: 20, child: Text("Test content!"))      
            ])
          ],) 
        )
      ),
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
