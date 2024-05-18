import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/models/create_user_model.dart';
import 'package:athlete_surveyor/models/students_model.dart';
import 'package:athlete_surveyor/pages/staff/create_user_page.dart';
import 'package:athlete_surveyor/pages/staff/students_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:athlete_surveyor/resources/constant_values.dart' as constants;
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:athlete_surveyor/services/forms/secure_form_provider.dart';
import 'package:athlete_surveyor/widgets/create_form_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage(
      {super.key, required this.displayName, required this.currentUser});
  final String displayName;
  final LoggedInUser currentUser;
  // final bool hasAdminPrivileges;

  /// Prework for navigation to SecureFormProvider page, followed by the navigation itself.
  void navigateToNewFormPage(BuildContext context) async {
    var formService = Provider.of<FormService>(context, listen: false);
    /// TODO: hook into sports from [SportsPickerDialog]
    var newForm = await formService.createNewForm(formName: 'New Form', sport: 'unselected sport');
    if (context.mounted) {
      navigateToPage(
          context,
          SecureFormProvider(formId: newForm.formId, currentUser: ,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(constants.defaultEdgeInsetsPadding),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Welcome, $displayName',
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                toggleVisibleButton(
                    visibilityToggle: hasAdminPrivileges,
                    onPressed: () {
                      navigateToPage(
                          context,
                          Consumer<CreateUserModel>(
                              builder: (context, createUserModel, child) =>
                                  CreateUserPage(createUserModel)));
                    },
                    buttonText: constants.createNewUserString),
                hasAdminPrivileges
                    ? ElevatedButton(
                        /// : Faculty
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
                        /// Student
                        onPressed: () {
                          null;
                        }, //TODO
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.yellow)),
                        child: const SizedBox(
                            child: Center(
                                child: Text('Complete a Self-Inventory Survey',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                              ),
                            )
                        ),
                Visibility(
                  visible: hasAdminPrivileges,
                  child: CreateFormButton(hasAdminPrivileges: hasAdminPrivileges))
                // toggleVisibleButton(
                //     visibilityToggle: hasAdminPrivileges,
                //     onPressed: () async {
                //       navigateToNewFormPage(context);
                //     },
                //     buttonText: 'Create a Form'
                // );
              ])
            ]));
  }
}
