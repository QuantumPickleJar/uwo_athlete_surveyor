import 'package:athlete_surveyor/widgets/ExpandedTextField.dart';
import 'package:flutter/material.dart';

class FormBuilderPage extends StatefulWidget {
  const FormBuilderPage({Key? key}) : super(key: key);

  @override
  _FormBuilderPageState createState() => _FormBuilderPageState();
}


class _FormBuilderPageState extends State<FormBuilderPage> {

  late double _sliderValue;

  /// Temporary placeholder to allow the slider to be enabled
  void _onSliderTap() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    /// give [_sliderValue] a valid number
    _sliderValue = 0.5;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Builder'),
      ),
      body:  Column(
        children: [
          const ExpandedTextField(labelText: "Title"),
          const Divider(),
          const Card(
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
                children: [Text("Open-ended")],
              )
            ]),
          ),
          const Divider(),
          const Card(

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
              const Divider(),
              /// Answer Type Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                const Text("Format response:", style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(onPressed: _openFormatModal, child: const Text("Sliding Scale"))
              ]),/// end header row
              
              Slider(
                  value: _sliderValue.toDouble(),
                  onChanged: (double newValue) {
                    setState(() {
                      _sliderValue = newValue;
                    });
                  },
                ),
              Center(
                child:ElevatedButton(onPressed: _openFormatModal, child: const Text("Add Question"))
              ),
              InputChip(onPressed: null, label: Text("Save Changes"), avatar: Icon(Icons.check))
        ],
      ),
    );
  }

  void _openFormatModal() {
    // TODO: make this later, see the figma for the prototype
    return;
  }
}
