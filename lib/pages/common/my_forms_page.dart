import 'package:athlete_surveyor/data_objects/logged_in_user.dart';
import 'package:athlete_surveyor/models/forms/base_form.dart';
import 'package:athlete_surveyor/models/forms/previous_forms_model.dart';
import 'package:athlete_surveyor/pages/staff/form_builder_page.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyFormsPage extends StatefulWidget {
  final LoggedInUser _currentUser;
  const MyFormsPage({super.key, required LoggedInUser currentUser}) : _currentUser = currentUser;  /// CTOR

  @override
  _MyFormsPageState createState() => _MyFormsPageState();
}

class _MyFormsPageState extends State<MyFormsPage> {
  late List<GenericForm> _forms;

  @override
  void initState() {
    super.initState();
    
    /// Dropped in favor of the App Lifecycle, included for historical + referential purpose
    // _formService = Provider.of<FormService>(context, listen: false);  /// Deprecated! 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Loading previous forms...');
    /// as SOON as this frame completes, a [FrameCallback] is used to specify an awaited check on 
    /// what type of user is interacting with the form, so that the app knows how to render it 
      Provider.of<AuthoredFormsModel>(context, listen: false)
                .getPreviousFormsFromDatabase(userId: widget._currentUser.userId!);
    });
    _loadForms();
  }

  Future<void> _loadForms() async {
    if (widget._currentUser.userId != null && widget._currentUser.userId!.isNotEmpty) {
      // _forms = await _formService.getFormsByUserId(userId: widget._currentUser.userId!);
      
      _forms = Provider.of<AuthoredFormsModel>(context).formsList;
    }
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: _forms.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_forms[index].formName),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormBuilderPage(formId: _forms[index].formId),
              ),
            );
          },
        );
      },
    );
  }
}