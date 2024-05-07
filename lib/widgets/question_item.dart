import 'package:athlete_surveyor/models/question.dart';
import 'package:flutter/material.dart';
    
/// Custom StatefulWidget that eases the means of rendering quesitions on 
/// a form.  
/// 
/// Designed to be used independent of a user's role, so that the editor 
/// controls can be loaded separate from the loading of a question's info
/// into a [Card].  This may 
class QuestionItem extends StatefulWidget {
  final Question question;      /// the question held within
  
  /// existing items can only be MODIFIED or DELETED:
  final Function(Question) onUpdate;        
  final Function(Question) onDelete;
  const QuestionItem({
    Key? key, 
    required this.question, 
    required this.onDelete, 
    required this.onUpdate
    }) : super(key: key);



  @override
  _QuestionItemState createState() => _QuestionItemState();
}

class _QuestionItemState extends State<QuestionItem> {
 
  /// Invoke dialog to edit question and pass the result to onUpdate
  void _editQuestion() async {
    throw UnimplementedError(); 
  }
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Question'),
      onTap: _editQuestion, 
      trailing: IconButton(
        icon: const Icon(Icons.delete_forever),
        onPressed: () => widget.onDelete(widget.question),
      )

    );
  }
}