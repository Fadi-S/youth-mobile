import 'package:youth_app/data/Task.dart';

class Section {

  final String name;
  final String slug;
  final List<Task> tasks;

  Section({this.slug, this.name, this.tasks});

  factory Section.fromJson(var json) {

    if(json['tasks'] != null) {
      List tasks = json['tasks'];

      tasks = tasks.map<Task>((task) => Task.fromJson(task)).toList();

      return Section(
        name: json['name'],
        slug: json['slug'],
        tasks: tasks,
      );
    }

    return Section(
      name: json['name'],
      slug: json['slug'],
    );
  }

  Map toJson() => {
    "name": this.name,
    "slug": this.slug,
  };

  static List<Section> fromList(List sections) => sections.map<Section>((e) => Section.fromJson(e)).toList();

}