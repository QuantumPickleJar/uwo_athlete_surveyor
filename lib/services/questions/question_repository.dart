import 'package:athlete_surveyor/models/interfaces/i_question_respository.dart';
import 'package:athlete_surveyor/models/question.dart';
import 'package:athlete_surveyor/models/response_type.dart';
import 'package:athlete_surveyor/services/db.dart';
import 'package:postgres/postgres.dart';

class QuestionRepository implements IQuestionRepository{
  Future<Connection> get _connection async => await PostgresDB.getConnection();
  // final Connection _connection;
  // static QuestionRepository? _db_instance;

  // Private constructor, facilitates safeguarded connection 
  QuestionRepository();

  @override
  Future<Question> createQuestion(Question question, String formId) async {
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
    try {
      String sqlStatement = """DELETE * FROM public.tbl_questions WHERE question_id = @questionId;""";
      var db = await _connection; /// get the static 
      var result = await db.execute(sqlStatement, parameters: { 'questionId' : questionId});
      if (result.isEmpty) {
        return false;
      } else {
        return true;
      }
    } finally {
      PostgresDB.closeConnection();
    }
  }

  @override
  Future<Question?> getQuestionById(String questionId) async {
    try {
      String sqlStatement = """SELECT content, order_in_form, form_id, question_id, response_enum
                              FROM public.tbl_questions WHERE question_id = @questionId;""";
      var db = await _connection; /// get the static connection
      var result = await db.execute(sqlStatement, parameters: { 'questionId' : questionId});
      if (result.isEmpty) {
        return null;
      } else {
        return _mapRowToQuestion(result.first.toColumnMap());
      }
    } finally {
      PostgresDB.closeConnection();
    }
  }

  @override Future<List<Question>> getQuestions() async {
    try {
      String sqlStatement = """SELECT * FROM tbl_questions""";
      var db = await _connection; /// get the static connection
      var result = await db.execute(sqlStatement);
        
      /// unpack the result by leveraging the row mapping function (since we have a List of Questions)
      return result.map((row) => _mapRowToQuestion(row.toColumnMap())).toList();
    } finally {
      PostgresDB.closeConnection();
    }
  }

  /// Fetches all of the questions that belong to a form, by their [formId].  
  /// TODO: migrate the `form_id` col from `tbl_questions` to a junc table `tbl_form_question`
  Future<List<Question>> resolveQuestionsByFormId({required String formId}) async {
    try {
      String sqlStatement = """SELECT * from tbl_questions WHERE form_id = @formId""";
      //   String sqlStatement = """SELECT content, order_in_form, form_id, question_id, response_enum
      //                        FROM public.tbl_questions WHERE question_id = @questionId;""";
      var db = await _connection; /// get the static connection
      var result = await db.execute(Sql.named(sqlStatement), parameters: { 'formId': formId });
        
      /// unpack the result by leveraging the row mapping function (since we have a List of Questions)
      return result.map((row) => _mapRowToQuestion(row.toColumnMap())).toList();
    } finally {
      PostgresDB.closeConnection();
    }
  }


  @override
  Future<void> updateQuestion(Question question) async {
    try {
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
    }  finally {
      PostgresDB.closeConnection();
    }
  }

/// called when saving the entire form
/// 
/// Removes all existing questions for a form, in order to re-add the newest ones (in [questions])
Future<void> updateFormQuestions({required List<Question> questions, required String formId}) async {
  try {
    var db = await _connection; /// get the static connection

    // Remove existing questions for the form
    String deleteSql = "DELETE FROM public.tbl_questions WHERE form_id = @formId";
    await db.execute(deleteSql, parameters: {'formId': formId});

    // Insert new questions for the form
    String insertSql = "INSERT INTO public.tbl_questions (content, order_in_form, form_id, response_enum) VALUES ";
    List<String> values = [];
    for (var question in questions) {
      values.add("('${question.content}', ${question.ordinal}, '$formId', ${question.resFormat.widgetType})");
    }
    insertSql += values.join(", ");
    await db.execute(insertSql);
  } finally {
    PostgresDB.closeConnection();
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
