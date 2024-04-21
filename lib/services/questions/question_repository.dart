import 'package:athlete_surveyor/models/interfaces/i_question_respository.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/models/response_type.dart';
import 'package:athlete_surveyor/services/db.dart';
import 'package:postgres/postgres.dart';

class QuestionRepository implements IQuestionRepository{
  Future<Connection> get _connection async => await PostgresDB.connection;
  // final Connection _connection;
  // static QuestionRepository? _db_instance;

  // Private constructor, facilitates safeguarded connection 
  QuestionRepository();

  @override
  Future<Question> createQuestion(Question question, String formId) async {
    // TODO: implement createQuestion
    String sql = """INSERT INTO public.tbl_questions (content, order_in_form, form_id, response_enum
                        VALUES (@content, @order, @formId, @responseEnum) 
                        RETURNING *;""";
    var db = await _connection; /// get the static connection
    var result = await db.execute(
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


  /// Removes a question from the database by its id. 
  @override
  Future<bool> deleteQuestion(String questionId) async {
    // TODO: implement deleteQuestion
    String sqlStatement = """DELETE * FROM public.tbl_questions WHERE question_id LIKE @questionId;""";
    var db = await _connection; /// get the static 
    var result = await db.execute(sqlStatement, parameters: questionId);
    if (result.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<Question?> getQuestionById(String questionId) async {
    // TODO: implement getQuestionById
    String sqlStatement = """SELECT content, order_in_form, form_id, question_id, response_enum
                            FROM public.tbl_questions WHERE question_id LIKE @questionId;""";
    var db = await _connection; /// get the static connection
    var result = await db.execute(sqlStatement, parameters: questionId);
    if (result.isEmpty) {
      return null;
    } else {
      return _mapRowToQuestion(result.first.toColumnMap());
    }
  }

  @override
  Future<List<Question>> getQuestions() async {
    // TODO: implement getQuestions
    String sqlStatement = """SELECT * FROM tbl_questions""";
    var db = await _connection; /// get the static connection
    var result = await db.execute(sqlStatement);
      
    /// unpack the result by leveraging the row mapping function
    return result.map((row) => _mapRowToQuestion(row.toColumnMap())).toList();
  }

  @override
  Future<void> updateQuestion(Question question) async {
    // TODO: implement updateQuestion
    String sqlStatement = """UPDATE public.tbl_questions
                            SET content = @content, order_in_form = @order,
                                form_id = @formId, response_enum = @responseEnum
                            WHERE question_id = @questionId;""";
var db = await _connection; /// get the static connection
    var result = await db.execute(      
      Sql.named(sqlStatement),
      parameters: {
        'content': question.content,
        'order': question.ordinal,
        'formId': question.formId,
        'responseEnum': question.resFormat.widgetType,
        'questionId': question.questionId,
      },
    );
    if (result.isEmpty) {
      throw Exception('Failed to update question.');
    }
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