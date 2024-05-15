import 'package:athlete_surveyor/models/sport.dart';
import 'package:athlete_surveyor/models/sport_selection_model.dart';
import 'package:athlete_surveyor/services/sports/sports_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SportPickerCard extends StatelessWidget {
  // final void Function(Sport?) onSportChanged;

  SportPickerCard({super.key});
  // Sport? _selectedSport; /// held by the [SportSelectionModel]


  @override
  Widget build(BuildContext context) {

    // Consumer is used to listen to SportSelectionModel changes    
    return Consumer<SportSelectionModel>(
      builder: (context, sportSelectionModel, child) {
        debugPrint("Selected Sport: ${sportSelectionModel.selectedSport}");
        debugPrint("Available Sports: ${sportSelectionModel.sports.map((s) => s.activity).join(', ')}");


      return Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Select a sport"),
              const SizedBox(height: 16.0),
              DropdownButton<Sport>(
                value: sportSelectionModel.selectedSport,
                hint: const Text("Choose a sport"),
                items: sportSelectionModel.sports.map((Sport sport) {
                  return DropdownMenuItem<Sport>(
                    value: sport,
                    child: Text(sport.activity),
                  );
                }).toList(),
                onChanged: (Sport? newSport) {
                  if (newSport != null) {
                    sportSelectionModel.selectSport(newSport);
                  }
                }
              ),
            ],
          ),
        ),
      );
    });
  }
}
