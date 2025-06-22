// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';
import 'package:my_first/models/kegiatan.dart';

class KuesionerPenilaianMitra {
  String? uuid;
  String kegiatan_uuid;
  String title;
  String description;
  String? start_date;
  String? end_date;
  KuesionerPenilaianMitra({
    this.uuid,
    required this.kegiatan_uuid,
    required this.title,
    required this.description,
    this.start_date,
    this.end_date,
  });

  KuesionerPenilaianMitra copyWith({
    String? uuid,
    String? kegiatan_uuid,
    String? title,
    String? description,
    String? start_date,
    String? end_date,
  }) {
    return KuesionerPenilaianMitra(
      uuid: uuid ?? this.uuid,
      kegiatan_uuid: kegiatan_uuid ?? this.kegiatan_uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'kegiatan_uuid': kegiatan_uuid,
      'title': title,
      'description': description,
      'start_date': start_date,
      'end_date': end_date,
    };
  }

  factory KuesionerPenilaianMitra.fromJson(Map<String, dynamic> map) {
    return KuesionerPenilaianMitra(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      kegiatan_uuid: map['kegiatan_uuid'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      start_date: map['start_date'] != null ? map['start_date'] as String : null,
      end_date: map['end_date'] != null ? map['end_date'] as String : null,
    );
  }

  @override
  String toString() {
    return 'KuesionerPenilaianMitra(uuid: $uuid, kegiatan_uuid: $kegiatan_uuid, title: $title, description: $description, start_date: $start_date, end_date: $end_date)';
  }
}

class KuesionerPenilaianMitraWithStructure {
  KuesionerPenilaianMitra penilaian;
  List<StructurePenilaianMitra> structure;
  KuesionerPenilaianMitraWithStructure({
    required this.penilaian,
    required this.structure,
  });

  KuesionerPenilaianMitraWithStructure copyWith({
    KuesionerPenilaianMitra? penilaian,
    List<StructurePenilaianMitra>? structure,
  }) {
    return KuesionerPenilaianMitraWithStructure(
      penilaian: penilaian ?? this.penilaian,
      structure: structure ?? this.structure,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'penilaian': penilaian.toJson(),
      'structure': structure.map((x) => x.toJson()).toList(),
    };
  }

  factory KuesionerPenilaianMitraWithStructure.fromJson(Map<String, dynamic> map) {
    return KuesionerPenilaianMitraWithStructure(
      penilaian: KuesionerPenilaianMitra.fromJson(map['penilaian'] as Map<String,dynamic>),
      structure: List<StructurePenilaianMitra>.from((map['structure'] as List<dynamic>).map<StructurePenilaianMitra>((x) => StructurePenilaianMitra.fromJson(x as Map<String,dynamic>)))
    );
  }

  @override
  String toString() => 'KuesionerPenilaianMitraWithStructure(penilaian: $penilaian, structure: $structure)';

  @override
  bool operator ==(covariant KuesionerPenilaianMitraWithStructure other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.penilaian == penilaian &&
      listEquals(other.structure, structure);
  }
}

class KuesionerPenilaianMitraDetails {
  String? uuid;
  Kegiatan? kegiatan;
  String title;
  String description;
  String? start_date;
  String? end_date;
  KuesionerPenilaianMitraDetails({
    this.uuid,
    this.kegiatan,
    required this.title,
    required this.description,
    this.start_date,
    this.end_date,
  });

  KuesionerPenilaianMitraDetails copyWith({
    String? uuid,
    Kegiatan? kegiatan,
    String? title,
    String? description,
    String? start_date,
    String? end_date,
  }) {
    return KuesionerPenilaianMitraDetails(
      uuid: uuid ?? this.uuid,
      kegiatan: kegiatan ?? this.kegiatan,
      title: title ?? this.title,
      description: description ?? this.description,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'kegiatan': kegiatan?.toJson(),
      'title': title,
      'description': description,
      'start_date': start_date,
      'end_date': end_date,
    };
  }

  factory KuesionerPenilaianMitraDetails.fromJson(Map<String, dynamic> map) {
    return KuesionerPenilaianMitraDetails(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      kegiatan: map['kegiatan'] != null ? Kegiatan.fromJson(map['kegiatan'] as Map<String,dynamic>) : null,
      title: map['title'] as String,
      description: map['description'] as String,
      start_date: map['start_date'] != null ? map['start_date'] as String : null,
      end_date: map['end_date'] != null ? map['end_date'] as String : null,
    );
  }

  @override
  String toString() {
    return 'KuesionerPenilaianMitraDetails(uuid: $uuid, kegiatan: $kegiatan, title: $title, description: $description, start_date: $start_date, end_date: $end_date)';
  }

  @override
  bool operator ==(covariant KuesionerPenilaianMitraDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.kegiatan == kegiatan &&
      other.title == title &&
      other.description == description &&
      other.start_date == start_date &&
      other.end_date == end_date;
  }
}
