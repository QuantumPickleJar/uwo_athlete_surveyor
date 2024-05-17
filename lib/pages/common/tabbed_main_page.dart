import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/models/inbox_model.dart';
import 'package:athlete_surveyor/models/forms/previous_forms_model.dart';
import 'package:athlete_surveyor/pages/common/my_forms_page.dart';
import 'package:athlete_surveyor/pages/home_page.dart';
import 'package:athlete_surveyor/pages/common/inbox_page.dart';
import 'package:athlete_surveyor/resources/colors.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabbedMainPage extends StatefulWidget
{
  const TabbedMainPage({super.key, required this.currentUser});
  final LoggedInUser currentUser;

  @override
  State<TabbedMainPage> createState() => _TabbedMainPageState();
}

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


  // Handler for tapping tab items to change tabs.
  void _handleTap(int index)
  {
    setState(() {
      selectedIndex = index;
    });
  }

  // Setup of main tabbed page is different depending on whether or not Admin access is required, so iniState() is overridden to provide for this distinction.
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
          return InboxPage(inboxModel);
      }),
      Consumer<AuthoredFormsModel>(
        builder: (context, previousFormsModel, _) {
          /// by wrapping this in a consumer, we let the widget tree deal with role-specifics
          print("[TabbedMainpage] User Role: ${widget.currentUser.hasAdminPrivileges ? 'Admin' : 'Student'}");
          return MyFormsPage(currentUser: widget.currentUser);
      })
    ];
  }

  @override
  Widget build(BuildContext context) 
  {
   // AuthoredFormsModel previousFormsModel = Provider.of<AuthoredFormsModel>(context);

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