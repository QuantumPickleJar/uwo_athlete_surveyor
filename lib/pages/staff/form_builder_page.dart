import 'dart:convert';

import 'package:athlete_surveyor/models/forms/staff_form.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:athlete_surveyor/widgets/ExpandedTextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormBuilderPage extends StatefulWidget {
  final String formId;  // id linking page to the form
  const FormBuilderPage({Key? key, required this.formId}) : super(key: key);

  @override
  _FormBuilderPageState createState() => _FormBuilderPageState();
}


class _FormBuilderPageState extends State<FormBuilderPage> {
  late double _sliderValue;
  late bool _isOpenedFormNew;
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
    _formService = Provider.of<FormService>(context, listen: false);
    _loadForm(widget.formId);
  }

  Future<void> _loadForm(String formId) async {
      try {
        var loadedForm = await _formService.fetchOrCreateForm(formId: formId);
        setState(() {
          _currentForm = StaffForm.fromGenericForm(loadedForm); // Set the loaded form to the current form
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
            questions: []
          );
        });

        } else { /// else it must be an UPDATE
          // TODO: consider an is loading here for displaying a spinner
          _formService.getFormById(widget.formId);
        }
      /// check if we need to make an additional call to the DB (should happen behind)
      _isOpenedFormNew = widget.formId.isEmpty;
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
