import 'package:athlete_surveyor/models/sport.dart';
import 'package:athlete_surveyor/models/sport_selection_model.dart';
import 'package:athlete_surveyor/widgets/dialogs/sport_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
    
/// To keep data flow simple, force the user to have a sport chosen for 
/// the form before we take them to the page to render it for further work.
class CreateFormButton extends StatelessWidget {

  const CreateFormButton({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child:,
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
        }

      },
    )
  }
}