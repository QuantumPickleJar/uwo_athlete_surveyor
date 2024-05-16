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
  
  final SportsRepository sportsRepository;
  List<Sport> _sports = [];
  Sport? _selectedSport; 
  bool _isLoaded = false;   // whether or not we've asked for sports yet

  SportSelectionModel({required this.sportsRepository});
  /// setup our getters
  List<Sport> get sports => _sports;
  Sport? get selectedSport => _selectedSport;
  bool get isLoaded => _isLoaded;

  /// used to mark whether or not our lazy load for sports has completed
  set isLoaded(bool loadStatus) {
    _isLoaded = loadStatus;
  }

  /// load all sports so the user can pick from them as needed
  Future<void> loadSportsFromDB() async {
      if (!_isLoaded) {
      try {
        _sports = await sportsRepository.getAllSports();
        _isLoaded = true;
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading sports: $e');
      }
    }
  }

  /// lets us store the updated list of [Sport]s into the model for selection
  set sports(List<Sport> sports) {
    _sports = sports;
    notifyListeners();
  }

  /// used to modify the currently selected sport to be used on a
  void selectSport(Sport sport) {
    _selectedSport = sport;
    notifyListeners();
  }
}