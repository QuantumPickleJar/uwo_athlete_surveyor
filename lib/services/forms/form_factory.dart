
import 'package:athlete_surveyor/models/interfaces/IGenericForm.dart';

abstract class FormFactory {
  /// After loading the form's [content], a 
  IGenericForm createStudentForm();

  IGenericForm createStaffForm();
  
}