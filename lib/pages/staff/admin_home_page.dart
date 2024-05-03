import 'package:athlete_surveyor/models/forms/staff_form.dart';
import 'package:athlete_surveyor/models/student_model.dart';
import 'package:athlete_surveyor/pages/staff/form_builder_page.dart';
import 'package:athlete_surveyor/pages/staff/students_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:athlete_surveyor/services/forms/secure_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text('Welcome, [NAME]',
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight
                    .bold)), //TODO: replace [NAME] with actual data pulled from login.
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
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
                        width: 200,
                        height: 50,
                        child: Center(
                            child: Text('View Student Forms',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)))))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () async { 
                    var formService = Provider.of<FormService>(context, listen: false);
                    var newForm = await formService.createNewForm('NewForm', 'Sport');
                    print(newForm.formId);
                    /// push the existing form (if, for example, a previous form's thumnbnail was tapped)
                    /// otherwise send them there with a new one to be provided an ID on dbsubmittal 
                    Navigator.of(context).push(MaterialPageRoute(builder: 
                      // (context) => FormBuilderPage(formId: newForm.formId)
                        (context) => SecureFormProvider(formId: newForm.formId)
                      ));
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                                  )))
            )
          ],
        )
      ],
    );
  }
}
