import 'package:athlete_surveyor/models/question.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Container(),
    );
  }
}