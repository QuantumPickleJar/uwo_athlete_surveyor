/* Author - Joshua */
import 'package:athlete_surveyor/data_objects/previous_form.dart';
import 'package:flutter/material.dart';

class PreviousFormsModel extends ChangeNotifier 
{
  final List<PreviousForm> formsList = 
  [
    PreviousForm("BBI Daily Assessment", "Volleyball", DateTime(2023, 10, 25), DateTime(2023, 10, 25)),
    PreviousForm("BBI Daily Assessment", "Basketball", DateTime(2023, 10, 25), DateTime(2023, 10, 25)),
    PreviousForm("BBI Midterm Assessment", "Volleyball", DateTime(2023, 10, 24), DateTime(2023, 10, 26)),
    PreviousForm("BBI Midterm Assessment", "Basketball", DateTime(2023, 10, 24), DateTime(2023, 10, 26)),
    PreviousForm("BBI Semester Start Assessment", "Volleyball", DateTime(2023, 9, 6), DateTime(2023, 9, 10)),
    PreviousForm("BBI Semester Start Assessment", "Volleyball", DateTime(2023, 9, 6), DateTime(2023, 9, 10)),
  ];
}