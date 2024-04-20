import 'package:athlete_surveyor/models/forms/staff_form.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:athlete_surveyor/widgets/ExpandedTextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormBuilderPage extends StatefulWidget {
  const FormBuilderPage({Key? key}) : super(key: key);

  @override
  _FormBuilderPageState createState() => _FormBuilderPageState();
}


class _FormBuilderPageState extends State<FormBuilderPage> {

  late double _sliderValue;
  late final _formService;
  late StaffForm _currentForm;    /// the form currently being modified

  /// Temporary placeholder to allow the slider to be enabled
  void _onSliderTap() {
    return;
  }

  @override 
  void initState() {
    super.initState();
    _formService = Provider.of<FormService>(context, listen: true);

  }

  @override
  Widget build(BuildContext context) {
    /// give [_sliderValue] a valid number
    _sliderValue = 0.5;

    return Consumer<StaffForm>(
      builder: (context, form, child) { 
        return Scaffold(
          appBar: AppBar(title: Text('Form Builder - ${form.formName}')),
          body:  ListView.builder(
            itemCount: form.questions.length,
            itemBuilder: (context, index) {
              Question question = form.questions[index];
              
              /// this is where we unpack the contents of the question
              return ListTile(
                title: Text(question.header),
                subtitle: Text(question.content),
              );
            }
          ),
          
          
        );
      }
  }

  void _openFormatModal() {
    // TODO: make this later, see the figma for the prototype
    return;
  }
}
