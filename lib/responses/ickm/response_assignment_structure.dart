// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:my_first/models/ickm/questions_bloc.dart';
import 'package:my_first/models/ickm/response_assignment.dart';
import 'package:my_first/models/ickm/survei.dart';

class ResponseAssignmentStructure {
  String? kegiatan_uuid;
  String? kegiatan_name;
  String? kegiatan_start;
  String? kegiatan_end;
  String? penilai_username;
  String? penilai_name;
  String? mitra_id;
  String? mitra_username;
  String? mitra_name;


  String? mitra_status;
  List<String>? mitra_penugasan;
  
  ResponseAssignment? response;
  SurveiResponseStructure? survei;
  ResponseAssignmentStructure({
    this.kegiatan_uuid,
    this.kegiatan_name,
    this.kegiatan_start,
    this.kegiatan_end,
    this.penilai_username,
    this.penilai_name,
    this.mitra_id,
    this.mitra_username,
    this.mitra_name,
    this.mitra_status,
    this.mitra_penugasan,
    this.response,
    this.survei,
  });

  ResponseAssignmentStructure copyWith({
    String? kegiatan_uuid,
    String? kegiatan_name,
    String? kegiatan_start,
    String? kegiatan_end,
    String? penilai_username,
    String? penilai_name,
    String? mitra_id,
    String? mitra_username,
    String? mitra_name,
    String? mitra_status,
    List<String>? mitra_penugasan,
    ResponseAssignment? response,
    SurveiResponseStructure? survei,
  }) {
    return ResponseAssignmentStructure(
      kegiatan_uuid: kegiatan_uuid ?? this.kegiatan_uuid,
      kegiatan_name: kegiatan_name ?? this.kegiatan_name,
      kegiatan_start: kegiatan_start ?? this.kegiatan_start,
      kegiatan_end: kegiatan_end ?? this.kegiatan_end,
      penilai_username: penilai_username ?? this.penilai_username,
      penilai_name: penilai_name ?? this.penilai_name,
      mitra_id: mitra_id ?? this.mitra_id,
      mitra_username: mitra_username ?? this.mitra_username,
      mitra_name: mitra_name ?? this.mitra_name,
      mitra_status: mitra_status ?? this.mitra_status,
      mitra_penugasan: mitra_penugasan ?? this.mitra_penugasan,
      response: response ?? this.response,
      survei: survei ?? this.survei,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'kegiatan_uuid': kegiatan_uuid,
      'kegiatan_name': kegiatan_name,
      'kegiatan_start': kegiatan_start,
      'kegiatan_end': kegiatan_end,
      'penilai_username': penilai_username,
      'penilai_name': penilai_name,
      'mitra_id': mitra_id,
      'mitra_username': mitra_username,
      'mitra_name': mitra_name,
      'mitra_status': mitra_status,
      'mitra_penugasan': mitra_penugasan,
      'response': response?.toJson(),
      'survei': survei?.toJson(),
    };
  }

  factory ResponseAssignmentStructure.fromMap(Map<String, dynamic> map) {
    return ResponseAssignmentStructure(
      kegiatan_uuid: map['kegiatan_uuid'] != null ? map['kegiatan_uuid'] as String : null,
      kegiatan_name: map['kegiatan_name'] != null ? map['kegiatan_name'] as String : null,
      kegiatan_start: map['kegiatan_start'] != null ? map['kegiatan_start'] as String : null,
      kegiatan_end: map['kegiatan_end'] != null ? map['kegiatan_end'] as String : null,
      penilai_username: map['penilai_username'] != null ? map['penilai_username'] as String : null,
      penilai_name: map['penilai_name'] != null ? map['penilai_name'] as String : null,
      mitra_id: map['mitra_id'] != null ? map['mitra_id'] as String : null,
      mitra_username: map['mitra_username'] != null ? map['mitra_username'] as String : null,
      mitra_name: map['mitra_name'] != null ? map['mitra_name'] as String : null,
      mitra_status: map['mitra_status'] != null ? map['mitra_status'] as String : null,
      mitra_penugasan: map['mitra_penugasan'] != null ? List<String>.from((map['mitra_penugasan'] as List<String>)) : null,
      response: map['response'] != null ? ResponseAssignment.fromJson(map['response'] as Map<String,dynamic>) : null,
      survei: map['survei'] != null ? SurveiResponseStructure.fromJson(map['survei'] as Map<String,dynamic>) : null,
    );
  }
  
  @override
  String toString() {
    return 'ResponseAssignmentStructure(kegiatan_uuid: $kegiatan_uuid, kegiatan_name: $kegiatan_name, kegiatan_start: $kegiatan_start, kegiatan_end: $kegiatan_end, penilai_username: $penilai_username, penilai_name: $penilai_name, mitra_id: $mitra_id, mitra_username: $mitra_username, mitra_name: $mitra_name, mitra_status: $mitra_status, mitra_penugasan: $mitra_penugasan, response: $response, survei: $survei)';
  }

  @override
  bool operator ==(covariant ResponseAssignmentStructure other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.kegiatan_uuid == kegiatan_uuid &&
      other.kegiatan_name == kegiatan_name &&
      other.kegiatan_start == kegiatan_start &&
      other.kegiatan_end == kegiatan_end &&
      other.penilai_username == penilai_username &&
      other.penilai_name == penilai_name &&
      other.mitra_id == mitra_id &&
      other.mitra_username == mitra_username &&
      other.mitra_name == mitra_name &&
      other.mitra_status == mitra_status &&
      listEquals(other.mitra_penugasan, mitra_penugasan) &&
      other.response == response &&
      other.survei == survei;
  }
}
