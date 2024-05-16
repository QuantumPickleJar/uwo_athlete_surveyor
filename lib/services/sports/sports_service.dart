import 'dart:convert';

import 'package:athlete_surveyor/models/sport.dart';
import 'package:athlete_surveyor/services/sports/sports_repository.dart';
/// used to fetch the sports "locally"
import 'package:flutter/services.dart' as rootBundle;

class SportsService {
  final SportsRepository _sportRepository;
  SportsService(this._sportRepository);

  Future<List<Sport>> getAllSports() async {
    return await _sportRepository.getAllSports();
  }

  Future<List<Sport>> loadSportsFromFile() async {
    final jsonString = await rootBundle.rootBundle.loadString('assets/sports.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((data) => Sport.fromJson(data)).toList();
  }

  Future<String?> getSportById(String sportId) async {
    return await _sportRepository.getSportById(sportId);
  }
}
