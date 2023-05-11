// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    ProfileModel({
        required this.name,
        required this.phone,
        required this.email,
        required this.batchname,
        required this.departmentname,
        required this.bloodgrp,
        required this.profile,
        required this.unitno
    });

    String name;
    String phone;
    String email;
    String batchname;
    String departmentname;
    String bloodgrp;
    String profile,unitno;

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        batchname: json["batchname"],
        departmentname: json["departmentname"],
        bloodgrp: json["bloodgrp"],
        profile: json["profile"],
        unitno:json["unitno"]
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "email": email,
        "batchname": batchname,
        "departmentname": departmentname,
        "bloodgrp": bloodgrp,
        "profile": profile,
        "unitno":unitno
    };
}
