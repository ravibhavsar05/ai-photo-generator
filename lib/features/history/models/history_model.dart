class HistoryModel {
  final String path;
  final String title;
  final String tag; // Feature Name
  final DateTime date;

  HistoryModel({
    required this.path,
    required this.title,
    required this.tag,
    required this.date,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'title': title,
      'tag': tag,
      'date': date.toIso8601String(),
    };
  }

  // Create from JSON
  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      path: json['path'],
      title: json['title'],
      tag: json['tag'],
      date: DateTime.parse(json['date']),
    );
  }
}
