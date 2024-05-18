import 'package:flutter/material.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/models/response.dart';

/// Model representing an individual student, including their details
/// and the form they are currently taking, along with their responses.
class StudentModel extends ChangeNotifier {
  final String name;
  final String grade;
  final String sport;
  final List<Question> questions;
  final Map<String, Response> responses = {};

  StudentModel({
    required this.name,
    required this.grade,
    required this.sport,
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
