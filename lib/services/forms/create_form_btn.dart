import 'package:athlete_surveyor/models/sport.dart';
import 'package:athlete_surveyor/models/sport_selection_model.dart';
import 'package:athlete_surveyor/resources/colors.dart';
import 'package:athlete_surveyor/services/forms/form_service.dart';
import 'package:athlete_surveyor/services/forms/secure_form_provider.dart';
import 'package:athlete_surveyor/widgets/dialogs/sport_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
    
/// To keep data flow simple, force the user to have a sport chosen for 
/// the form before we take them to the page to render it for further work.
class CreateFormButton extends StatelessWidget {
  final bool hasAdminPrivileges;
  const CreateFormButton({ Key? key, required this.hasAdminPrivileges }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          /// Get the sports to choose from via [SportSelectionModel]
          SportSelectionModel model = Provider.of<SportSelectionModel>(context, listen: false);
          await model.loadSports(); /// wait for them to finish loading before showing
      
          /// To choose the sport from the model, we go through a [SportPickerDialog]
          Sport? selectedSport = await showDialog<Sport>(
            context: context,
            builder: (BuildContext context) {
              return const SportPickerDialog();
            },
          );
      
          if (selectedSport != null) {
            /// update this form's sport
            FormService formService = Provider.of<FormService>(context, listen: false);
            var newForm = await formService.createNewForm(formName: 'New Form', sport: selectedSport.activity);
            
            if (newForm != null && newForm.formId.isNotEmpty) {
            /// push the existing form (if, for example, a previous form's thumnbnail was tapped)
            /// otherwise send them there with a new one to be provided an ID on dbsubmittal
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              debugPrint(
                  '[HomePage]: Securely providing ${newForm.formId}');
              return SecureFormProvider(
                  formId: newForm.formId,
                  hasAdminPrivileges: hasAdminPrivileges
              );
            }));
            } else {
              print("Failed to create new form or formID was not set!");
            }
          } 
        },
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(titanYellow
        ),
    ),
        child: const SizedBox(
        width: 200,
        height: 50,
        child: Center(
          child: Text(
            'Create a Form',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ), 
          ),
        )
    );
  }
}