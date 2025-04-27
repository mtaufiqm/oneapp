// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:my_first/models/kegiatan.dart';

class Mitra {
  String? mitra_id;
  String fullname;
  String nickname;
  String date_of_birth;
  String city_of_birth;
  String username;
  String email;
  Mitra({
    this.mitra_id,
    required this.fullname,
    required this.nickname,
    required this.date_of_birth,
    required this.city_of_birth,
    required this.username,
    required this.email,
  });

  Mitra copyWith({
    String? mitra_id,
    String? fullname,
    String? nickname,
    String? date_of_birth,
    String? city_of_birth,
    String? username,
    String? email,
  }) {
    return Mitra(
      mitra_id: mitra_id ?? this.mitra_id,
      fullname: fullname ?? this.fullname,
      nickname: nickname ?? this.nickname,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      city_of_birth: city_of_birth ?? this.city_of_birth,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'mitra_id': mitra_id,
      'fullname': fullname,
      'nickname': nickname,
      'date_of_birth': date_of_birth,
      'city_of_birth': city_of_birth,
      'username': username,
      'email': email,
    };
  }

  factory Mitra.fromJson(Map<String, dynamic> map) {
    return Mitra(
      mitra_id: map['mitra_id'] != null ? map['mitra_id'] as String : null,
      fullname: map['fullname'] as String,
      nickname: map['nickname'] as String,
      date_of_birth: map['date_of_birth'] as String,
      city_of_birth: map['city_of_birth'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
    );
  }

  @override
  String toString() {
    return 'Mitra(mitra_id: $mitra_id, fullname: $fullname, nickname: $nickname, date_of_birth: $date_of_birth, city_of_birth: $city_of_birth, username: $username, email: $email)';
  }
}


class MitraWithKegiatan {
  Mitra mitra;
  List<Kegiatan> kegiatan;
  MitraWithKegiatan({
    required this.mitra,
    required this.kegiatan,
  });

  MitraWithKegiatan copyWith({
    Mitra? mitra,
    List<Kegiatan>? kegiatan,
  }) {
    return MitraWithKegiatan(
      mitra: mitra ?? this.mitra,
      kegiatan: kegiatan ?? this.kegiatan,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'mitra': mitra.toJson(),
      'kegiatan': kegiatan.map((x) => x.toJson()).toList(),
    };
  }

  factory MitraWithKegiatan.fromJson(Map<String, dynamic> map) {
    return MitraWithKegiatan(
      mitra: Mitra.fromJson(map['mitra'] as Map<String,dynamic>),
      kegiatan: List<Kegiatan>.from((map['kegiatan'] as List<dynamic>).map<Kegiatan>((x) => Kegiatan.fromJson(x as Map<String,dynamic>)))
    );
  }

  @override
  String toString() => 'MitraWithKegiatan(mitra: $mitra, kegiatan: $kegiatan)';
}
