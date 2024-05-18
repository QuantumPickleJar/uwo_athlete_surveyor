  import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
  import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/pages/form_taker_page.dart';
  import 'package:athlete_surveyor/pages/staff/form_builder_page.dart';
  import 'package:athlete_surveyor/resources/common_functions.dart';
  import 'package:flutter/material.dart';
      
  /// Widget used to render the forms that have been either CREATED or 
  /// ASSIGNED to the given user (determined by reading [hasAdminPrivileges]).
  /// This should be used on the `previous_forms_page`.
  class FormTileWidget extends StatelessWidget {
    final GenericForm form;
    // final LoggedInUser currentUser;
    final bool hasAdminPrivileges;
    final VoidCallback onTap;

    const FormTileWidget({
      super.key,
      required this.form,
      required this.hasAdminPrivileges,
      required this.onTap
    });

    @override
    Widget build(BuildContext context) {
      return ListTile(
        title: Text(form.formName),
        onTap: onTap
      );
    }
  }
