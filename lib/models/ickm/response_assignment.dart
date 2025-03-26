// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


//CONSIDER TO ADD "CATATAN/NOTE" COLUMN FOR THIS TABLE. IN DATABASE ALSO
class ResponseAssignment {
  String? uuid;
  String structure_uuid;
  String created_at;
  String updated_at;
  bool is_completed;
  String survei_type;
  String notes;
  ResponseAssignment({
    this.uuid,
    required this.structure_uuid,
    required this.created_at,
    required this.updated_at,
    required this.is_completed,
    required this.survei_type,
    required this.notes,
  });

  ResponseAssignment copyWith({
    String? uuid,
    String? structure_uuid,
    String? created_at,
    String? updated_at,
    bool? is_completed,
    String? survei_type,
    String? notes,
  }) {
    return ResponseAssignment(
      uuid: uuid ?? this.uuid,
      structure_uuid: structure_uuid ?? this.structure_uuid,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_completed: is_completed ?? this.is_completed,
      survei_type: survei_type ?? this.survei_type,
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
      'survei_type': survei_type,
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
      survei_type: map['survei_type'] as String,
      notes: map['notes'] as String,
    );
  }

  @override
  String toString() {
    return 'ResponseAssignment(uuid: $uuid, structure_uuid: $structure_uuid, created_at: $created_at, updated_at: $updated_at, is_completed: $is_completed, survei_type: $survei_type, notes: $notes)';
  }

}
