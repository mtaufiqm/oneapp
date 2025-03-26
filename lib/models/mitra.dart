// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Mitra {
  String? mitra_id;
  String fullname;
  String nickname;
  String date_of_birth;
  String city_of_birth;
  String username;
  Mitra({
    this.mitra_id,
    required this.fullname,
    required this.nickname,
    required this.date_of_birth,
    required this.city_of_birth,
    required this.username,
  });

  Mitra copyWith({
    String? mitra_id,
    String? fullname,
    String? nickname,
    String? date_of_birth,
    String? city_of_birth,
    String? username,
  }) {
    return Mitra(
      mitra_id: mitra_id ?? this.mitra_id,
      fullname: fullname ?? this.fullname,
      nickname: nickname ?? this.nickname,
      date_of_birth: date_of_birth ?? this.date_of_birth,
      city_of_birth: city_of_birth ?? this.city_of_birth,
      username: username ?? this.username,
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
    );
  }

  @override
  String toString() {
    return 'Mitra(mitra_id: $mitra_id, fullname: $fullname, nickname: $nickname, date_of_birth: $date_of_birth, city_of_birth: $city_of_birth, username: $username)';
  }

}
