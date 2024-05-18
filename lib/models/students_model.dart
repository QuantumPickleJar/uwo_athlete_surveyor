// ignore_for_file: avoid_print

import 'package:athlete_surveyor/database.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class StudentsModel extends ChangeNotifier {
  final List<Student> students = [];
  
//inserts students into the database 
Future<void> addStudentToDatabase(String name, String grade, String sport) async {
  try {
    Connection conn = await Database.getOpenConnection();
    await conn.execute("INSERT INTO tbl_studentlist (student_name, grade, sport) VALUES (\$1, \$2, \$3)",
        parameters: [name, grade, sport]);
        students.clear();
        fetchStudentsFromDatabase();//will repopulate the List with the new added student
        notifyListeners();
  } catch (e) {
    print('Error adding student to database: $e');
    rethrow;
  }
}


  // Method to fetch students from the database
  Future<void> fetchStudentsFromDatabase() async {
    try {
      final Result result = await Database.fetchStudents();

      // Process the result and populate the students list
      for (final row in result) {
        final String name = row[0] as String;
        final String grade = row[1] as String;
        final String sport = row[2] as String;
        final Student student = Student(name: name, grade: grade, sport: sport);
        students.add(student);
      }
      // Notify listeners that the data has been fetched
      notifyListeners();
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

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
