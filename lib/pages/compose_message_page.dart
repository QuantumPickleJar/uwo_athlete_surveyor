import "package:athlete_surveyor/resources/common_widgets.dart";
import "package:athlete_surveyor/widgets/ExpandedTextField.dart";
import "package:flutter/material.dart";

class ComposeMessagePage extends StatelessWidget {
  const ComposeMessagePage({super.key});
  // ignore: constant_identifier_names
  static const double SCREEN_WIDTH = 375.0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            defaultAppBar(
              buildContext: context, 
              title: "Compose Message", 
              hasBackButton: true, 
              actionButton: defaultActionButton(
                actionIcon: Icons.send, 
                onPressed: () { null; })), //TODO
        body: const Column(children: [
          Card(               /// Recipients Input
            child: IntrinsicHeight(
              child: ExpandedTextField(
                labelText: "Recipients",
                hintText: "Ex: studentID@uwosh.edu",
                leadingIcon: Icon(Icons.search),
                trailingIcon: Icon(Icons.clear)
              )
            ), 
          ),
          Card(           /// Subject line
            child: IntrinsicHeight(
              child: ExpandedTextField(labelText: "Subject")
              ),
            ),
          Divider(indent: 25, endIndent: 25),
            SizedBox(
              height: 280,
              width: SCREEN_WIDTH, 
              child: Card(
                child: TextField(     /// message field
                  expands: true,
                  decoration: InputDecoration(hintText: "Message", border: InputBorder.none),
                  maxLines: null
                ),
              ),
            ),
          Card(
            margin: EdgeInsets.all(12),
            child: 
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Request reply?"),
                    Switch(value: false, onChanged: null)]),
                Divider(indent: 15, endIndent: 20),
                Column(           /// Attachments
                  children: [
                    Text("Attachments", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("No attachments", style: TextStyle(fontSize: 24, color: Colors.blueGrey))
                    ],
                )
              ],
            ),
          )
        ])
        );
  }
}