import 'package:flutter/foundation.dart';

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

  /// Returns the hash code for this [ResponseType] object.
  ///
  /// The hash code is computed by combining the hash codes of [widgetType] and [config].
  /// This ensures that objects with the same [widgetType] and [config] have the same hash code.
@override int get hashCode => widgetType.hashCode ^ config.hashCode;
  


/// Overrides the equality operator to compare two [ResponseType] objects.
///
/// Returns `true` if the [other] object is an instance of [ResponseType] and
/// has the same runtime type, [widgetType], and [config] as this object.
/// Otherwise, returns `false`.
@override
bool operator ==(Object other) => 
  identical(this, other) || other is ResponseType &&
      this == other.runtimeType && 
      widgetType == other.widgetType &&
      mapEquals(config, other.config);
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