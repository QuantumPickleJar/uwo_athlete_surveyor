///
///
/// Bugs:  Couldn't get transactions to work, so we opted for a less efficient (but 
/// more importantly, it worked)) design that loads the 
///
import 'dart:js';
import 'package:athlete_surveyor/models/sport.dart';
import 'package:athlete_surveyor/models/sport_selection_model.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:athlete_surveyor/services/db.dart';
import 'package:provider/provider.dart';

/// Simple repository for interacting with stored values for the available sports to pick from
class SportsRepository {
  Future<Connection> get _connection async => await PostgresDB.getConnection();
  /// We could put a list here since sports probably wont get added too often after initial setup
 

  /// workaround constructor to bypass the need for a transaction query
  /// (allows us to shift the second)
  SportsRepository();

  /// Fetches all Sports from the database, returning them in a Future as a List<Sport>
  Future<List<Sport>> getAllSports() async {
    var db = await _connection;
    try {
      String sqlStatement = "SELECT sport_id, activity FROM public.tbl_sports;";
      var result = await db.execute(Sql.named(sqlStatement));
      return result.map((row) => Sport(
        sportId: row.toColumnMap()['sport_id'],
        activity: row.toColumnMap()['activity'],
      )).toList();
    } finally {
       await PostgresDB.closeConnection();

    }
  }
  /// Fetches a single sport by ID
  Future<String?> getSportById(String sportId) async {
    var db = await PostgresDB.getConnection();

    try {
      String sql = 'SELECT activity FROM tbl_sports WHERE sport_id = @sportId;';
      var results = await db.execute(sql, parameters: {'sportId': sportId});
      if (results.isNotEmpty) {
        return results.first[0] as String;
      }
      return null;
    } finally {
      await PostgresDB.closeConnection();
    }
  }


  Future<String?> getSportIdByName(String sportName) async {
    var db = await PostgresDB.getConnection();
    try {
      debugPrint('Connecting to DB for sportName: $sportName');
      String sql = 'SELECT sport_id FROM tbl_sports WHERE activity = @sportName;';
      var results = await db.execute(Sql.named(sql), parameters: {'sportName': sportName});
      debugPrint('Query executed for sportName: $sportName');
      if (results.isNotEmpty) {
        debugPrint('Sport ID found: ${results.first[0]}');
        return results.first[0].toString();
      } else {
        debugPrint('No Sport ID found for sportName: $sportName');
      }
      return null;
    } catch (e) {
      debugPrint('Error in getSportIdByName: $e');
      rethrow;
    } finally {
      try {
        await PostgresDB.closeConnection();
      } catch (closeError) {
        debugPrint('Error closing the database connection: $closeError');
      }
    }
  }
}
