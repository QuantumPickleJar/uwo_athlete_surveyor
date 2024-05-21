// ignore_for_file: library_private_types_in_public_api, dangling_library_doc_comments

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: A page to display a list of previously complete forms by the logged-in user, displayed as "form-shaped" rectangles.
/// Bugs: n/a
/// Reflection: n/a
import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/pages/staff/form_builder_page.dart';
import 'package:athlete_surveyor/widgets/form_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:athlete_surveyor/models/forms/previous_forms_model.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/forms/student_form.dart';
import 'package:athlete_surveyor/pages/form_taker_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:provider/provider.dart';

/// Page used to display to the user any [GenericForm]-type entities that
/// have been contextually "assigned" to the user.
/// The user can be either a student or a staff member.
/// It is important to distinguish between the two when displaying the forms on the screenclass PreviousFormsPage extends StatefulWidget 
class PreviousFormsPage extends StatefulWidget {
  final LoggedInUser currentUser;
  const PreviousFormsPage({super.key, required this.currentUser});

  @override
  _PreviousFormsPageState createState() => _PreviousFormsPageState();
}

/// StatefulWidget State.
class _PreviousFormsPageState extends State<PreviousFormsPage> {
  
  late AuthoredFormsModel formModel;

  @override
  void initState() {
    super.initState();
    // widget.formModel.getPreviousFormsFromDatabase(userId: widget.currentUser.userUuid);   
    formModel = Provider.of<AuthoredFormsModel>(context, listen: false);
    formModel.getPreviousFormsFromDatabase(userId: widget.currentUser.userUuid);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Forms'),
      ),
      body: Consumer<AuthoredFormsModel>(
        builder: (context, model, child) {
          return GridView.builder(
            itemCount: formModel.formsList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 8.5 / 11.0,
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              /// load the current form into a [FormTileWidget]
              GenericForm form = formModel.formsList[index];
              return FormTileWidget(
                form: form,
                currentUser: widget.currentUser, 
                /// dynamically adjust the routing based on [widget.currentUser]
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) {
                //          return (widget.currentUser.hasAdminPrivileges) ?
                //           FormBuilderPage(formId: form.formId)  :         /// Staff go here
                //           FormTakerPage(questions: form.questions);       /// Students go here
                  //     }
                  //   ),
                  // );
                // },
              );
            });
          }
        ),
    );
  }
}
