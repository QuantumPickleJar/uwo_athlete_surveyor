import 'package:athlete_surveyor/models/inbox_model.dart';
import 'package:athlete_surveyor/models/previous_forms_model.dart';
import 'package:athlete_surveyor/pages/staff/admin_home_page.dart';
import 'package:athlete_surveyor/pages/common/inbox_page.dart';
import 'package:athlete_surveyor/pages/previous_forms_page.dart';
import 'package:athlete_surveyor/pages/students/student_home_page.dart';
import 'package:athlete_surveyor/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabbedMainPage extends StatefulWidget
{
  TabbedMainPage({super.key, required this.isAdmin});

  //final InboxModel inboxModel = InboxModel();
  //final PreviousFormsModel previousformsModel = PreviousFormsModel();
  final bool isAdmin;

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
    
    List<Widget> defaultTabs = 
      [
        Consumer<InboxModel>(
          builder: (context, inboxModel, _) {
            return InboxPage(inboxModel);
        }),
        Consumer<PreviousFormsModel>(
          builder: (context, previousFormsModel, _) {
            return PreviousFormsPage(previousFormsModel);
        })
      ];

    tabViews.add(widget.isAdmin ? const AdminHomePage() : const StudentHomePage());
    tabViews.addAll(defaultTabs);
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