import 'package:athlete_surveyor/widgets/ExpandedTextField.dart';
import 'package:flutter/material.dart';

class FormBuilderPage extends StatefulWidget {
  const FormBuilderPage({Key? key}) : super(key: key);

  @override
  _FormBuilderPageState createState() => _FormBuilderPageState();
}

class _FormBuilderPageState extends State<FormBuilderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Builder'),
      ),
      body: const Column(
        children: [
          ExpandedTextField(labelText: "Title"),
          Divider(),
          Card(
            /// Collapsed question 1
            margin: EdgeInsets.all(15.0),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Question 1",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  "Expand",
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [const Text("Open-ended")],
              )
            ]),
          ),
          Divider(),
          Card(

              /// Expanded visible question
              margin: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Question 2",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                  ExpandedTextField(labelText: "Prompt"),
                  Divider(),
                  Card(
                    /// attachments card
                    color: Color.fromRGBO(200, 200, 200, 1.0),
                    child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Attachments", style: TextStyle(fontWeight: FontWeight.bold)),
                            InputChip(
                              label: Text("URL"),
                              isEnabled: true,
                              avatar: Icon(Icons.language),
                            ),
                            InputChip(
                                label: Text("IMG"),
                                isEnabled: true,
                                avatar: Icon(Icons.upload)),
                          ]),
                    Divider(color: Colors.white, indent:10, endIndent: 10),
                      /// replace with listview to show attached files
                      Column(children: [
                        Text("(350 x 500) - final_submit.png",
                        style: TextStyle(color: Colors.red)),
                        Text("Writing Guidelines - Canvas",
                        style: TextStyle(color: Colors.red)),
                      ]),
                    ]),
                  )
                ])
              ),
              Divider(),
              /// Answer Type Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text("Format response:", style: TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  onChanged: null,
                  value: 50
                )
                  
              ], /// end header row
              )
              
        ],
      ),
    );
  }
}
