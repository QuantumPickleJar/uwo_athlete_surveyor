import "package:athlete_surveyor/models/students_model.dart";
import "package:athlete_surveyor/resources/common_widgets.dart";
import "package:athlete_surveyor/widgets/async_student_autocomplete.dart";
import "package:athlete_surveyor/widgets/expanded_text_field.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class ComposeMessagePage extends StatelessWidget {
  final String currentUserId;
  const ComposeMessagePage({required this.currentUserId, super.key});

  // ignore: constant_identifier_names
  static const double SCREEN_WIDTH = 375.0;
  

  /// Populate the recipients search bar with students
  /// TODO: once student groups are implemented, narrow the selection by 
  /// [currentUserId]
  Future<void> fillRecipientsContents() async {
    try {
          
      
    } catch (e) {
      print('Error populating recipients: $e');
    }
  }

    /// Called after [fillRecipientsContents]; loads the selectable options into 
    /// an [AsyncStudentAutocomplete] widget
    Future<AsyncStudentAutocomplete?> buildRecipientsDropdown() async {
      try {
      // fillRecipientsContents(); // maybe this goes here...?

      /// TODO: how will we get studentsModel here?
      return const AsyncStudentAutocomplete();
    } catch (e) {
      print('Error building dropdown: $e');
      return null;
    }
  }

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
                      Text("No attachments", style: TextStyle(fontSize: 24, color: Colors.blueGrey)),
                      FloatingActionButton(onPressed: null, child: Icon(Icons.attach_file) )
                    ],
                ),
              ],
            ),
          ),
        ]),
      );
  }
}

/// TODO: potentially wrap the compose_message_page with a StatelessWidget-based wrapper that
/// supplies a Consumer,StudentsModel
class ComposeMessagePageWrapper extends StatelessWidget {
  final String currentUserId;
  const ComposeMessagePageWrapper({required this.currentUserId, super.key});

    @override
    Widget build(BuildContext context) {
      return Consumer<StudentsModel>(
        builder: (context, studentsModel, child) {
          return ComposeMessagePage(currentUserId: currentUserId);
      },
    );
  }
}