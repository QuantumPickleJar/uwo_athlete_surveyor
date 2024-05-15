import 'package:athlete_surveyor/models/sport.dart';
import 'package:athlete_surveyor/models/sport_selection_model.dart';
import 'package:athlete_surveyor/widgets/sport_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
  
/// Dialog for wrapping the selection of a [GenericForm] to a [Sport], by 
/// leveraging the custom [SportPickerCard] widget
class SportPickerDialog extends StatelessWidget {

  const SportPickerDialog({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    SportSelectionModel sportSelectionModel = 
      Provider.of<SportSelectionModel>(context, listen: false);
    await sportSelectionModel.loadSports(); // Load sports from the database
    return AlertDialog(
      title: const Text('Select Sport'),
      content: Column(

      ),
      actions: [
        TextButton(onPressed: () {
          Sport? selectedSport = Provider.of<SportSelectionModel>(context, listen: false)
                                                                .selectedSport;
          Navigator.of(context).pop(selectedSport);
        },
        child: const Text('OK'))
      ],);
  }
}