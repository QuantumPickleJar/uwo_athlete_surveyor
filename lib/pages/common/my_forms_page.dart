import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/forms/previous_forms_model.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:athlete_surveyor/widgets/form_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Page used to display to the user any [GenericForm]-type entities that
/// have been contextually "assigned" to the user.
/// The user can be either a student or a staff member.
/// It is important to distinguish between the two when displaying the forms on the screen
class MyFormsPage extends StatelessWidget {
  final LoggedInUser currentUser;
  late AuthoredFormsModel authoredFormsModel;
  MyFormsPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    authoredFormsModel = Provider.of<AuthoredFormsModel>(context);
    return Scaffold(
      appBar: defaultAppBar(
        buildContext: context, 
        hasBackButton: false,
        title: 'My Forms (${authoredFormsModel.formsList.length})'
      ),
      body: ListView.builder(
        itemCount: authoredFormsModel.formsList.length,
        itemBuilder: (context, index) {
          return FormTileWidget(
            form: authoredFormsModel.formsList[index],
            currentUser: currentUser,
          );
        },
      ),
    );
  }
}

