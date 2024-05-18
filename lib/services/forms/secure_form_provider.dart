import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/forms/staff_form.dart';
import 'package:athlete_surveyor/models/forms/student_form.dart';
import 'package:athlete_surveyor/pages/form_taker_page.dart';
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
  const SecureFormProvider({Key? key, required this.formId, required this.hasAdminPrivileges});
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GenericForm>(
      future: _loadFormByUserRole(context, formId), /// TODO: may be a call to userservice
      builder: (context, snapshot) {
        /// TODO: check if user is logged in here
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(height: 25, width: 25, child: CircularProgressIndicator())
            );
        } else if (snapshot.hasError) {
          /// handle errors in a visuale manner before rendering loading progress
          return Center(child: Text('SFP Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          /// only render to Consumer if data is present
          return ChangeNotifierProvider<GenericForm>.value(
            value: snapshot.data!,
            child: Consumer<GenericForm>(builder: (context, form, child) {
            /// TODO: implement student survey page
                 return form is StaffForm ? 
                 FormBuilderPage(formId: formId) : 
                 FormTakerPage(questions: form.questions);                //  FormTakerPage();
          })
        );
        /// handle errors in a visuale manner before rendering loading progress
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else { // TODO: resize, spans entire screen
          return CircularProgressIndicator();
        }
      }, 
    );
  }
  
  /// returns the appropriate form based on the 
  Future<GenericForm> _loadFormByUserRole(BuildContext context, String formId) async {
    /// reach up the widget tree to get [FormService]
    FormService formService = Provider.of<FormService>(context, listen: false);
    if (hasAdminPrivileges) {
        GenericForm? form = await formService.getFormById(formId);
        /// ensure the form is valid before trying to load it as a [StaffForm]
        
        if (form != null && form.formId.isNotEmpty) { 
          debugPrint("[SFP] Form loaded successfully: ${form.formId}");
          /// this seems weird
          return StaffForm.fromGenericForm(form);
        } else {
          debugPrint("[SFP] Failed to load form: form is null or formId is empty.");
        }
      } else {
      /// load the form by its id, and load it into the generic form
      GenericForm? form = await formService.getFormById(formId);
        if (form != null && form.formId.isNotEmpty) { 
        return StudentForm.fromGenericForm(form);
      } else {
        debugPrint("[SFP] Failed to load form: form is null or formId is empty.");
        throw Exception('The form failed to load or was not found (Id: $formId)');
      }
    }
    return Future<GenericForm>.error('[SFP]The form failed to load (Id: $formId)');    
  }
}