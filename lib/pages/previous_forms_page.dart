// ignore_for_file: library_private_types_in_public_api
import 'package:athlete_surveyor/models/forms/individual_form_examination_model.dart';
import 'package:athlete_surveyor/pages/individual_form_examination_page.dart';
import 'package:flutter/material.dart';
import 'package:athlete_surveyor/models/forms/previous_forms_model.dart';

//
class PreviousFormsPage extends StatefulWidget 
{
  final PreviousFormsModel formModel;
  const PreviousFormsPage(this.formModel, {super.key});

  @override
  _PreviousFormsPageState createState() => _PreviousFormsPageState();
}

//
class _PreviousFormsPageState extends State<PreviousFormsPage>
{
  //
  void navigateToPage(BuildContext context, Widget page)
  {
    Navigator.push
    (
      context,
      MaterialPageRoute(builder: (context) => page)
    );
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
                      subtitle: Text("Received:\n${widget.formModel.formsList[index].dateReceived}\nCompleted:\n${widget.formModel.formsList[index].dateCompleted}", textAlign: TextAlign.center),
                      onTap:(){ navigateToPage(context, IndividualFormWidget(widget.formModel.formsList[index].formName, widget.formModel.formsList[index].sport, IndividualFormExaminationModel())); }
                    )));}))]);
  }
}