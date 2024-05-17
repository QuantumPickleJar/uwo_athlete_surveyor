// ignore_for_file: dangling_library_doc_comments

/// Name: Joshua T. Hill
/// Date: 5/15/2024
/// Description: Page for the DefaultTabController implementation for the app.
/// Bugs: n/a
/// Reflection: Saw a couple minor changes through the dev process, but I have to admit that the DefaultTabController works really well with little additional effort.

import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/models/inbox_model.dart';
import 'package:athlete_surveyor/models/forms/previous_forms_model.dart';
import 'package:athlete_surveyor/pages/common/home_page.dart';
import 'package:athlete_surveyor/pages/common/inbox_page.dart';
import 'package:athlete_surveyor/pages/previous_forms_page.dart';
import 'package:athlete_surveyor/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The widget controlling tab navigation of the app.
class TabbedMainPage extends StatefulWidget
{
  const TabbedMainPage({super.key, required this.currentUser});
  final LoggedInUser currentUser;

  @override
  State<TabbedMainPage> createState() => _TabbedMainPageState();
}

/// State of the tab controller.
class _TabbedMainPageState extends State<TabbedMainPage>
{
  int selectedIndex = 0;
  List<BottomNavigationBarItem> barItems = 
  [
    const BottomNavigationBarItem(label: 'Home'       ,icon: Icon(Icons.home)),
    const BottomNavigationBarItem(label: 'Inbox'      ,icon: Icon(Icons.mail)),
    const BottomNavigationBarItem(label: 'Past Forms' ,icon: Icon(Icons.pages))
  ];
  List<Widget> tabViews = [];

  /// Handler for tapping tab items to change tabs.
  void _handleTap(int index)
  {
    setState(() {
      selectedIndex = index;
    });
  }

  /// Setup of main tabbed page is different depending on whether or not Admin access is required, so initState() is overridden to provide for this distinction.
  @override
  void initState()
  {
    super.initState();
    
    tabViews = 
    [
      HomePage(
        displayName: widget.currentUser.firstName, 
        hasAdminPrivileges: widget.currentUser.hasAdminPrivileges
      ),
      Consumer<InboxModel>(
        builder: (context, inboxModel, _) {
          return InboxPage(inboxModel, currentUser: widget.currentUser);
      }),
      Consumer<PreviousFormsModel>(
        builder: (context, previousFormsModel, _) {
          return PreviousFormsPage(previousFormsModel);
      })
    ];
  }

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      home: DefaultTabController(
        length: tabViews.length, 
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            showUnselectedLabels: true,
            selectedItemColor: Colors.redAccent,
            unselectedItemColor: Colors.black,
            backgroundColor: titanYellow,
            onTap: _handleTap,
            items: barItems),
          body: tabViews[selectedIndex])));
  }
}