// ignore_for_file: dangling_library_doc_comments

/// Name:
/// Date:
/// Description:
/// Bugs:
/// Reflection:

import 'dart:io';

/// The base Form object that is loaded full of content via one of 
/// our services yet to be implemented. 
abstract class IGenericForm {
  /// getter syntax, enforcing use of a concrete implementation
  String get formName;  
  String get sport;
  String get formId;  // should be performed with UUID functions
  List<File>? attachments; 

  /// Save changes/answers to the current form 
  void saveForm(); 
  
  // void getDraftIfExists(Uuid formUuid);
}