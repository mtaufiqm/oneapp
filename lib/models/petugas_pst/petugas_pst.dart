// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PetugasPst {
  // uuid text pk
  // nama text [not null]
  // start_date text [not null]
  // end_date text [not null]
  // photo text
  String? uuid;
  String nama;
  String start_date;
  String end_date;
  String? photo;
  PetugasPst({
    this.uuid,
    required this.nama,
    required this.start_date,
    required this.end_date,
    this.photo,
  });

  PetugasPst copyWith({
    String? uuid,
    String? nama,
    String? start_date,
    String? end_date,
    String? photo,
  }) {
    return PetugasPst(
      uuid: uuid ?? this.uuid,
      nama: nama ?? this.nama,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      photo: photo ?? this.photo,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'nama': nama,
      'start_date': start_date,
      'end_date': end_date,
      'photo': photo,
    };
  }

  factory PetugasPst.fromJson(Map<String, dynamic> map) {
    return PetugasPst(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      nama: map['nama'] as String,
      start_date: map['start_date'] as String,
      end_date: map['end_date'] as String,
      photo: map['photo'] != null ? map['photo'] as String : null,
    );
  }

  factory PetugasPst.fromDb(Map<String, dynamic> map) {
    return PetugasPst(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      nama: map['nama'] as String,
      start_date: map['start_date'] as String,
      end_date: map['end_date'] as String,
      photo: map['photo'] != null ? map['photo'] as String : null,
    );
  }

  factory PetugasPst.fromDbPrefix(Map<String, dynamic> map, String prefix) {
    return PetugasPst(
      uuid: map['${prefix}_uuid'] != null ? map['${prefix}_uuid'] as String : null,
      nama: map['${prefix}_nama'] as String,
      start_date: map['${prefix}_start_date'] as String,
      end_date: map['${prefix}_end_date'] as String,
      photo: map['${prefix}_photo'] != null ? map['${prefix}_photo'] as String : null,
    );
  }


  @override
  String toString() {
    return 'PetugasPst(uuid: $uuid, nama: $nama, start_date: $start_date, end_date: $end_date, photo: $photo)';
  }

  @override
  bool operator ==(covariant PetugasPst other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.nama == nama &&
      other.start_date == start_date &&
      other.end_date == end_date &&
      other.photo == photo;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
      nama.hashCode ^
      start_date.hashCode ^
      end_date.hashCode ^
      photo.hashCode;
  }
}
