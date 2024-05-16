import 'package:athlete_surveyor/models/forms/previous_forms_model.dart';
import 'package:athlete_surveyor/models/student_model.dart';
import 'package:athlete_surveyor/pages/staff/form_builder_page.dart';
import 'package:athlete_surveyor/pages/staff/students_page.dart';
import 'package:athlete_surveyor/resources/common_functions.dart';
import 'package:athlete_surveyor/widgets/create_form_btn.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:athlete_surveyor/services/forms/secure_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                                    textAlign: TextAlign.center)
                    )
                  )
                ),
                Visibility(
                  visible: hasAdminPrivileges,
                  child: CreateFormButton(hasAdminPrivileges: hasAdminPrivileges))
            ])
          ]
        )
      );
  }
}
