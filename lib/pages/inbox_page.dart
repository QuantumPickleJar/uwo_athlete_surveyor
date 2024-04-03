import 'package:athlete_surveyor/common.dart';
import 'package:athlete_surveyor/models/inbox_model.dart';
import 'package:flutter/material.dart';

// Widget representing an Email inbox.
class InboxWidget extends StatefulWidget
{
  final InboxModel inboxModel;
  const InboxWidget(this.inboxModel, {super.key});

  @override
  State<StatefulWidget> createState() => _InboxWidgetState();
}

// InboxWidget State
class _InboxWidgetState extends State<InboxWidget>
{
  String initialSelection = "Inbox";

  List<DropdownMenuEntry<dynamic>> dropdownMenuEntries = [
    const DropdownMenuEntry(value: 0, label: "Inbox"), 
    const DropdownMenuEntry(value: 1, label: "Unread"), 
    const DropdownMenuEntry(value: 2, label: "Starred"),
    const DropdownMenuEntry(value: 3, label: "Sent"),
    const DropdownMenuEntry(value: 4, label: "Archived")];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBarWithActionButton(context, 'Inbox', Icons.email, () { null; }), //null temp; will be used to navigate to screen7 (new message) later
        body: Column(
          children: [
            DropdownMenu(dropdownMenuEntries: dropdownMenuEntries, hintText: "Inbox", width: MediaQuery.of(context).size.width-8),
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: SearchBar(
                padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
                leading: Icon(Icons.search))),
            Expanded(
              child: ListView.separated(
                itemCount: widget.inboxModel.emailList.length,
                separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent, height: 1.0),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: RadioListTile(
                      value: true,          //temp
                      groupValue: null,     //temp
                      onChanged: (value){}, //temp
                      title: Text("${widget.inboxModel.emailList[index].receivedDate}\nFrom: ${widget.inboxModel.emailList[index].from}\n${widget.inboxModel.emailList[index].subject}\n"),
                      subtitle: Text(widget.inboxModel.emailList[index].body)
                    ));}))]));
  }
}