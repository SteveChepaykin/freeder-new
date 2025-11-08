const String tableTexts = 'texts';

class SavedTextFields {
  static final List<String> values = [id, title, wholetext, lastindex, timecreated];

  static const String id = '_id';
  static const String title = 'title';
  static const String wholetext = 'wholetext';
  static const String lastindex = 'lastindex';
  // static final String lastopenedtime = 'lastopenedtime';
  static const String timecreated = 'timecreated';
}

class SavedText {
  final int? id;
  final String title;
  final String wholetext;
  final int lastindex;
  // final DateTime lastopenedtime;
  final DateTime timecreated;

  SavedText({
    this.id,
    required this.title,
    required this.wholetext,
    required this.lastindex,
    // required this.lastopenedtime,
    required this.timecreated,
  });

  Map<String, Object?> toJson() => {
        SavedTextFields.id: id,
        SavedTextFields.title: title,
        SavedTextFields.wholetext: wholetext,
        SavedTextFields.lastindex: lastindex,
        SavedTextFields.timecreated: timecreated.toIso8601String(),
      };

  static SavedText fromJson(Map<String, Object?> json) => SavedText(
        id: json[SavedTextFields.id] as int,
        title: json[SavedTextFields.timecreated] as String,
        wholetext: json[SavedTextFields.wholetext] as String,
        lastindex: json[SavedTextFields.lastindex] as int,
        // lastopenedtime: DateTime.parse(json[SavedTextFields.lastopenedtime] as String),
        timecreated: DateTime.parse(json[SavedTextFields.timecreated] as String),
      );

  SavedText copy({
    int? id,
    String? title,
    String? wholetext,
    int? lastindex,
    DateTime? timecreated,
    // DateTime? lastopenedtime,
  }) =>
      SavedText(
        id: id ?? this.id,
        title: title ?? this.title,
        wholetext: wholetext ?? this.wholetext,
        lastindex: lastindex ?? this.lastindex,
        // lastopenedtime: lastopenedtime ?? this.lastopenedtime,
        timecreated: timecreated ?? this.timecreated,
      );
}
