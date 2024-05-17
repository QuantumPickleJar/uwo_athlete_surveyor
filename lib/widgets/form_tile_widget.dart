import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/pages/staff/form_builder_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:flutter/material.dart';
    
class FormTileWidget extends StatelessWidget {
  final GenericForm form;
  final LoggedInUser currentUser;

  const FormTileWidget({
    super.key,
    required this.form,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(form.formName),
      onTap: () {
        // Staff users should be taken to [FormBuilderPage]
        if (currentUser.hasAdminPrivileges) {
          navigateToPage(
            context,
            FormBuilderPage(formId: form.formId),
          );
        } else {
          navigateToPage(
            context,
            IndividualFormWidget(
              form.formName,
              form.sport,
              IndividualFormExaminationModel(),
            ),
          );
        }
      },
    );
  }
}
