import 'package:youth_app/data/Section.dart';

class Task {

  final int id;
  final String name;
  final DateTime date;
  final Section section;

  Task({this.id, this.date, this.name, this.section});

  factory Task.fromJson(var json) {
    var section;

    if(json['section'] != null)
      section = Section.fromJson(json['section']);

    return Task(
      id: json['id'],
      name: json['title'],
      date: DateTime.parse(json['date']),
      section: section,
    );
  }

  Map toJson() => {
    "title": this.name,
    "date": this.date,
    "section": this.section.toJson(),
  };

}