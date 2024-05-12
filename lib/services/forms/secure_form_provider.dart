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
  late FormService formService;
  SecureFormProvider({ super.key, required this.formId });
  
  @override
  Widget build(BuildContext context) {
    /// finish instantiating [formService] so we can use it
    formService = Provider.of<FormService>(context);

    return FutureBuilder<GenericForm>(
      future: _loadFormByUserRole(context, formId: formId), /// TODO: may be a call to userservice
      builder: (context, snapshot) {
        /// TODO: check if user is logged in here
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(height: 25, width: 25, child: CircularProgressIndicator())
            );
        } else if (snapshot.hasError) {
          /// handle errors in a visuale manner before rendering loading progress
          return Center(child: Text('SecFormProv Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          /// only render to Consumer if data is present
          return ChangeNotifierProvider<GenericForm>.value(
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
          return const CircularProgressIndicator();
        }
      }, 
    );
  }
  
  /// returns the appropriate form based on the 
  Future<GenericForm> _loadFormByUserRole(BuildContext context, {required String formId}) async {
    // TEMPORARY HARD-CODED
    /// reach up the widget tree to get [FormService]

    /// TODO: check loggedInUser 

    if (isAdmin) {
      /// Sanity check this: why would formId everr be null;?
      var form = await formService.fetchOrCreateForm(formId: formId);
      if (formId.isEmpty) {
        print("CRITICAL OCCURENCE: formService returned an empty formId on fetchOrCreateForm!");
        
        /// targeted for removal
        return StaffForm.fromGenericForm(form, questions: questions);
      }
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