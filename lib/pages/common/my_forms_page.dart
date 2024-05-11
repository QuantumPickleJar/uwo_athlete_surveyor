import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/forms/previous_forms_model.dart';
import 'package:athlete_surveyor/pages/staff/form_builder_page.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyFormsPage extends StatelessWidget {
  final LoggedInUser _currentUser;
  const MyFormsPage({super.key, required LoggedInUser currentUser}) : _currentUser = currentUser;  /// CTOR

  @override
  Widget build(BuildContext context) {
    var authoredFormsModel = Provider.of<AuthoredFormsModel>(context);
    return ListView.builder(
      itemCount: authoredFormsModel.formsList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(authoredFormsModel.formsList[index].formName),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormBuilderPage(
                  formId: authoredFormsModel.formsList[index].formId),
              ),
            );
          },
        );
      },
    );
  }
}