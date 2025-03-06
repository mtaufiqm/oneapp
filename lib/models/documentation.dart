// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Documentation {
  // "uuid" text PRIMARY KEY,
  // "name" text,
  // "details" text,
  // "documentation_time" text,
  // "files_uuid" text,
  // "created_at" text,
  // "created_by" text,
  // "updated_at" text
  String? uuid;
  String name;
  String details;
  String documentation_time;
  String files_uuid;
  String created_at;
  String created_by;
  String updated_at;
  Documentation({
    this.uuid,
    required this.name,
    required this.details,
    required this.documentation_time,
    required this.files_uuid,
    required this.created_at,
    required this.created_by,
    required this.updated_at,
  });

  Documentation copyWith({
    String? uuid,
    String? name,
    String? details,
    String? documentation_time,
    String? files_uuid,
    String? created_at,
    String? created_by,
    String? updated_at,
  }) {
    return Documentation(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      details: details ?? this.details,
      documentation_time: documentation_time ?? this.documentation_time,
      files_uuid: files_uuid ?? this.files_uuid,
      created_at: created_at ?? this.created_at,
      created_by: created_by ?? this.created_by,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'name': name,
      'details': details,
      'documentation_time': documentation_time,
      'files_uuid': files_uuid,
      'created_at': created_at,
      'created_by': created_by,
      'updated_at': updated_at,
    };
  }

  factory Documentation.fromJson(Map<String, dynamic> map) {
    return Documentation(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      name: map['name'] as String,
      details: map['details'] as String,
      documentation_time: map['documentation_time'] as String,
      files_uuid: map['files_uuid'] as String,
      created_at: map['created_at'] as String,
      created_by: map['created_by'] as String,
      updated_at: map['updated_at'] as String,
    );
  }
}
