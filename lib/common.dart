import 'package:athlete_surveyor/styles/colors.dart';
import 'package:flutter/material.dart';

// The default style for an AppBar with modifiable title.
AppBar defaultAppBar(BuildContext context, String title)
{
return AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: titanYellow,
        leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_outlined, 
                color: Colors.black), 
              onPressed:(){ Navigator.pop(context); })));
}

// The default-styled AppBar with an additional button (likely for navigation) in the 'actions' param.
AppBar defaultAppBarWithActionButton(BuildContext context, String title, IconData actionIcon, void Function() onPressed)
{
  return AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: titanYellow,
        leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(icon: const Icon(Icons.arrow_back_outlined, color: Colors.black), onPressed:(){ Navigator.pop(context); }),
          ),
        actions: [Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(icon: Icon(actionIcon, color: Colors.black), onPressed:(){ onPressed; }),)],);
}

// The default style of the ListViewDivider.
const Divider defaultListViewDivider = Divider
(
  thickness: 2.0,
  color: titanYellow
);