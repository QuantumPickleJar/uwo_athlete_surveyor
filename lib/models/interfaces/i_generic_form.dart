import 'dart:io';
import 'package:uuid/uuid.dart';

/// The base Form object that is loaded full of content via one of 
/// our services yet to be implemented. 
abstract class IGenericForm {
  /// getter syntax, enforcing use of a concrete implementation
  String get formName;  
  String get sport;
  String get formId;  // should be performed with UUID functions
  List<File>? attachments; 

  /// Save changes/answers to the current form 
  /// TODO: Evaluate removal. could be that this is equivalent to FormService.updateForm)
  void saveForm(); 
  
  // void getDraftIfExists(Uuid formUuid);
}