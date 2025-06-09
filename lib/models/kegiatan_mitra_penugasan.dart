// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/penugasan_history.dart';

class KegiatanMitraPenugasan {
  String? uuid;
  String bridge_uuid;
  String code;
  String group;
  int group_type_id;
  String group_desc;
  String description;
  String unit;
  int status;
  String? started_time;
  String? ended_time;
  String? location_latitude;
  String? location_longitude;
  String? notes;
  String created_at;
  String last_updated;
  KegiatanMitraPenugasan({
    this.uuid,
    required this.bridge_uuid,
    required this.code,
    required this.group,
    required this.group_type_id,
    required this.group_desc,
    required this.description,
    required this.unit,
    required this.status,
    this.started_time,
    this.ended_time,
    this.location_latitude,
    this.location_longitude,
    this.notes,
    required this.created_at,
    required this.last_updated,
  });

  KegiatanMitraPenugasan copyWith({
    String? uuid,
    String? bridge_uuid,
    String? code,
    String? group,
    int? group_type_id,
    String? group_desc,
    String? description,
    String? unit,
    int? status,
    String? started_time,
    String? ended_time,
    String? location_latitude,
    String? location_longitude,
    String? notes,
    String? created_at,
    String? last_updated,
  }) {
    return KegiatanMitraPenugasan(
      uuid: uuid ?? this.uuid,
      bridge_uuid: bridge_uuid ?? this.bridge_uuid,
      code: code ?? this.code,
      group: group ?? this.group,
      group_type_id: group_type_id ?? this.group_type_id,
      group_desc: group_desc ?? this.group_desc,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      started_time: started_time ?? this.started_time,
      ended_time: ended_time ?? this.ended_time,
      location_latitude: location_latitude ?? this.location_latitude,
      location_longitude: location_longitude ?? this.location_longitude,
      notes: notes ?? this.notes,
      created_at: created_at ?? this.created_at,
      last_updated: last_updated ?? this.last_updated,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'bridge_uuid': bridge_uuid,
      'code': code,
      'group': group,
      'group_type_id': group_type_id,
      'group_desc': group_desc,
      'description': description,
      'unit': unit,
      'status': status,
      'started_time': started_time,
      'ended_time': ended_time,
      'location_latitude': location_latitude,
      'location_longitude': location_longitude,
      'notes': notes,
      'created_at': created_at,
      'last_updated': last_updated,
    };
  }

  factory KegiatanMitraPenugasan.fromJson(Map<String, dynamic> map) {
    return KegiatanMitraPenugasan(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      bridge_uuid: map['bridge_uuid'] as String,
      code: map['code'] as String,
      group: map['group'] as String,
      group_type_id: map['group_type_id'] as int,
      group_desc: map['group_desc'] as String,
      description: map['description'] as String,
      unit: map['unit'] as String,
      status: map['status'] as int,
      started_time: map['started_time'] != null ? map['started_time'] as String : null,
      ended_time: map['ended_time'] != null ? map['ended_time'] as String : null,
      location_latitude: map['location_latitude'] != null ? map['location_latitude'] as String : null,
      location_longitude: map['location_longitude'] != null ? map['location_longitude'] as String : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      created_at: map['created_at'] as String,
      last_updated: map['last_updated'] as String,
    );
  }


  @override
  String toString() {
    return 'KegiatanMitraPenugasan(uuid: $uuid, bridge_uuid: $bridge_uuid, code: $code, group: $group, group_type_id: $group_type_id, group_desc: $group_desc, description: $description, unit: $unit, status: $status, started_time: $started_time, ended_time: $ended_time, location_latitude: $location_latitude, location_longitude: $location_longitude, notes: $notes, created_at: $created_at, last_updated: $last_updated)';
  }
}


class KegiatanMitraPenugasanDetails {
  String? uuid;
  String kegiatan_uuid;
  String kegiatan_name;
  String mitra_id;
  String mitra_name;
  String mitra_username;
  String code;
  String group;
  int group_type_id;
  String group_desc;
  String description;
  String unit;
  int status;
  String status_desc;
  String? started_time;
  String? ended_time;
  String? location_latitude;
  String? location_longitude;
  String? notes;
  String created_at;
  String last_updated;
  KegiatanMitraPenugasanDetails({
    this.uuid,
    required this.kegiatan_uuid,
    required this.kegiatan_name,
    required this.mitra_id,
    required this.mitra_name,
    required this.mitra_username,
    required this.code,
    required this.group,
    required this.group_type_id,
    required this.group_desc,
    required this.description,
    required this.unit,
    required this.status,
    required this.status_desc,
    this.started_time,
    this.ended_time,
    this.location_latitude,
    this.location_longitude,
    this.notes,
    required this.created_at,
    required this.last_updated,
  });

