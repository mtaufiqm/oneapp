// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Kegiatan {
  // "id" text PRIMARY KEY,
  // "name" text,
  // "description" text,
  // "start" date,
  // "last" date,
  // "monitoring_link" text,
  // "organic_involved" boolean,
  // "organic_number" integer,
  // "mitra_involved" boolean,
  // "mitra_number" integer,
  // "createdby" text
  String? id;   //this using uuid;
  String name;
  String description;
  String start;
  String last;
  String monitoring_link;
  bool organic_involved;
  int organic_number;
  bool mitra_involved;
  int mitra_number;
  String createdby;

  Kegiatan({
    this.id,
    required this.name,
    required this.description,
    required this.start,
    required this.last,
    required this.monitoring_link,
    required this.organic_involved,
    required this.organic_number,
    required this.mitra_involved,
    required this.mitra_number,
    required this.createdby,
  });
  



  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'start': start,
      'last': last,
      'monitoring_link': monitoring_link,
      'organic_involved': organic_involved,
      'organic_number': organic_number,
      'mitra_involved': mitra_involved,
      'mitra_number': mitra_number,
      'createdby': createdby,
    };
  }

  factory Kegiatan.from(Map<String, dynamic> map) {
    return Kegiatan(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      description: map['description'] as String,
      start: map['start'] as String,
      last: map['last'] as String,
      monitoring_link: map['monitoring_link'] as String,
      organic_involved: map['organic_involved'] as bool,
      organic_number: map['organic_number'] as int,
      mitra_involved: map['mitra_involved'] as bool,
      mitra_number: map['mitra_number'] as int,
      createdby: map['createdby'] as String,
    );
  }

}