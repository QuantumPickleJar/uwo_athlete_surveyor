import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/forms/staff_form.dart';
import 'package:athlete_surveyor/models/forms/student_form.dart';
import 'package:athlete_surveyor/pages/staff/form_builder_page.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
    
/// Acts as an in-between for Student and Staff alike, so that 
/// whenever either of them needs to interact with a form, the
/// [SecureFormProvider] will check the user's role in the DB
/// and use that to determine what page we take the user to.
class SecureFormProvider extends StatelessWidget {
  final String formId;
  final bool hasAdminPrivileges;
  const SecureFormProvider({ super.key, required this.formId, required this.hasAdminPrivileges});
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GenericForm>(
      future: _loadFormByUserRole(context, formId), /// TODO: may be a call to userservice
      builder: (context, snapshot) {
        /// TODO: check if user is logged in here
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          /// handle errors in a visuale manner before rendering loading progress
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          /// only render to Consumer if data is present
          return ChangeNotifierProvider<GenericForm>.value(
            value: snapshot.data!,
            child: Consumer<GenericForm>(builder: (context, form, child) {
            /// TODO: implement student survey page
            return (form is StaffForm) ? 
                FormBuilderPage(formId: formId) : throw UnimplementedError("The form type is not supported yet.");
          })
        );
        } 
        /// edge case:  no error, no data, and not waiting (shouldn't be possible, but safe to cover)
          return const Text('Unexpected state');
      }, 
    );
  }
  
  /// returns the appropriate form based on the 
  Future<GenericForm> _loadFormByUserRole(BuildContext context, String formId) async {
    // TEMPORARY HARD-CODED
    /// reach up the widget tree to get [FormService]
    FormService formService = Provider.of<FormService>(context, listen: false);

    /// TODO: check loggedInUser 

     // This should be determined based on the user's logged-in status
    if (hasAdminPrivileges) {
      var form = await formService.fetchOrCreateForm(formId: formId);
      return StaffForm.fromGenericForm(form, questions: []);
      // return StaffForm(...); // Provide necessary parameters
    } else { 
      /// TODO: implement StudentForm.fromGenericForm
      throw new UnimplementedError();
    }
    /*
    else {
      // Fetch details required to instantiate StudentForm
      // return StudentForm(...); // Provide necessary parameters
    }
    return isAdmin;
    */
  }
}