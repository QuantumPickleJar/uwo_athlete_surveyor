import 'package:athlete_surveyor/models/sport.dart';
import 'package:athlete_surveyor/services/sports/sports_repository.dart';
import 'package:flutter/material.dart';
/// model that sticks to the [SportPickerCard]. 
/// 
/// Tracks possible choices from the database, and (when  in the context
/// of building a form) stores current choice. 
/// 
/// Loosely follows the Facade pattern in that we're abstracting the DB
/// interaction to the [SportSelectionModel]
class SportSelectionModel extends ChangeNotifier {
  
  final SportsRepository _sportsRepository;
  List<Sport>? sports;
  Sport? _selectedSport; 
  Sport? get selectedSport => _selectedSport;

    
  SportSelectionModel(this._sportsRepository);

  Future<void> loadSports() async {
    sports = await _sportsRepository.getAllSports();
    notifyListeners();
  }

  void selectSport(Sport sport) {
    _selectedSport = sport;
    notifyListeners();
  }
}