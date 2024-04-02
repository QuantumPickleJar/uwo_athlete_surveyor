/* Author - Joshua */

/*Author - Joshua*/
import 'package:athlete_surveyor/styles/colors.dart';
import 'package:flutter/material.dart';

const Divider listviewDivider = Divider(
  thickness: 2.0,
  color: titanYellow);

class InboxWidget extends StatefulWidget
{
  const InboxWidget({super.key});

  @override
  State<StatefulWidget> createState() => _InboxWidgetState();
}

class _InboxWidgetState extends State<InboxWidget>
{
  List<String> inboxList = [
    //
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
        centerTitle: true,
        backgroundColor: titanYellow,
        leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(icon: const Icon(Icons.arrow_back_outlined, color: Colors.black), onPressed:(){ Navigator.pop(context); }),
          ),
        actions: [Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(icon: const Icon(Icons.email, color: Colors.black), onPressed: null),)],),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: inboxList.length,
                separatorBuilder: (BuildContext context, int index) => listviewDivider,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Text(inboxList[index])
                  );
                },
              ))
          ],
        ),
    );
  }
}