import 'package:athlete_surveyor/models/sport.dart';
import 'package:postgres/postgres.dart';
import 'package:athlete_surveyor/services/db.dart';

/// Simple repository for interacting with stored values for the available sports to pick from
class SportsRepository {
  Future<Connection> get _connection async => await PostgresDB.getConnection();
  /// We could put a list here since sports probably wont get added too often after initial setup
  
  SportsRepository();

  Future<List<Sport>> getAllSports() async {
    var db = await _connection;
    try {
      String sqlStatement = "SELECT sport_id, sport_name FROM public.tbl_sports;";
      var result = await db.execute(Sql.named(sqlStatement));
      return result.map((row) => Sport(
        sportId: row.toColumnMap()['sport_id'],
        activity: row.toColumnMap()['sport_name'],
      )).toList();
    } finally {
      PostgresDB.closeConnection();
    }
  }
  /// Fetches a single sport by ID
  Future<String?> getSportById(String sportId) async {
    var db = await _connection;
    try {
      String sql = 'SELECT sport_name FROM tbl_sports WHERE sport_id = @sportId;';
      var results = await db.execute(sql, parameters: {'sportId': sportId});
      if (results.isNotEmpty) {
        return results.first[0] as String;
      }
      return null;
    } finally {
      db.close();
    }
  }

  /// Utility function, doubt we'll need this
  Future<String?> getSportIdByName(String sportName) async {
    var db = await _connection;
    try {
      String sql = 'SELECT sport_id FROM tbl_sports WHERE sport_name = @sportName;';
      var results = await db.execute(sql, parameters: {'sportName': sportName});
      if (results.isNotEmpty) {
        return results.first[0].toString();
      }
      return null;
    } finally {
      db.close();
    }
  }

  linkFormToSport(String formId, String sportId) {}
}
