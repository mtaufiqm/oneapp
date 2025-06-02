// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';

//CONSIDER TO ADD "CATATAN/NOTE" COLUMN FOR THIS TABLE. IN DATABASE ALSO
class ResponseAssignment {
  String? uuid;
  String structure_uuid;
  String created_at;
  String updated_at;
  bool is_completed;
  String survei_uuid;
  String? notes;
  ResponseAssignment({
    this.uuid,
    required this.structure_uuid,
    required this.created_at,
    required this.updated_at,
    required this.is_completed,
    required this.survei_uuid,
    this.notes,
  });

  ResponseAssignment copyWith({
    String? uuid,
    String? structure_uuid,
    String? created_at,
    String? updated_at,
    bool? is_completed,
    String? survei_uuid,
    String? notes,
  }) {
    return ResponseAssignment(
      uuid: uuid ?? this.uuid,
      structure_uuid: structure_uuid ?? this.structure_uuid,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_completed: is_completed ?? this.is_completed,
      survei_uuid: survei_uuid ?? this.survei_uuid,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'structure_uuid': structure_uuid,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_completed': is_completed,
      'survei_uuid': survei_uuid,
      'notes': notes,
    };
  }

  factory ResponseAssignment.fromJson(Map<String, dynamic> map) {
    return ResponseAssignment(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      structure_uuid: map['structure_uuid'] as String,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
      is_completed: map['is_completed'] as bool,
      survei_uuid: map['survei_uuid'] as String,
      notes: map['notes'] != null ? map['notes'] as String : null,
    );
  }

  @override
  String toString() {
    return 'ResponseAssignment(uuid: $uuid, structure_uuid: $structure_uuid, created_at: $created_at, updated_at: $updated_at, is_completed: $is_completed, survei_uuid: $survei_uuid, notes: $notes)';
  }
}

