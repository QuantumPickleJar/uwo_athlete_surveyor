// ignore_for_file: dangling_library_doc_comments

/// Name:
/// Date:
/// Description:
/// Bugs:
/// Reflection:

import "package:athlete_surveyor/models/question.dart";

/// Question repository interface
abstract class IQuestionRepository {
  /// Creates a [question] to be associated with the form with id [formId]
  Future<Question> createQuestion(Question question, String formId);

  Future<Question?> getQuestionById(String questionId);

  Future<List<Question>> getQuestions();

  Future<void> updateQuestion(Question question);
  
  Future<void> deleteQuestion(String questionId);
}