import 'package:athlete_surveyor/data_objects/previous_form.dart';
import 'package:flutter/material.dart';
import 'package:athlete_surveyor/pages/add_athlete_page.dart';

class StudentsModel extends ChangeNotifier {
  final List<Student> students = [];

  // Method to add a student
  void addStudent(Student student) {
    students.add(student);
    notifyListeners();
  }
}

class Student {
  final String name;
  final String grade;
  final String sport;

  Student({
    required this.name,
    required this.grade,
    required this.sport,
  });
}