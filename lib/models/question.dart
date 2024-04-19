import 'dart:io';

/// Represents an individual question found on a survey-like form that's 
/// created/modified by department staff, and doled out to students for 
/// collection of their results in an organized fashion
class Question { 
  /// used to control the ordering of the question when loaded on a form
  late int? ordinal;
  /// TODO: ask GPT/prof if late is appropriate approach for async data
  late String header;
  late String content;
  late bool res_required;
  
  /// Controls what widget will be shown to students when loaded
  late ResponseType _resFormat;
  
  /// (Optional) supplements the [content] ideally an IMG, PDF, etc.
  File? _linkedFile;

  /// Gets the desired format the response will be
  /// 
  /// ===TARGET_BLOCK_START===
  /// Something to ask GPT about:  
  /// Since the purpose of ResponseType is to succinctly convey
  /// the type of widget that this [Question] would show when 
  /// the parent Form is of type [StudentForm].
  /// ===TARGET_BLOCK_END===
  ResponseType get resFormat => _resFormat;

  /// Sets the format of the response
  set resFormat(ResponseType value) {
    _resFormat = value;
  }

  /// Gets the linked files of the question
  File? get linkedFile => _linkedFile;

  /// Sets which file (if any) is attached 
  set linkedFile(File? value) {
    _linkedFile = value;
  }
}

/// Used to represent the various formats that students wll be 
/// using to input their answers.  
/// This should include whatever we need to:
/// - (staff) supply the dropdown displayed for this question when loaded in FormEditor
/// - (student) tell the UI layer what widget to place in the Question
enum ResponseWidgetType {
  text,
  radio,
  checkbox,
  slider,
  dropdown
}