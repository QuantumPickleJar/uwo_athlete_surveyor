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
  const SecureFormProvider({ Key? key, required this.formId }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GenericForm>(
      future: _loadFormByUserRole(context, formId), /// TODO: may be a call to userservice
      builder: (context, snapshot) {
        /// TODO: check if user is logged in here
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return Provider<GenericForm>.value(
            value: snapshot.data!,
            child: Consumer<GenericForm>(builder: (context, form, child) {
            /// TODO: implement student survey page
            return (form is StaffForm) ? 
                FormBuilderPage(formId: formId) : 
                throw UnimplementedError();
          })
        );
        /// handle errors in a visuale manner before rendering loading progress
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // TODO: resize, spans entire screen
          return CircularProgressIndicator();
        }
      }, 
    );
  }
  
  /// returns the appropriate form based on the 
  Future<GenericForm> _loadFormByUserRole(BuildContext context, String formId) async {
    // TEMPORARY HARD-CODED
    bool isAdmin = true; // This should be determined based on the user's logged-in status
    /// reach up the widget tree to get [FormService]
    FormService formService = Provider.of<FormService>(context, listen: false);

    /// TODO: check loggedInUser 

    if (isAdmin) {
      var form = await formService.fetchOrCreateForm(formId: formId);
      return StaffForm.fromGenericForm(form, questions: []);
      // return StaffForm(...); // Provide necessary parameters
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