// ignore_for_file: dangling_library_doc_comments

/// Name:
/// Date:
/// Description:
/// Bugs:
/// Reflection:

import 'package:athlete_surveyor/models/response_type.dart';
import 'response.dart';

/// Represents an individual question found on a survey-like form that's 
/// created/modified by department staff, and doled out to students for 
/// 
/// collection of their results in an organized fashion
class Question { 
  late String formId;
  String questionId;
  late String header;
  late String content;
  late bool resRequired;
  /// Controls what widget will be shown to students when loaded
  late ResponseType resFormat;
  
  /// used to control the ordering of the question when loaded on a form
  late int? ordinal;
  
  /// (Optional) If not null, the key of sorts specifying which of the form's
  /// attached files will show in the [content] (ideally an IMG, PDF, etc.)
  String? linkedFileKey;
  /// File? linkedFile;


  Question({
    required this.formId,
    required this.questionId,
    required this.ordinal, 
    required this.header,
    required this.content,
    required this.resRequired,
    required this.resFormat,
    this.linkedFileKey
  });

  /// Creates a [Response] by passing [answer] through the [Question] without 
  /// needing to know what [resFormat]. 
  Response<dynamic> createResponse(dynamic answer) {

    return Response<dynamic>(
      questionId: "TEST_ID",
      answer: answer,
      responseType: resFormat
    );
  }
}

