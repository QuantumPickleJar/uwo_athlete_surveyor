import "package:athlete_surveyor/models/question.dart";

// Question repository interface
abstract class IQuestionRepository {
  Future<Question> createQuestion(Question question);
  Future<Question?> getQuestionById(String questionId);
  Future<List<Question>> getQuestions();
  Future<void> updateQuestion(Question question);
  Future<void> deleteQuestion(String questionId);
}