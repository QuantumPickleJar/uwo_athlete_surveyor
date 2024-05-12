import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/models/forms/individual_form_examination_model.dart';
import 'package:athlete_surveyor/models/forms/previous_forms_model.dart';
import 'package:athlete_surveyor/pages/individual_form_examination_page.dart';
import 'package:athlete_surveyor/pages/staff/form_builder_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Page used to display to the user any [GenericForm]-type entities that
/// have been contextually "assigned" to the user.
/// The user can be either a student or a staff member.
/// It is important to distinguish between the two when displaying the forms on the screen
class MyFormsPage extends StatelessWidget {
  final LoggedInUser currentUser;
  const MyFormsPage({super.key, required this.currentUser});

  /// CTOR

  @override
  Widget build(BuildContext context) {
    var authoredFormsModel = Provider.of<AuthoredFormsModel>(context);
    return Scaffold(
      appBar: defaultAppBar(buildContext: context, hasBackButton: true, title: 'My Forms (${authoredFormsModel.formsList.length})'),
      body: ListView.builder(
        itemCount: authoredFormsModel.formsList.length,
        itemBuilder: (context, index) {
          /// TOOD: replace with the yet-to-be-implemented [FormTileWidget]
          print('bulding form ${authoredFormsModel.formsList[index].formId}...');
          /// Shows all GenericForm-like objcets that link to this user's id
          return _buildFormTile(context, authoredFormsModel, index);
        },
      ),
    );
  }

  Widget _buildFormTile(
      BuildContext context, AuthoredFormsModel formListModel, int index) {
    return ListTile(
      title: Text(formListModel.formsList[index].formName),

      /// Dyanmically set the navigational route based on [currentUser]
      onTap: () => currentUser.hasAdminPrivileges ? 
          navigateToPage(context, FormBuilderPage(formId: formListModel.formsList[index].formId)) :
          navigateToPage(context, IndividualFormWidget(
            formListModel.formsList[index].formName, 
            formListModel.formsList[index].sport, 
            IndividualFormExaminationModel() 
          ))
          // _navigateToFormPage(
          // context, authoredFormsModel.formsList[index].formId),
    );
  }
}