// ignore_for_file: library_private_types_in_public_api

/* Author - Joshua */
import 'package:flutter/material.dart';
import 'package:athlete_surveyor/models/previous_forms_model.dart';

const Divider listviewDivider = Divider(
  thickness: 2.0,
  color: Colors.pinkAccent);


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
        title: const Center(child: Text("Previous Forms")),
        backgroundColor: Colors.blue.shade200, 
        leading: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(onPressed:(){ Navigator.pop(context); }, child: const Text("<")),
          ),),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: widget.formModel.formsList.length,
              separatorBuilder: (BuildContext context, int index) => listviewDivider,
              itemBuilder: (BuildContext context, int index) {
                return const ListTile();}))]
      )
    );
  }
}