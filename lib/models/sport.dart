class Sport {
  final String sportId;
  final String activity;

  /// basic class, with a slightly-less-than basic pair of json functions
  /// to assist us in manuevering around a blocking postgres bug.
  Sport({required this.sportId, required this.activity});

  /// Static parsing function, used to read sport objects from assets

 /// Factory constructor to create a Sport object from JSON
  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      sportId: json['sport_id'],
      activity: json['activity'],
    );
  }

  /// Static method to parse a list of sports from JSON
  static List<Sport> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Sport.fromJson(item)).toList();
  }
}