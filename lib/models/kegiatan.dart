// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:my_first/models/mitra.dart';

class Kegiatan {
  String? uuid;
  String name;
  String description;
  String start;
  String end;
  String monitoring_link;
  bool organic_involved;
  int organic_number;
  bool mitra_involved;
  int mitra_number;
  String created_by;
  String? penanggung_jawab;
  Kegiatan({
    this.uuid,
    required this.name,
    required this.description,
    required this.start,
    required this.end,
    required this.monitoring_link,
    required this.organic_involved,
    required this.organic_number,
    required this.mitra_involved,
    required this.mitra_number,
    required this.created_by,
    this.penanggung_jawab,
  });


  Kegiatan copyWith({
    String? uuid,
    String? name,
    String? description,
    String? start,
    String? end,
    String? monitoring_link,
    bool? organic_involved,
    int? organic_number,
    bool? mitra_involved,
    int? mitra_number,
    String? created_by,
    String? penanggung_jawab,
  }) {
    return Kegiatan(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      monitoring_link: monitoring_link ?? this.monitoring_link,
      organic_involved: organic_involved ?? this.organic_involved,
      organic_number: organic_number ?? this.organic_number,
      mitra_involved: mitra_involved ?? this.mitra_involved,
      mitra_number: mitra_number ?? this.mitra_number,
      created_by: created_by ?? this.created_by,
      penanggung_jawab: penanggung_jawab ?? this.penanggung_jawab,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'name': name,
      'description': description,
      'start': start,
      'end': end,
      'monitoring_link': monitoring_link,
      'organic_involved': organic_involved,
      'organic_number': organic_number,
      'mitra_involved': mitra_involved,
      'mitra_number': mitra_number,
      'created_by': created_by,
      'penanggung_jawab': penanggung_jawab,
    };
  }

  factory Kegiatan.fromJson(Map<String, dynamic> map) {
    return Kegiatan(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      name: map['name'] as String,
      description: map['description'] as String,
      start: map['start'] as String,
      end: map['end'] as String,
      monitoring_link: map['monitoring_link'] as String,
      organic_involved: map['organic_involved'] as bool,
      organic_number: map['organic_number'] as int,
      mitra_involved: map['mitra_involved'] as bool,
      mitra_number: map['mitra_number'] as int,
      created_by: map['created_by'] as String,
      penanggung_jawab: map['penanggung_jawab'] != null ? map['penanggung_jawab'] as String : null,
    );
  }

  @override
  String toString() {
    return 'Kegiatan(uuid: $uuid, name: $name, description: $description, start: $start, end: $end, monitoring_link: $monitoring_link, organic_involved: $organic_involved, organic_number: $organic_number, mitra_involved: $mitra_involved, mitra_number: $mitra_number, created_by: $created_by, penanggung_jawab: $penanggung_jawab)';
  }
}



class KegiatanWithMitra {
  Kegiatan kegiatan;
  List<Mitra> mitra;
  KegiatanWithMitra({
    required this.kegiatan,
    required this.mitra,
  });

  KegiatanWithMitra copyWith({
    Kegiatan? kegiatan,
    List<Mitra>? mitra,
  }) {
    return KegiatanWithMitra(
      kegiatan: kegiatan ?? this.kegiatan,
      mitra: mitra ?? this.mitra,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'kegiatan': kegiatan.toJson(),
      'mitra': mitra.map((x) => x.toJson()).toList(),
    };
  }

  factory KegiatanWithMitra.fromJson(Map<String, dynamic> map) {
    return KegiatanWithMitra(
      kegiatan: Kegiatan.fromJson(map['kegiatan'] as Map<String,dynamic>),
      mitra: List<Mitra>.from((map['mitra'] as List<dynamic>).map<Mitra>((x) => Mitra.fromJson(x as Map<String,dynamic>),),),
    );
  }

  @override
  String toString() => 'KegiatanWithMitra(kegiatan: $kegiatan, mitra: $mitra)';
}
