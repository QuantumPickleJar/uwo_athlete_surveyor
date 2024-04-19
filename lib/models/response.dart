/// Defines a student's response to a Question object.  
/// Since the form of their response will vary, we call 
/// it the generic type T.
///
import 'question.dart';
import 'response_type.dart';

class Response<T> {
  /// The Id of the Question that this [Response] is tied to
  final String questionId;

  /// The student's response that was submitted for a given Question
  T answer;
  
  /// how to represent this answer; set from the [Question]
  final ResponseType responseType;
  
  /// Constructs a new [Response] that uses [T] to store whatever the
  /// student used to answer the question with id [questionId].
  Response({ 
    required this.questionId, 
    required this.answer,
    required this.responseType
  });

  /// Creates a response wrapping [answer] based on the [responseType]
  static Response<dynamic> fromAnswer(Question question, dynamic answer) {
    // TODO: conditionally format based on question.resFormat
    
    return Response<dynamic>(
      questionId: question.questionId,
      answer: answer,
      responseType: question.resFormat
    );
  }

}