  KegiatanMitraPenugasanDetails copyWith({
    String? uuid,
    String? kegiatan_uuid,
    String? kegiatan_name,
    String? mitra_id,
    String? mitra_name,
    String? mitra_username,
    String? code,
    String? group,
    int? group_type_id,
    String? group_desc,
    String? description,
    String? unit,
    int? status,
    String? status_desc,
    String? started_time,
    String? ended_time,
    String? location_latitude,
    String? location_longitude,
    String? notes,
    String? created_at,
    String? last_updated,
  }) {
    return KegiatanMitraPenugasanDetails(
      uuid: uuid ?? this.uuid,
      kegiatan_uuid: kegiatan_uuid ?? this.kegiatan_uuid,
      kegiatan_name: kegiatan_name ?? this.kegiatan_name,
      mitra_id: mitra_id ?? this.mitra_id,
      mitra_name: mitra_name ?? this.mitra_name,
      mitra_username: mitra_username ?? this.mitra_username,
      code: code ?? this.code,
      group: group ?? this.group,
      group_type_id: group_type_id ?? this.group_type_id,
      group_desc: group_desc ?? this.group_desc,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      status_desc: status_desc ?? this.status_desc,
      started_time: started_time ?? this.started_time,
      ended_time: ended_time ?? this.ended_time,
      location_latitude: location_latitude ?? this.location_latitude,
      location_longitude: location_longitude ?? this.location_longitude,
      notes: notes ?? this.notes,
      created_at: created_at ?? this.created_at,
      last_updated: last_updated ?? this.last_updated,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'kegiatan_uuid': kegiatan_uuid,
      'kegiatan_name': kegiatan_name,
      'mitra_id': mitra_id,
      'mitra_name': mitra_name,
      'mitra_username': mitra_username,
      'code': code,
      'group': group,
      'group_type_id': group_type_id,
      'group_desc': group_desc,
      'description': description,
      'unit': unit,
      'status': status,
      'status_desc': status_desc,
      'started_time': started_time,
      'ended_time': ended_time,
      'location_latitude': location_latitude,
      'location_longitude': location_longitude,
      'notes': notes,
      'created_at': created_at,
      'last_updated': last_updated,
    };
  }

  factory KegiatanMitraPenugasanDetails.fromJson(Map<String, dynamic> map) {
    return KegiatanMitraPenugasanDetails(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      kegiatan_uuid: map['kegiatan_uuid'] as String,
      kegiatan_name: map['kegiatan_name'] as String,
      mitra_id: map['mitra_id'] as String,
      mitra_name: map['mitra_name'] as String,
      mitra_username: map['mitra_username'] as String,
      code: map['code'] as String,
      group: map['group'] as String,
      group_type_id: map['group_type_id'] as int,
      group_desc: map['group_desc'] as String,
      description: map['description'] as String,
      unit: map['unit'] as String,
      status: map['status'] as int,
      status_desc: map['status_desc'] as String,
      started_time: map['started_time'] != null ? map['started_time'] as String : null,
      ended_time: map['ended_time'] != null ? map['ended_time'] as String : null,
      location_latitude: map['location_latitude'] != null ? map['location_latitude'] as String : null,
      location_longitude: map['location_longitude'] != null ? map['location_longitude'] as String : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      created_at: map['created_at'] as String,
      last_updated: map['last_updated'] as String,
    );
  }

  @override
  String toString() {
    return 'KegiatanMitraPenugasanDetails(uuid: $uuid, kegiatan_uuid: $kegiatan_uuid, kegiatan_name: $kegiatan_name, mitra_id: $mitra_id, mitra_name: $mitra_name, mitra_username: $mitra_username, code: $code, group: $group, group_type_id: $group_type_id, group_desc: $group_desc, description: $description, unit: $unit, status: $status, status_desc: $status_desc, started_time: $started_time, ended_time: $ended_time, location_latitude: $location_latitude, location_longitude: $location_longitude, notes: $notes, created_at: $created_at, last_updated: $last_updated)';
  }

}

class KegiatanMitraPenugasanGroup {
  Map<String,dynamic> group;
  List<KegiatanMitraPenugasanDetails> penugasan;
  KegiatanMitraPenugasanGroup({
    required this.group,
    required this.penugasan,
  });

  KegiatanMitraPenugasanGroup copyWith({
    Map<String,dynamic>? group,
    List<KegiatanMitraPenugasanDetails>? penugasan,
  }) {
    return KegiatanMitraPenugasanGroup(
      group: group ?? this.group,
      penugasan: penugasan ?? this.penugasan,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'group': group,
      'penugasan': penugasan.map((x) => x.toJson()).toList(),
    };
  }

  factory KegiatanMitraPenugasanGroup.fromJson(Map<String, dynamic> map) {
    return KegiatanMitraPenugasanGroup(
      group: Map<String,dynamic>.from((map['group'] as Map<String,dynamic>)),
      penugasan: List<KegiatanMitraPenugasanDetails>.from((map['penugasan'] as List<dynamic>).map<KegiatanMitraPenugasanDetails>((x) => KegiatanMitraPenugasanDetails.fromJson(x as Map<String,dynamic>)))
    );
  }

  @override
  String toString() => 'KegiatanMitraPenugasanGroup(group: $group, penugasan: $penugasan)';
}

class KegiatanMitraPenugasanDetailsWithHistory {
  KegiatanMitraPenugasanDetails details;
  List<PenugasanHistoryDetails> history;
  KegiatanMitraPenugasanDetailsWithHistory({
    required this.details,
    required this.history,
  });

  KegiatanMitraPenugasanDetailsWithHistory copyWith({
    KegiatanMitraPenugasanDetails? details,
    List<PenugasanHistoryDetails>? history,
  }) {
    return KegiatanMitraPenugasanDetailsWithHistory(
      details: details ?? this.details,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'details': details.toJson(),
      'history': history.map((x) => x.toJson()).toList(),
    };
  }

  factory KegiatanMitraPenugasanDetailsWithHistory.fromJson(Map<String, dynamic> map) {
    return KegiatanMitraPenugasanDetailsWithHistory(
      details: KegiatanMitraPenugasanDetails.fromJson(map['details'] as Map<String,dynamic>),
      history: List<PenugasanHistoryDetails>.from((map['history'] as List<dynamic>).map<PenugasanHistoryDetails>((x) => PenugasanHistoryDetails.fromJson(x as Map<String,dynamic>)))
    );
  }

  @override
  String toString() => 'KegiatanMitraPenugasanDetailsWithHistory(details: $details, history: $history)';
}
