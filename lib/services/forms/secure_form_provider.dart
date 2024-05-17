// ignore_for_file: dangling_library_doc_comments, avoid_print

/// Name:
/// Date:
/// Description:
/// Bugs:
/// Reflection:

import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/forms/staff_form.dart';
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
      future: _loadFormByUserRole(context, formId),
      builder: (context, snapshot) {
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
              if (form is StaffForm) {
                // Ensure formId is passed correctly
                return FormBuilderPage(formId: form.formId); 
              } else {
                return const Text('Unsupported form type encountered.');
              }
            
              // return (form is StaffForm) ? 
              // FormBuilderPage(formId: formId) : 
              // throw UnimplementedError("The form type is not supported yet.");
          })
        );
        } 
        /// edge case:  no error, no data, and not waiting (shouldn't be possible, but safe to cover)
          return const Text('No data available for this form.');
      }, 
    );
  }
  
  /// returns the appropriate form based on the 
  Future<GenericForm> _loadFormByUserRole(BuildContext context, String formId) async {
    // TEMPORARY HARD-CODED
    /// reach up the widget tree to get [FormService]
    FormService formService = Provider.of<FormService>(context, listen: false);


     // This should be determined based on the user's logged-in status
    if (hasAdminPrivileges) {
      // var form = await formService.fetchOrCreateForm(formId: formId);
      try {  
        GenericForm? form = await formService.getFormById(formId);

        /// ensure the form is valid before trying to load it as a [StaffForm]
        if (form != null && form.formId.isNotEmpty) { 
          print("Form loaded successfully: ${form.formId}");
          return StaffForm.fromGenericForm(form);
        }
        print("Failed to load form: form is null or formId is empty.");
        throw Exception('The form failed to load or was not found (Id: $formId)');
        // return Future<GenericForm>.error('The form failed to load (Id: $formId)');    
      } catch (e) { 
        print("Exception caught in _loadFormByUserRole: $e");
        rethrow; // This will allow you to see where exactly the null is occurring.
      }
    } else { 
      throw UnimplementedError('StudentForm not yet implemented (SFP)');
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