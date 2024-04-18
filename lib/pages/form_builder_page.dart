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
          Card(  /// Collapsed question 1
            margin: EdgeInsets.all(15.0),
            child: 
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Question 1"),
                    Text("Expand",),
                  ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [const Text("Open-ended")],
                  )
              ]),
          ),
          Divider(),
          Card(       /// Expanded visible question
          margin: EdgeInsets.all(15.0),

          )
        ],
      ),
    );
  }
}