// To parse this JSON data, do
//
//     final batchModel = batchModelFromJson(jsonString);

import 'dart:convert';

class DepartmentModel {
  DepartmentModel({
    required this.id,
    required this.departmentname,
  });

  int id;
  String departmentname;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      DepartmentModel(
        id: json["id"],
        departmentname: json["departmentname"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "departmentname": departmentname,
      };
}
