import 'package:athlete_surveyor/models/interfaces/i_question_respository.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/models/response_type.dart';
import 'package:postgres/postgres.dart';

class QuestionRepository implements IQuestionRepository{
  
  final Connection _connection;
  static QuestionRepository? _db_instance;

  // Private constructor, facilitates safeguarded connection 
  QuestionRepository._internal(this._connection);

  static QuestionRepository getInstance(Connection conn) {
    _db_instance ??= QuestionRepository._internal(conn);
    return _db_instance!;
  }

  @override
  Future<Question> createQuestion(Question question, String formId) async {
    // TODO: implement createQuestion
    String sql = """INSERT INTO public.tbl_questions (content, order_in_form, form_id, response_enum
                        VALUES (@content, @order, @formId, @responseEnum) 
                        RETURNING *;""";

    var result = await _connection.execute(
      Sql.named(sql), parameters: {
      'content': question.content,
      'order': question.ordinal,
      'formId': formId,
      'responseEnum': question.resFormat.widgetType // Assuming you have an enum mapped to int
    });

    if (result.isEmpty) {
      throw Exception('Failed to create question.');
    }
    return _mapRowToQuestion(result.first.toColumnMap());
  }

  @override
  Future<void> deleteQuestion(String questionId) {
    // TODO: implement deleteQuestion
    throw UnimplementedError();
  }

  @override
  Future<Question?> getQuestionById(String questionId) {
    // TODO: implement getQuestionById
    throw UnimplementedError();
  }

  @override
  Future<List<Question>> getQuestions() {
    // TODO: implement getQuestions
    throw UnimplementedError();
  }

  @override
  Future<void> updateQuestion(Question question) {
    // TODO: implement updateQuestion
    throw UnimplementedError();
  }

}

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