// ignore_for_file: dangling_library_doc_comments

/// Name:
/// Date:
/// Description:
/// Bugs:
/// Reflection:

import 'package:athlete_surveyor/models/interfaces/i_question_respository.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/models/response_type.dart';
import 'package:athlete_surveyor/database.dart';

class QuestionRepository implements IQuestionRepository
{
  // Private constructor, facilitates safeguarded connection 
  QuestionRepository();

  /// 
  @override
  Future<Question> createQuestion(Question question, String formId) async 
  {
    var result = await Database.insertNewQuestionByFormId(question.content,
                                                  question.ordinal,
                                                  formId,
                                                  question.resFormat.widgetType); // Assuming you have an enum mapped to int

    if (result.isEmpty) { throw Exception('Failed to create question.'); }

    return _mapRowToQuestion(result.first.toColumnMap());
  }

  /// Removes a question from the database by its id. 
  @override
  Future<bool> deleteQuestion(String questionId) async 
  {
    // TODO: implement deleteQuestion
    var result = await Database.deleteQuestion(questionId);

    return result.isEmpty;
  }

  /// 
  @override
  Future<Question?> getQuestionById(String questionId) async 
  {
    // TODO: implement getQuestionById
    var result = await Database.fetchQuestionByQuestionId(questionId);

    return result.isEmpty ? null 
                          : _mapRowToQuestion(result.first.toColumnMap());
  }

  /// 
  @override
  Future<List<Question>> getQuestions() async 
  {
    // TODO: implement getQuestions
    var result = await Database.fetchAllQuestions();

    // Unpack the result by leveraging the row mapping function (since we have a List of Questions)
    return result.map((row) => _mapRowToQuestion(row.toColumnMap())).toList();
  }

  /// Fetches all of the questions that belong to a form, by their [formId].  
  /// TODO: migrate the `form_id` col from `tbl_questions` to a junc table `tbl_form_question`
  Future<List<Question>> resolveQuestionsByFormId({required String formId}) async 
  {
    var result = await Database.fetchQuestionsByFormId(formId);

    // Unpack the result by leveraging the row mapping function (since we have a List of Questions)
    return result.map((row) => _mapRowToQuestion(row.toColumnMap())).toList();
  }

  /// 
  @override
  Future<void> updateQuestion(Question question) async 
  {
    // TODO: implement updateQuestion
    var result = await Database.updateQuestion( question.content, 
                                                question.ordinal,
                                                question.formId,
                                                question.resFormat.widgetType,
                                                question.questionId);

    if (result.isEmpty) { throw Exception('Failed to update question.'); }
  }

/// called when saving the entire form
/// 
/// Removes all existing questions for a form, in order to re-add the newest ones (in [questions])
Future<void> updateFormQuestions({required List<Question> questions, required String formId}) async 
{
  // Remove existing questions for the form
  await Database.deleteFormById(formId);

  List<String> values = [];
  for (var question in questions) 
  {
    values.add("('${question.content}', ${question.ordinal}, '$formId', ${question.resFormat.widgetType})");
  }

  // Insert new questions for the form
  await Database.insertNewQuestions(values.join(", "));
}
}

/// 
Question _mapRowToQuestion(Map<String, dynamic> row) {
  return Question(
      questionId: row['question_id'],
      header: row['header'],
      content: row['content'],
      ordinal: row['order_in_form'],
      formId: row['form_id'],
      // resRequired: row['response_enum'] 
      resRequired: true,  /// TODO: implement later, hard-code to true for now
      resFormat: ResponseType(widgetType: row['response_enum']),
      linkedFileKey: row['linked_file_key'], // Assuming you store file references
    );

}