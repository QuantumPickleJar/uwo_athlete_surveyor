import 'package:athlete_surveyor/models/sport.dart';
import 'package:athlete_surveyor/services/sports/sports_repository.dart';
import 'package:flutter/material.dart';
/// model that sticks to the [SportPickerCard]. 
/// Tracks possible choices from the database, and (when 
/// in the context of building a form) stores current choice
class SportSelectionModel extends ChangeNotifier {
  late List<Sport> _sports;
  
  Sport? _selectedSport; 
  List<Sport> get sports => _sports;
  Sport? get selectedSport => _selectedSport;

  void selectSport(Sport sport) {
    _selectedSport = sport;
    notifyListeners();
  }
}