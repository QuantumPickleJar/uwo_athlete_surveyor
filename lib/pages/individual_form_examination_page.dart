// ignore_for_file: dangling_library_doc_comments

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: A page to display the questions and answers for a particular previously completed form.
/// Bugs: n/a
/// Reflection: n/a

import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:athlete_surveyor/models/forms/individual_form_examination_model.dart';
import 'package:flutter/material.dart';

/// 
class IndividualFormWidget extends StatefulWidget
{
  final String appBarTitle;
  final String sportName;
  final IndividualFormExaminationModel individualModel;
  const IndividualFormWidget(this.appBarTitle, this.sportName, this.individualModel, {super.key});

  @override
  State<StatefulWidget> createState() => _IndividualFormWidgetState();
}

///
class _IndividualFormWidgetState extends State<IndividualFormWidget>
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: defaultAppBar(
        buildContext: context, 
        title: widget.appBarTitle, 
        hasBackButton: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("~ ${widget.sportName} ~", style: const TextStyle(fontSize: 20.0),),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: widget.individualModel.pairsList.length,
              separatorBuilder: (BuildContext context, int index) => defaultListViewDivider,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Text("${index+1}."),
                  title: Text("Q: ${widget.individualModel.pairsList[index].question}"),
                  subtitle: Text("A: ${widget.individualModel.pairsList[index].answer}")
                );}))]));
  }
}