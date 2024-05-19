class FormRequest {
  final String formId;
  final String requestId;
  final String requestingUserId;
  final DateTime createDate;

  FormRequest({
    required this.formId,
    required this.requestId,
    required this.requestingUserId,
    required this.createDate,
  });

  factory FormRequest.fromJson(Map<String, dynamic> json) {
    return FormRequest(
      formId: json['form_id'],
      requestId: json['request_id'],
      requestingUserId: json['requesting_user_id'],
      createDate: DateTime.parse(json['create_date']),
    );
  }
}
