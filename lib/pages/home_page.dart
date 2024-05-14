import 'package:athlete_surveyor/models/forms/previous_forms_model.dart';
import 'package:athlete_surveyor/models/student_model.dart';
import 'package:athlete_surveyor/pages/staff/form_builder_page.dart';
import 'package:athlete_surveyor/pages/staff/students_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:athlete_surveyor/services/forms/secure_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage(
      {super.key, required this.displayName, required this.hasAdminPrivileges});
  final String displayName;
  final bool hasAdminPrivileges;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Welcome, $displayName',
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                hasAdminPrivileges
                    ? ElevatedButton(
                        // faculty
                        onPressed: () {
                          navigateToPage(
                              context,
                              Consumer<StudentsModel>(
                                  builder: (context, studentsModel, child) =>
                                      StudentsWidget(studentsModel)));
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.yellow)),
                        child: const SizedBox(
                            child: Center(
                                child: Text('View Forms',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center))))
                    : ElevatedButton(
                        //student
                        onPressed: null, //TODO
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.yellow)),
                        child: const SizedBox(
                            child: Center(
                                child: Text('Complete a Self-Inventory Survey',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center)))),
                Visibility(
                  visible: hasAdminPrivileges,
                  child: ElevatedButton(
                      onPressed: () async {
                        try {
                          var authoredFormsModel = 
                            Provider.of<AuthoredFormsModel>(context, listen: false);
                          /// TODO: adjust to use `tbl_sports`
                          // var newForm = await authoredFormsModel.createNewForm('Untitled Form', '[None]');
                          
                          print("Attempting to create new form...");
                          /// temporary inspectory debugging line
                          var newForm = await Provider.of<FormService>(listen: false, context)
                                              .createNewForm(formName: 'Test', sport: 'Test');
                          print("Form created with ID: ${newForm.formId}");

                          if (newForm != null && newForm.formId.isNotEmpty) {
                          /// push the existing form (if, for example, a previous form's thumnbnail was tapped)
                          /// otherwise send them there with a new one to be provided an ID on dbsubmittal
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            print(
                                '[HomePage]: Securely providing ${newForm.formId}');
                            return SecureFormProvider(
                                formId: newForm.formId,
                                hasAdminPrivileges: hasAdminPrivileges);
                          }));
                          } else {
                            print("Failed to create new form or formID was not set!");
                          }
                        } catch (e) {
                          print("Exception when trying to create a new form: $e");
                          }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow)),
                      child: const SizedBox(
                          width: 200,
                          height: 50,
                          child: Center(
                            child: Text('Create a Form',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ))),
                )
              ])
            ]));
  }
}
