/// Describes the response type for a question.  To allow enhanced flexibility, 
/// custom parameters can be passed via [config] to:
/// - pass validation rules, perhaps for a TextField
/// - specify the answers for list-likes ([dropdown], [checkbox], [radio])
/// - more to come, maybe
class ResponseType {
  /// specifies how a question whould be rendered to students via UI
  final ResponseWidgetType widgetType;

  /// an optional set of information that can be supplied, to be implemented
  /// TODO: implement when more concerete is done
  final Map<String, dynamic> config;

  ResponseType({required this.widgetType, this.config = const {}});

  /// Returns the default value of the [ResponseWidgetType] enum, which is `text`.
  static ResponseType getDefaultWidgetType() {
    //return ResponseWidgetType.text;
    return ResponseType(widgetType: ResponseWidgetType.text);
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