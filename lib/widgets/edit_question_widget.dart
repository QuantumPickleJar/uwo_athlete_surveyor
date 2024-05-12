import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/models/response_type.dart';
import 'package:flutter/material.dart';
    
/// Widget responsible for containing question-manipulating operations
/// inside of a Dialog, to keep flow of control linear 
class EditQuestionWidget extends StatefulWidget {
  final Question question;
  final Function(Question) onSave;    /// what should happen to the question when done
  final Function onCancel;            /// what (if anything) should happen on cancellation
  
  const EditQuestionWidget({ 
    Key? key, 
    required this.question,
    required this.onSave,
    required this.onCancel,
     }) : super(key: key);

  @override
  State<EditQuestionWidget> createState() => _EditQuestionWidgetState();
}

class _EditQuestionWidgetState extends State<EditQuestionWidget> {
  // _questionTextController.text = question?.content ?? '';
  late TextEditingController _textController;
  late ResponseType _responseFormat;
  late bool _resRequired;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.question.content);
    _responseFormat = widget.question.resFormat;
    _resRequired = widget.question.resRequired;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }


 void _save() {
    // Update the question with new values
    Question updatedQuestion = Question(
      formId: widget.question.formId,
      questionId: widget.question.questionId,
      ordinal: widget.question.ordinal,
      header: widget.question.header,
      content: _textController.text,
      resFormat: _responseFormat,
      resRequired: _resRequired,
      linkedFileKey: widget.question.linkedFileKey,
    );

    widget.onSave(updatedQuestion);
  }


  @override
  Widget build(BuildContext context) {
    _textController.text = widget.question?.content ?? 'enter';
    ResponseType selectedFormat = _responseFormat;
      return AlertDialog(
        title: const Text('Edit Question'),
        content: Column(
        children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Question Content',
            ),
          ),
          
          /// load the ResponseTypes into their own DropDown
          DropdownButton<ResponseType>(
            value: selectedFormat,
            onChanged: (ResponseType? newValue) {
              setState(() {
                if (newValue != null) {
                  print("Dropdown items: ${ResponseWidgetType.values.map(
                    (type) => ResponseType(widgetType: type)).toList()}");
                  // selectedResponseType = newValue ?? ResponseType.getDefaultWidgetType();
                  selectedFormat = newValue;
                  print("Selected value: ${selectedFormat.widgetType.name}");
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
            value: _resRequired ?? false,
            onChanged: (bool? newValue) {
              setState(() {
                _resRequired = newValue!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: widget.onCancel as void Function()?,
          child: const Text('Cancel'),
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: _save,
        ),
      ]);
  }
}