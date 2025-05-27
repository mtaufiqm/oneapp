// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PenugasanHistory {
  String? uuid;
  String penugasan_uuid;
  int status;
  String created_at;
  PenugasanHistory({
    this.uuid,
    required this.penugasan_uuid,
    required this.status,
    required this.created_at,
  });

  PenugasanHistory copyWith({
    String? uuid,
    String? penugasan_uuid,
    int? status,
    String? created_at,
  }) {
    return PenugasanHistory(
      uuid: uuid ?? this.uuid,
      penugasan_uuid: penugasan_uuid ?? this.penugasan_uuid,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'penugasan_uuid': penugasan_uuid,
      'status': status,
      'created_at': created_at,
    };
  }

  factory PenugasanHistory.fromJson(Map<String, dynamic> map) {
    return PenugasanHistory(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      penugasan_uuid: map['penugasan_uuid'] as String,
      status: map['status'] as int,
      created_at: map['created_at'] as String,
    );
  }

  @override
  String toString() {
    return 'PenugasanHistory(uuid: $uuid, penugasan_uuid: $penugasan_uuid, status: $status, created_at: $created_at)';
  }

}
