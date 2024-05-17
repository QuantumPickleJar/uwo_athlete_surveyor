// ignore_for_file: dangling_library_doc_comments

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: A simple inbox for messages related to the app's functionality.
/// Bugs: n/a
/// Reflection: Was intended to be a full email-type inbox at conception of the project, which is certainly not what it is now.

import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/resources/common_widgets.dart';
import 'package:athlete_surveyor/models/inbox_model.dart';
import 'package:flutter/material.dart';

/// Widget representing a message inbox.
class InboxPage extends StatefulWidget
{
  final InboxModel inboxModel;
  final LoggedInUser currentUser;
  const InboxPage(this.inboxModel, {super.key, required this.currentUser});

  @override
  State<StatefulWidget> createState() => _InboxPageState();
}

/// InboxWidget State
class _InboxPageState extends State<InboxPage>
{
  String initialSelection = "Inbox";

  List<DropdownMenuEntry<dynamic>> dropdownMenuEntries = [
    const DropdownMenuEntry(value: 0, label: "Inbox"), 
    const DropdownMenuEntry(value: 1, label: "Unread"), 
    const DropdownMenuEntry(value: 2, label: "Starred"),
    const DropdownMenuEntry(value: 3, label: "Sent"),
    const DropdownMenuEntry(value: 4, label: "Archived")];

  /// Handles fetching inbox messages and populating ListView when received.
  @override
  void initState()
  {
    super.initState();

    widget.inboxModel.getEmailsFromDatabase(widget.currentUser.userUuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar( 
        buildContext: context, 
        title: 'Inbox', 
        hasBackButton: false, 
        actionButton: defaultActionButton(
          actionIcon: Icons.refresh, 
          onPressed: () { setState(() {}); })), // Call setState to reload the page and check for new messages.
      body: Column(
        children: [
          DropdownMenu(dropdownMenuEntries: dropdownMenuEntries, hintText: "Inbox", width: MediaQuery.of(context).size.width-8),
          Expanded(
            child: ListView.separated(
              itemCount: widget.inboxModel.emailList.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent, height: 1.0),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: RadioListTile(   // Intended for selecting multiple messages to allow mass updates/deletions; never finished
                    value: true,          // Temp
                    groupValue: null,     // Temp
                    onChanged: (value){}, // Temp
                    title: Text("${widget.inboxModel.emailList[index].receivedDate}\nFrom: ${widget.inboxModel.emailList[index].senderFirstName} ${widget.inboxModel.emailList[index].senderLastName}\n${widget.inboxModel.emailList[index].subject}\n"),
                    subtitle: Text(widget.inboxModel.emailList[index].body)));}))]));
  }
}