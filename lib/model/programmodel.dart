import 'dart:convert';

class ProgramModel {
  ProgramModel({
    required this.id,
    required this.name,
    required this.date,
  });

  int id;
  String name;
  String date;
  factory ProgramModel.fromJson(Map<String, dynamic> json) =>
      ProgramModel(id: json["id"], name: json["name"], date: json["date"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "date": date};
}
