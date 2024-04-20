import 'dart:io';
import 'package:uuid/uuid.dart';

/// The base Form object that is loaded full of content via one of 
/// our services yet to be implemented. 
abstract class IGenericForm {
  /// getter syntax, enforcing use of a concrete implementation
  String get formName;  
  String get sport;
  List<File>? attachments; 

  /// Save changes/answers to the current form 
  /// TODO: Evaluate removal. could be that this is equivalent to FormService.updateForm)
  void saveForm(); 

  /// Perform something with the form's dat
  void loadForm(Uuid formUuid);
  
  // void getDraftIfExists(Uuid formUuid);
  /// May not need this one, keeping for now
  // bool validateForm();
}