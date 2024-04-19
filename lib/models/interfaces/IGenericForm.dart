import 'package:uuid/uuid.dart';

abstract class IGenericForm {
  /// Save changes/answers to the current form
  void saveForm(); 

  /// Perform something with the form's dat
  void loadForm(Uuid formUuid);
  
  /// May not need this one, keeping for now
  // bool validateForm();
}