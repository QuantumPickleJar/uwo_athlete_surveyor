import 'package:athlete_surveyor/data_objects/email.dart';
import 'package:flutter/material.dart';

class InboxModel extends ChangeNotifier
{
  final List<Email> emailList =
  [
    Email(DateTime(2023, 10, 25), "System"          , "Reminder - Complete BBI Daily Assessment: Basketball", "You are receiving this reminder message because you haven't completed the daily form..."),
    Email(DateTime(2023, 10, 20), "Volleyball Coach", "Reschedule One-on-One Meeting"                       , "Hey Student, Unfortunately something unforseen came up and I won't be able to mak..."),
    Email(DateTime(2023, 9, 15) , "System"          , "New Form Assigned By: Basketball Coach"              , "A new form has been assigned to you, please complete it at your earliest convenience."),
    Email(DateTime(2023, 9, 1)  , "System"          , "Reminder - Complete BBI Daily Assessment: Basketball", "Thank you for signing up for the Be Better Initiative form management app. Here you w...")
  ];
}