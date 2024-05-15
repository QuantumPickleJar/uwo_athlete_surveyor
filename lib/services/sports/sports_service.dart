import 'package:athlete_surveyor/models/sport.dart';
import 'package:athlete_surveyor/services/sports/sports_repository.dart';

class SportService {
  final SportRepository _sportRepository;

  SportService(this._sportRepository);

  Future<List<Sport>> getAllSports() async {
    return await _sportRepository.getAllSports();
  }

  Future<String?> getSportById(String sportId) async {
    return await _sportRepository.getSportById(sportId);
  }
}
