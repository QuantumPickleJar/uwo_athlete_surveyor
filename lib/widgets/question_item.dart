// ignore_for_file: dangling_library_doc_comments

/// Name:
/// Date:
/// Description:
/// Bugs:
/// Reflection:

import 'package:athlete_surveyor/models/question.dart';
import 'package:flutter/material.dart';
    
/// Custom StatefulWidget that eases the means of rendering quesitions on 
/// a form.  
/// 
/// Designed to be used independent of a user's role, so that the editor 
/// controls can be loaded separate from the loading of a question's info
/// into a [Card].  This may 
class QuestionItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(question.header),
      onTap: () => onUpdate(question), 
      trailing: IconButton(
        icon: const Icon(Icons.delete_forever),
        onPressed: () => onDelete(question),
      )
    );
  }
}