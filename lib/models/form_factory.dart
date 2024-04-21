
import 'package:athlete_surveyor/models/interfaces/i_generic_form.dart';
import 'package:uuid/uuid.dart';
import 'forms/student_form.dart';
import 'forms/staff_form.dart';

/// Abstracts the logic away from the client, allowing a more dynamic form 
/// creation process at runtime.
///
abstract class FormFactory {
  /// After loading form's [content], a student will be providing response 
  /// data, which we'll collect as `Response` objects.  
  IGenericForm createStudentForm({required String formName});

  /// After loading form's [content], pump into form_editor_page and do 
  /// whatever is needed for entering edit mode for the form in question.
  IGenericForm createStaffForm({required String formName, required String? sport});
  
}

// Concrete factory implementing the abstract factory
class ConcreteFormFactory extends FormFactory {
  @override
  IGenericForm createStudentForm({required String formName}) {
    return StudentForm(
      formId: '',
      formName: formName,
      sport: 'test student sport',  // get from service?
      /// TODO: change below line, this is dirty code
      formDateReceived: DateTime.now(), /// should be read from the spreadsheet
      formDateCompleted: null,
      questions: []
    );
  }


  /// A staff member does not complete forms, so they only see [formDateCreated]
  @override
  IGenericForm createStaffForm({required String formName, String? sport, DateTime? formDateCreated}) {
    return StaffForm(
      formId: '',
      formName: formName,
      formDateCreated: formDateCreated ?? DateTime.now(),
      sport: sport ?? "test sport",
      attachments: [],
      List.empty()
    );
  }
}