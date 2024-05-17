// ignore_for_file: dangling_library_doc_comments, avoid_print

/// Name: Amanda Dorsey
/// Date:5/17/24
/// Description: the student model to compare students by grade or sport. It also hold the modal 
/// to add students to the database, delete them, fetch and edit the students as well. 
/// Bugs: none
/// Reflection: I first started off with just sport, name, and grade, but realized that id
/// needed to be added for deletion purposes so no two students with the same credientials was deleted. 
/// Getting ID set up after I added the columncs was difficult

import 'package:athlete_surveyor/database.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class StudentsModel extends ChangeNotifier {
  final List<Student> students = [];

  void sortByGrade() {//sorts by grade and displays the sort
    students.sort((a, b) => a.grade.compareTo(b.grade));
    notifyListeners();
  }

  void sortBySport() {//sorts by sport and displays the sort
    students.sort((a, b) => a.sport.compareTo(b.sport));
    notifyListeners();
  }

  // Inserts students into the database
  Future<void> addStudentToDatabase(String name, String grade, String sport, String id) async {
    try {
      Connection conn = await Database.getOpenConnection();
      await conn.execute(
        "INSERT INTO tbl_studentlist (student_name, grade, sport, student_id) VALUES (\$1, \$2, \$3, \$4)",
        parameters: [name, grade, sport, id],
      );
      students.clear();
      await fetchStudentsFromDatabase(); // Will repopulate the List with the new added student
      notifyListeners();
    } catch (e) {
      print('Error adding student to database: $e');
      rethrow;
    }
  }
  //deletes the student by looking at their id and then deleting the id correspoding name, grade and sport
  Future<void> deleteStudent(String name, String grade, String sport, String id) async {
    try {
      Connection conn = await Database.getOpenConnection();
      await conn.execute(
        "DELETE FROM tbl_studentlist WHERE student_name = '$name' AND grade = '$grade' AND sport = '$sport' AND student_id = '$id'",
      );
      students.clear();
      await fetchStudentsFromDatabase(); // Repopulate the List with the new added student
      notifyListeners();
    } catch (e) {
      print('Error deleting student from database: $e');
      rethrow;
    }
  }

  //edits the student of choice based on name
  Future<void> editStudent(String name, String grade, String sport, String id) async {
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
  //this then updates the database based on ID of the student and then notifies the listens(displays it)
  Future<void> updateStudentInDatabase(String name, String? newName, String grade, String sport, String id) async {
    try {
      Connection conn = await Database.getOpenConnection();
      if (newName != null) {
        await conn.execute(
          "UPDATE tbl_studentlist SET student_name = '$newName', grade = '$grade', sport = '$sport', student_id = '$id' WHERE student_id = '$id'",
        );
        students.clear();
        await fetchStudentsFromDatabase(); // Repopulate the List with the updated student information
        notifyListeners();
      }
    } catch (e) {
      print('Error updating student in database: $e');
      rethrow;
    }
  }

  // Method to fetch students from the database and puts it into an array
  Future<void> fetchStudentsFromDatabase() async {
    try {
      final Result result = await Database.fetchStudents();

      // Process the result and populate the students list
      for (final row in result) {
        final String name = row[0] as String;
        final String grade = row[1] as String;
        final String sport = row[2] as String;
        final String id = row[3] as String;
        final Student student = Student(name: name, grade: grade, sport: sport, id: id);
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
//what makes up each student(athlete)
class Student {
  String name;
  String grade;
  String sport;
  String id;

  Student({//whats required to put in each student 
    required this.name,
    required this.grade,
    required this.sport,
    required this.id,
  });

  //the new information is put into the variable of name, grade,sport and id
  void editStudent(String newName, String newGrade, String newSport, String newId) {
    name = newName;
    grade = newGrade;
    sport = newSport;
    id = newId;
  }
}
