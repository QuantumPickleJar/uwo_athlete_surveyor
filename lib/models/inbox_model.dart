// ignore_for_file: dangling_library_doc_comments

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: Model for the InboxPage; fetches messages from DB on load.
/// Bugs: n/a
/// Reflection: n/a

import 'package:athlete_surveyor/data_objects/message.dart';
import 'package:athlete_surveyor/database.dart';
import 'package:flutter/material.dart';

/// Model for InboxPage.
class InboxModel extends ChangeNotifier
{
  final List<Message> emailList = [];

  /// Get all inbox messages from the database and insert into internal list.
  Future<void> getEmailsFromDatabase() async 
  {
    await Database.fetchEmails().then((results) 
    {  
      emailList.clear();

      for(int i = 0; i < results.length; i++)
      {
        emailList.add(Message(results[i][0] as DateTime,//receivedDate
                            results[i][1].toString(),   //from
                            results[i][2].toString(),   //subject
                            results[i][3].toString(),   //body
                            results[i][4].toString(),   //firstName
                            results[i][5].toString())); //lastName
      }

      notifyListeners();
    });
  }
}