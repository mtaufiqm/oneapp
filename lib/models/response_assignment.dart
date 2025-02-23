// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ResponseAssignment {
  // "id" serial PRIMARY KEY,
  // "uuid" text UNIQUE,
  // "structure_uuid" text,
  // "type_kuesioner" text,
  // "status" bool
  int? id;
  String uuid;
  String structure_uuid;
  String type_kuesioner;
  bool status;
  ResponseAssignment({
    this.id,
    required this.uuid,
    required this.structure_uuid,
    required this.type_kuesioner,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'structure_uuid': structure_uuid,
      'type_kuesioner': type_kuesioner,
      'status': status,
    };
  }

  factory ResponseAssignment.from(Map<String, dynamic> map) {
    return ResponseAssignment(
      id: map['id'] != null ? map['id'] as int : null,
      uuid: map['uuid'] as String,
      structure_uuid: map['structure_uuid'] as String,
      type_kuesioner: map['type_kuesioner'] as String,
      status: map['status'] as bool,
    );
  }
}
