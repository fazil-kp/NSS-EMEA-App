// To parse this JSON data, do
//
//     final attandanceModel = attandanceModelFromJson(jsonString);

import 'dart:convert';

AttandanceModel attandanceModelFromJson(String str) => AttandanceModel.fromJson(json.decode(str));

String attandanceModelToJson(AttandanceModel data) => json.encode(data.toJson());

class AttandanceModel {
    AttandanceModel({
        required this.id,
        required this.attandance,
    });

    int id;
    String attandance;

    factory AttandanceModel.fromJson(Map<String, dynamic> json) => AttandanceModel(
        id: json["id"],
        attandance: json["attandance"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "attandance": attandance,
    };
}
