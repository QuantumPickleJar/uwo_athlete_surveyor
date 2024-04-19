import 'dart:io';
import 'package:athlete_surveyor/models/response_type.dart';

/// Represents an individual question found on a survey-like form that's 
/// created/modified by department staff, and doled out to students for 
/// collection of their results in an organized fashion
class Question { 
  /// used to control the ordering of the question when loaded on a form
  late int? ordinal;
  /// TODO: ask GPT/prof if late is appropriate approach for async data
  late String header;   /// TODO: this should default to the ordinal
  late String content;
  late bool res_required;
  
  /// Controls what widget will be shown to students when loaded
  late ResponseType _resFormat;
  
  /// (Optional) supplements the [content] ideally an IMG, PDF, etc.
  File? _linkedFile;

  /// Gets the desired format the response will be
  ResponseType get resFormat => _resFormat;

  /// Sets the format of the response
  set resFormat(ResponseType value) {
    _resFormat = value;
  }

  /// If there is a file associated with this question, fetch it
  File? get linkedFile => _linkedFile;

  /// Sets which file (if any) is attached 
  set linkedFile(File? value) {
    _linkedFile = value;
  }
}

