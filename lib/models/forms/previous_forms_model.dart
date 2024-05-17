// ignore_for_file: dangling_library_doc_comments

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: Temporary page from prototyping intended to show how previously completed forms would populate for the user to peruse.
/// Bugs: n/a
/// Reflection: Still a temporary model. If this line is still present in submission then we likely didn't have time to finish some feature or other.

import 'package:athlete_surveyor/data_objects/previous_form.dart';
import 'package:athlete_surveyor/database.dart';
import 'package:flutter/material.dart';

// Temporary model; subject to change.
class PreviousFormsModel extends ChangeNotifier 
{
  final List<PreviousForm> formsList = [];

  /// Get all previously completed forms from the database and insert into internal list.
  Future<void> getPreviousFormsFromDatabase() async
  {
    await Database.fetchPreviousForms().then((results) 
    {  
      formsList.clear();

      for(int i = 0; i < results.length; i++)
      {
        formsList.add(PreviousForm( results[i][0].toString(),   //formName
                                    results[i][1].toString(),   //associatedSport
                                    results[i][2] as DateTime,  //dateReceived
                                    results[i][3] as DateTime));//date_completed
      }

      notifyListeners();
    });
  }
}