import 'package:uuid/uuid.dart';

/// The base Form object that is loaded full of content via one of 
/// our services yet to be implemented. 
abstract class IGenericForm {
  /// getter syntax, enforcing use of a concrete implementation
  String get formName;  
   
  /// Save changes/answers to the current form
  void saveForm(); 

  /// Perform something with the form's dat
  void loadForm(Uuid formUuid);
  
  // void getDraftIfExists(Uuid formUuid);
  /// May not need this one, keeping for now
  // bool validateForm();
}