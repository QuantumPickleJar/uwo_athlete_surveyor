// ignore_for_file: library_private_types_in_public_api

/* Author - Joshua */
import 'package:flutter/material.dart';
import 'package:athlete_surveyor/models/previous_forms_model.dart';
import 'package:athlete_surveyor/styles/colors.dart';

class PreviousFormsWidget extends StatefulWidget 
{
  final PreviousFormsModel formModel;
  const PreviousFormsWidget(this.formModel, {super.key});

  @override
  _PreviousFormsWidgetState createState() => _PreviousFormsWidgetState();
}

class _PreviousFormsWidgetState extends State<PreviousFormsWidget>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Forms"),
        centerTitle: true,
        backgroundColor: titanYellow,
        leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(icon: const Icon(Icons.arrow_back_outlined, color: Colors.black), onPressed:(){ Navigator.pop(context); }),
          ),),
      body: Column(
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
                      onTap: null //add later for viewing individual forms
                    ),
                  ));
              }))
        ]
      )
    );
  }
}