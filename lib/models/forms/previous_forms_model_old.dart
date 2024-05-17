// import 'package:athlete_surveyor/data_objects/previous_form.dart';
// import 'package:athlete_surveyor/database.dart';
// import 'package:flutter/material.dart';

// // Temporary model; subject to change.
// class PreviousFormsModel extends ChangeNotifier 
// {
//   final List<PreviousForm> formsList = [];

//   /// Get all inbox messages from the database and insert into internal list.
//   Future<void> getPreviousFormsFromDatabase() async 
//   {
//     await Database.fetchPreviousForms().then((results) 
//     {  
//       formsList.clear();

//       for(int i = 0; i < results.length; i++)
//       {
//         formsList.add(PreviousForm( results[i][0].toString(),   //formName
//                                     results[i][1].toString(),   //associatedSport
//                                     results[i][2] as DateTime,  //dateReceived
//                                     results[i][3] as DateTime));//date_completed
//       }

//       notifyListeners();
//     });
//   }
// }