// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


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
