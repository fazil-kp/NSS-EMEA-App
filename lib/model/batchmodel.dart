// To parse this JSON data, do
//
//     final batchModel = batchModelFromJson(jsonString);

import 'dart:convert';

List<BatchModel> batchModelFromJson(String str) =>
    List<BatchModel>.from(json.decode(str).map((x) => BatchModel.fromJson(x)));

String batchModelToJson(List<BatchModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BatchModel {
  BatchModel({
    required this.id,
    required this.batchname,
  });

  int id;
  String batchname;

  factory BatchModel.fromJson(Map<String, dynamic> json) => BatchModel(
        id: json["id"],
        batchname: json["batchname"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "batchname": batchname,
      };
}
