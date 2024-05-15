import 'package:athlete_surveyor/models/sport.dart';
import 'package:athlete_surveyor/services/sports/sports_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SportPickerCard extends StatefulWidget {
  final void Function(Sport?) onSportChanged;

  const SportPickerCard({
    Key? key,
    required this.onSportChanged,
  }) : super(key: key);

  @override
  _SportPickerCardState createState() => _SportPickerCardState();
}

class _SportPickerCardState extends State<SportPickerCard> {
  late SportsRepository sportsRepository; 
  Sport? _selectedSport;

  @override initState() {
    sportsRepository = Provider.of<SportsRepository>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) async {
    List<Sport> sports = await sportsRepository.getAllSports();

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
              value: _selectedSport,
              hint: const Text("Choose a sport"),
              onChanged: (Sport? newValue) {
                setState(() {
                  _selectedSport = newValue;
                  widget.onSportChanged(newValue);
                });
              },
              items: sports.map((Sport sport) {
                return DropdownMenuItem<Sport>(
                  value: sport,
                  child: Text(sport.name),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
