// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class Pegawai {
  // "id" serial PRIMARY KEY,
  // "fullname" text,
  // "fullname_with_title" text,
  // "nickname" text,
  // "date_of_birth" date,
  // "city_of_birth" text,
  // "nip" text,
  // "old_nip" text,
  // "age" integer,
  // "username" text UNIQUE,
  // "status_pegawai" text
  int id;
  String fullname;
  String fullname_with_title;
  String nickname;
  String date_of_birth;
  String city_of_birth;
  String nip;
  String old_nip;
  int age;
  String username;
  String status_pegawai;
  Pegawai({
    required this.id,
    required this.fullname,
    required this.fullname_with_title,
    required this.nickname,
    required this.date_of_birth,
    required this.city_of_birth,
    required this.nip,
    required this.old_nip,
    required this.age,
    required this.username,
    required this.status_pegawai
  });

  
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'fullname': fullname,
      'fullname_with_title': fullname_with_title,
      'nickname': nickname,
      'date_of_birth': date_of_birth,
      'city_of_birth': city_of_birth,
      'nip': nip,
      'old_nip': old_nip,
      'age': age,
      'username': username,
      'status_pegawai': status_pegawai,
    };
  }

  factory Pegawai.from(Map<String, dynamic> map) {
    return Pegawai(
      id: map['id'] as int,
      fullname: map['fullname'] as String,
      fullname_with_title: map['fullname_with_title'] as String,
      nickname: map['nickname'] as String,
      date_of_birth: map['date_of_birth'] as String,
      city_of_birth: map['city_of_birth'] as String,
      nip: map['nip'] as String,
      old_nip: map['old_nip'] as String,
      age: map['age'] as int,
      username: map['username'] as String,
      status_pegawai: map['status_pegawai'] as String,
    );
  }
}
