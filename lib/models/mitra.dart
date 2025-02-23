// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';



class Mitra {
  // "mitraId" text PRIMARY KEY,
  // "fullname" text,
  // "nickname" text,
  // "date_of_birth" date,
  // "city_of_birth" text,
  // "username" text UNIQUE
  String? mitraId;
  String fullname;
  String nickname;
  String date_of_birth;
  String city_of_birth;
  String username;

  Mitra({
    required this.mitraId,
    required this.fullname,
    required this.nickname,
    required this.date_of_birth,
    required this.city_of_birth,
    required this.username
  });


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'mitraId': mitraId,
      'fullname': fullname,
      'nickname': nickname,
      'date_of_birth': date_of_birth,
      'city_of_birth': city_of_birth,
      'username': username,
    };
  }

  factory Mitra.from(Map<String, dynamic> map) {
    return Mitra(
      mitraId: map['mitraId'] != null ? map['mitraId'] as String : null,
      fullname: map['fullname'] as String,
      nickname: map['nickname'] as String,
      date_of_birth: map['date_of_birth'] as String,
      city_of_birth: map['city_of_birth'] as String,
      username: map['username'] as String,
    );
  }
}
