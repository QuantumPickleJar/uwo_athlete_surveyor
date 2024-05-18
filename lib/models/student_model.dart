import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:flutter/material.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/models/response.dart';

/// Model representing an individual student, including their details
/// and the form they are currently taking, along with their responses.
class StudentModel extends ChangeNotifier {
  final LoggedInUser student;
  final List<Question> questions;
  final Map<String, Response> responses = {};

  /// easy-access getters for [StudentModel] Consumers
  String get name => '${student.firstName} ${student.lastName}';
  String get grade => student.hasAdminPrivileges ? 'N/A' : 'Some Grade'; // Replace with actual grade retrieval logic
  String get sport => 'Some Sport'; // Replace with actual sport retrieval logic



  StudentModel({
    required this.student,
    required this.questions,
  });

  /// Answer a question with the given [questionId] and [answer].
  void answerQuestion(String questionId, dynamic answer) {
    Question question = questions.firstWhere((q) => q.questionId == questionId);
    responses[questionId] = question.createResponse(answer);
    notifyListeners();
  }

  /// Get the response for a specific question.
  Response? getResponse(String questionId) {
    return responses[questionId];
  }

  /// Get the number of questions answered.
  int get numberOfAnsweredQuestions => responses.length;

  /// Get the progress percentage of the form completion.
  double get completionPercentage => questions.isNotEmpty
      ? responses.length / questions.length
      : 0.0;
}
