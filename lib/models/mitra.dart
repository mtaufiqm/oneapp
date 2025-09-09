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
  String? phone_number;
  String? address_code;
  String? address_detail;

  Mitra({
    this.mitra_id,
    required this.fullname,
    required this.nickname,
    required this.date_of_birth,
    required this.city_of_birth,
    required this.username,
    required this.email,
    this.phone_number,
    this.address_code,
    this.address_detail
  });

  Mitra copyWith({
    String? mitra_id,
    String? fullname,
    String? nickname,
    String? date_of_birth,
    String? city_of_birth,
    String? username,
    String? email,
    String? phone_number,
    String? address_code,
    String? address_detail,
  }) {
    return Mitra(
      mitra_id: mitra_id ?? this.mitra_id,
      fullname: fullname ?? this.fullname,
      nickname: nickname ?? this.nickname,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      city_of_birth: city_of_birth ?? this.city_of_birth,
      username: username ?? this.username,
      email: email ?? this.email,
      phone_number: phone_number ?? this.phone_number,
      address_code: address_code ?? this.address_code,
      address_detail: address_detail ?? this.address_detail,
    );
  }
  
  @override
  String toString() {
    return 'Mitra(mitra_id: $mitra_id, fullname: $fullname, nickname: $nickname, date_of_birth: $date_of_birth, city_of_birth: $city_of_birth, username: $username, email: $email, phone_number: $phone_number, address_code: $address_code, address_detail: $address_detail)';
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
      'phone_number': phone_number,
      'address_code': address_code,
      'address_detail': address_detail,
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
      phone_number: map['phone_number'] != null ? map['phone_number'] as String : null,
      address_code: map['address_code'] != null ? map['address_code'] as String : null,
      address_detail: map['address_detail'] != null ? map['address_detail'] as String : null,
    );
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

class MitraWithIckm {
  String? mitra_id;
  String fullname;
  String nickname;
  String date_of_birth;
  String city_of_birth;
  String username;
  String email;
  String? phone_number;
  String? address_code;
  String? address_detail;
  double? ickm;
  MitraWithIckm({
    this.mitra_id,
    required this.fullname,
    required this.nickname,
    required this.date_of_birth,
    required this.city_of_birth,
    required this.username,
    required this.email,
    this.phone_number,
    this.address_code,
    this.address_detail,
    this.ickm,
  });

  MitraWithIckm copyWith({
    String? mitra_id,
    String? fullname,
    String? nickname,
    String? date_of_birth,
    String? city_of_birth,
    String? username,
    String? email,
    String? phone_number,
    String? address_code,
    String? address_detail,
    double? ickm,
  }) {
    return MitraWithIckm(
      mitra_id: mitra_id ?? this.mitra_id,
      fullname: fullname ?? this.fullname,
      nickname: nickname ?? this.nickname,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      city_of_birth: city_of_birth ?? this.city_of_birth,
      username: username ?? this.username,
      email: email ?? this.email,
      phone_number: phone_number ?? this.phone_number,
      address_code: address_code ?? this.address_code,
      address_detail: address_detail ?? this.address_detail,
      ickm: ickm ?? this.ickm,
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
      'phone_number': phone_number,
      'address_code': address_code,
      'address_detail': address_detail,
      'ickm': ickm,
    };
  }

  factory MitraWithIckm.fromJson(Map<String, dynamic> map) {
    return MitraWithIckm(
      mitra_id: map['mitra_id'] != null ? map['mitra_id'] as String : null,
      fullname: map['fullname'] as String,
      nickname: map['nickname'] as String,
      date_of_birth: map['date_of_birth'] as String,
      city_of_birth: map['city_of_birth'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      phone_number: map['phone_number'] != null ? map['phone_number'] as String : null,
      address_code: map['address_code'] != null ? map['address_code'] as String : null,
      address_detail: map['address_detail'] != null ? map['address_detail'] as String : null,
      ickm: map['ickm'] != null ? map['ickm'] as double : null,
    );
  }

  factory MitraWithIckm.fromDb(Map<String, dynamic> map) {
    return MitraWithIckm(
      mitra_id: map['mitra_id'] != null ? map['mitra_id'] as String : null,
      fullname: map['fullname'] as String,
      nickname: map['nickname'] as String,
      date_of_birth: map['date_of_birth'] as String,
      city_of_birth: map['city_of_birth'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      phone_number: map['phone_number'] != null ? map['phone_number'] as String : null,
      address_code: map['address_code'] != null ? map['address_code'] as String : null,
      address_detail: map['address_detail'] != null ? map['address_detail'] as String : null,
      ickm: map['ickm'] != null ? map['ickm'] as double : null,
    );
  }

  @override
  String toString() {
    return 'MitraWithIckm(mitra_id: $mitra_id, fullname: $fullname, nickname: $nickname, date_of_birth: $date_of_birth, city_of_birth: $city_of_birth, username: $username, email: $email, phone_number: $phone_number, address_code: $address_code, address_detail: $address_detail, ickm: $ickm)';
  }

  @override
  bool operator ==(covariant MitraWithIckm other) {
    if (identical(this, other)) return true;
  
    return 
      other.mitra_id == mitra_id &&
      other.fullname == fullname &&
      other.nickname == nickname &&
      other.date_of_birth == date_of_birth &&
      other.city_of_birth == city_of_birth &&
      other.username == username &&
      other.email == email &&
      other.phone_number == phone_number &&
      other.address_code == address_code &&
      other.address_detail == address_detail &&
      other.ickm == ickm;
  }

  @override
  int get hashCode {
    return mitra_id.hashCode ^
      fullname.hashCode ^
      nickname.hashCode ^
      date_of_birth.hashCode ^
      city_of_birth.hashCode ^
      username.hashCode ^
      email.hashCode ^
      phone_number.hashCode ^
      address_code.hashCode ^
      address_detail.hashCode ^
      ickm.hashCode;
  }
}

