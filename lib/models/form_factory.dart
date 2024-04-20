
import 'package:athlete_surveyor/models/interfaces/IGenericForm.dart';
import 'student_form.dart';

/// Abstracts the logic away from the client, allowing a more dynamic form 
/// creation process at runtime.
///
abstract class FormFactory {
  /// After loading form's [content], a student will be providing response 
  /// data, which we'll collect as `Response` objects.  
  IGenericForm createStudentForm();

  /// After loading form's [content], pump into form_editor_page and do 
  /// whatever is needed for entering edit mode for the form in question.
  // IGenericForm createStaffForm();
  
}

// Concrete factory implementing the abstract factory
class ConcreteFormFactory extends FormFactory {
  @override
  IGenericForm createStudentForm({required String name}) => StudentForm(
    formName: name,
    sport: "",
    /// TODO: change below line, this is dirty code
    formDateReceived: DateTime.now(), /// should be read from the spreadsheet
    formDateCompleted: null
    );


  // @override
  // IGenericForm createStaffForm({required String name}) => StaffForm(
  //   return StaffF
  // );
}