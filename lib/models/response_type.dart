/// Describes the response type for a question.  To allow enhanced flexibility, 
/// custom parameters can be passed via [config] to:
/// - pass validation rules, perhaps for a TextField
/// - specify the answers for list-likes ([dropdown], [checkbox], [radio])
/// - more to come, maybe
class ResponseType {
  /// specifies how a question whould be rendered to students via UI
  final ResponseType widgetType;

  /// an optional set of information that can be supplied, to be implemented
  /// TODO: implement when more concerete is done
  final Map<String, dynamic> config;

  ResponseType({required this.widgetType, this.config = const {}});
}