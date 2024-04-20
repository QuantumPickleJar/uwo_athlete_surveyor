
import 'package:athlete_surveyor/models/interfaces/i_generic_form.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';
import 'forms/student_form.dart';

/// Abstracts the logic away from the client, allowing a more dynamic form 
/// creation process at runtime.
///
abstract class FormFactory {
  /// After loading form's [content], a student will be providing response 
  /// data, which we'll collect as `Response` objects.  
  IGenericForm createStudentForm({required String formName});

  /// After loading form's [content], pump into form_editor_page and do 
  /// whatever is needed for entering edit mode for the form in question.
  // IGenericForm createStaffForm({required String formName});
  
}

// Concrete factory implementing the abstract factory
class ConcreteFormFactory extends FormFactory {
  final _uuid = const Uuid(); // field to generate the uuid when produced

  @override
  IGenericForm createStudentForm({required String formName}) {
    // get the UUID
    String newUuid = _uuid.v4();
    return StudentForm(
      formId: newUuid,
      formName: formName,
      sport: "",
      /// TODO: change below line, this is dirty code
      formDateReceived: DateTime.now(), /// should be read from the spreadsheet
      formDateCompleted: null
    );
  }

  // @override
  // IGenericForm createStaffForm({required String name}) => StaffForm(
  //   return StaffF
  // );
}