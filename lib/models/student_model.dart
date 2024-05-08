// ignore_for_file: avoid_print

import 'package:athlete_surveyor/database.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class StudentsModel extends ChangeNotifier {
  final List<Student> students = [];


void sortByGrade(){
  students.sort((a,b) => a.grade.compareTo(b.grade));
  notifyListeners();
}

void sortBySport(){
  students.sort((a,b) => a.sport.compareTo(b.sport));
  notifyListeners();
}
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

Future<void> deleteStudent(String name, String grade, String sport) async {
  try {
    Connection conn = await Database.getOpenConnection();
    await conn.execute(
      "DELETE FROM tbl_studentlist WHERE student_name = '$name' AND grade = '$grade' AND sport = '$sport'",
    );
    students.clear();
    await fetchStudentsFromDatabase(); // Repopulate the List with the new added student
    notifyListeners();
  } catch (e) {
    print('Error deleting student from database: $e');
    rethrow;
  }
}

Future<void> editStudent(String name, String grade, String sport) async {
  try {
    Connection conn = await Database.getOpenConnection();
    await conn.execute(
      "UPDATE tbl_studentlist SET grade = @grade, sport = @sport WHERE student_name = @name",
    );
    students.clear();
    await fetchStudentsFromDatabase(); // Repopulate the List with the new added student
    notifyListeners();
  } catch (e) {
    print('Error deleting student from database: $e');
    rethrow;
  }
}

Future<void> updateStudentInDatabase(String name, String newName, String grade, String sport) async {
  try {
    Connection conn = await Database.getOpenConnection();
    await conn.execute(
      "UPDATE tbl_studentlist SET student_name = '$newName', grade = '$grade', sport = '$sport' WHERE student_name = '$name'",
    );
    students.clear();
    await fetchStudentsFromDatabase(); // Repopulate the List with the updated student information
    notifyListeners();
  } catch (e) {
    print('Error updating student in database: $e');
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
   String name;
   String grade;
  String sport;
  
  

  Student({
    required this.name,
    required this.grade,
    required this.sport,
   
    
  });

  void editStudent(String newName, String newGrade, String newSport) {
    name = newName;
    grade = newGrade;
    sport = newSport;
  }
}
