import 'package:athlete_surveyor/models/sport.dart';
import 'package:athlete_surveyor/services/sports/sports_repository.dart';
import 'package:athlete_surveyor/services/sports/sports_service.dart';
import 'package:flutter/material.dart';
/// model that sticks to the [SportPickerCard]. 
/// 
/// Tracks possible choices from the database, and (when  in the context
/// of building a form) stores current choice. 
/// 
/// Loosely follows the Facade pattern in that we're abstracting the DB
/// interaction to the [SportSelectionModel]
class SportSelectionModel extends ChangeNotifier {
  final SportsService sportsService;
  List<Sport> _sports = [];
  Sport? _selectedSport; 
  bool _isLoaded = false;   // whether or not we've asked for sports yet

  SportSelectionModel({required this.sportsService});

  /// setup our getters
  List<Sport> get sports => _sports;
  Sport? get selectedSport => _selectedSport;
  bool get isLoaded => _isLoaded;

  /// used to mark whether or not our lazy load for sports has completed
  set isLoaded(bool loadStatus) {
    _isLoaded = loadStatus;
  }

  /// (This might need to be removed since the model won't invoke the DB directly)
  /// load all sports so the user can pick from them as needed
  Future<void> loadSports() async {
      if (!_isLoaded) {
      try {
        // _sports = await sportsRepository.getAllSports();
        _sports = await sportsService.loadSportsFromFile();
        _isLoaded = true;
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading sports: $e');
      }
    }
  }

   /// Another workaound function, this one lets us query a sport name 
   /// by ID from the cached sports data in assets/sports.json
    Sport? getSportById(String sportId) {
    try {
      final sport = _sports.firstWhere((sport) => sport.sportId.toString() == sportId);
      return sport;
    } catch (e) {
      debugPrint('Error finding sport with ID $sportId: $e');
      return null;
    }
  }

   /// Another workaound function, this one lets us query a sport's id 
   /// from its name. Both of which, are cached sports data in assets/sports.json
    Sport? getSportByName(String activity) {
    try {
      final sport = _sports.firstWhere((sport) => sport.activity.toString() == activity);
      return sport;
    } catch (e) {
      debugPrint('Error finding sport with ID $activity: $e');
      return null;
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