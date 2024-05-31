import 'package:athlete_surveyor/data_objects/email.dart';
import 'package:athlete_surveyor/database.dart';
import 'package:flutter/material.dart';

class InboxModel extends ChangeNotifier
{
  final List<Email> emailList = [];

  /// TODO (later): differentiate between [User] types (if scope dictates)
  /// Get all inbox messages from the database and insert into internal list.
  Future<void> getEmailsFromDatabase(String userId) async {
    await Database.fetchEmailsByUserId(userId).then((results) {
      emailList.clear();

      for(int i = 0; i < results.length; i++)
      {
        emailList.add(Email(results[i][0] as DateTime,  //receivedDate
                            results[i][1].toString(),   //from
                            results[i][2].toString(),   //subject
                            results[i][3].toString(),   //body
                            
        ));
      }

      /// In order to use this, [database.dart] needs to be refactored to return more 
      /// specific Futures than [Result]. e.g Future<List<Map<String, dynamic>>> 
      // for (var row in results) {
      //   emailList.add(Email(
      //     DateTime.parse(row['date_received'].toString()),
      //     row['from_uuid'].toString(),
      //     row['subject_line'].toString(),
      //     row['body'].toString(),
      //   ));
      // }

      notifyListeners();
    });
  }
}