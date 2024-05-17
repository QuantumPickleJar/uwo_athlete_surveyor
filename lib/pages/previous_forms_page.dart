// ignore_for_file: library_private_types_in_public_api, dangling_library_doc_comments

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: A page to display a list of previously complete forms by the logged-in user, displayed as "form-shaped" rectangles.
/// Bugs: n/a
/// Reflection: n/a

import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/models/forms/individual_form_examination_model.dart';
import 'package:athlete_surveyor/pages/individual_form_examination_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:athlete_surveyor/models/forms/previous_forms_model.dart';

/// A class representing a page in which all forms previously completed by a user are displayed.
class PreviousFormsPage extends StatefulWidget 
{
  final LoggedInUser currentUser;
  final AuthoredFormsModel formModel;
  const PreviousFormsPage(this.formModel, {super.key, required this.currentUser});

  @override
  _PreviousFormsPageState createState() => _PreviousFormsPageState();
}

/// StatefulWidget State.
class _PreviousFormsPageState extends State<PreviousFormsPage>
{
  /// Handles fetching previously completed forms from database and populating ListView when received.
  @override
  void initState()
  {
    super.initState();
    widget.formModel.getPreviousFormsFromDatabase(userId: widget.currentUser.userUuid);   
  }

  @override
  Widget build(BuildContext context) 
  {
    return Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: widget.formModel.formsList.length, 
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 8.5 / 11.0,
                crossAxisCount: 2), 
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      title: Text("${widget.formModel.formsList[index].formName}\n~ ${widget.formModel.formsList[index].sport} ~\n", textAlign: TextAlign.center), titleAlignment: ListTileTitleAlignment.center,
                      subtitle: Text("Created:\n${widget.formModel.formsList[index].formDateCreated}", textAlign: TextAlign.center),
                      onTap:(){ navigateToPage(context, IndividualFormWidget(widget.formModel.formsList[index].formName, widget.formModel.formsList[index].sport, IndividualFormExaminationModel())); }
                    )));}))]);
  }
}