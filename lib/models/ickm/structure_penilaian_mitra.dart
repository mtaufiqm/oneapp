// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StructurePenilaianMitra {
  String? uuid;
  String kuesioner_penilaian_mitra_uuid;
  String? penilai_username;
  String? mitra_username;
  String? survei_uuid;
  StructurePenilaianMitra({
    this.uuid,
    required this.kuesioner_penilaian_mitra_uuid,
    this.penilai_username,
    this.mitra_username,
    this.survei_uuid,
  });

  StructurePenilaianMitra copyWith({
    String? uuid,
    String? kuesioner_penilaian_mitra_uuid,
    String? penilai_username,
    String? mitra_username,
    String? survei_uuid,
  }) {
    return StructurePenilaianMitra(
      uuid: uuid ?? this.uuid,
      kuesioner_penilaian_mitra_uuid: kuesioner_penilaian_mitra_uuid ?? this.kuesioner_penilaian_mitra_uuid,
      penilai_username: penilai_username ?? this.penilai_username,
      mitra_username: mitra_username ?? this.mitra_username,
      survei_uuid: survei_uuid ?? this.survei_uuid,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'kuesioner_penilaian_mitra_uuid': kuesioner_penilaian_mitra_uuid,
      'penilai_username': penilai_username,
      'mitra_username': mitra_username,
      'survei_uuid': survei_uuid,
    };
  }

  factory StructurePenilaianMitra.fromJson(Map<String, dynamic> map) {
    return StructurePenilaianMitra(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      kuesioner_penilaian_mitra_uuid: map['kuesioner_penilaian_mitra_uuid'] as String,
      penilai_username: map['penilai_username'] != null ? map['penilai_username'] as String : null,
      mitra_username: map['mitra_username'] != null ? map['mitra_username'] as String : null,
      survei_uuid: map['survei_uuid'] != null ? map['survei_uuid'] as String : null,
    );
  }

  @override
  String toString() {
    return 'StructurePenilaianMitra(uuid: $uuid, kuesioner_penilaian_mitra_uuid: $kuesioner_penilaian_mitra_uuid, penilai_username: $penilai_username, mitra_username: $mitra_username, survei_uuid: $survei_uuid)';
  }

  @override
  bool operator ==(covariant StructurePenilaianMitra other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.kuesioner_penilaian_mitra_uuid == kuesioner_penilaian_mitra_uuid &&
      other.penilai_username == penilai_username &&
      other.mitra_username == mitra_username &&
      other.survei_uuid == survei_uuid;
  }
}

class StructurePenilaianMitraDetails {
  String? uuid;
  String kuesioner_penilaian_mitra_uuid;
  String kuesioner_penilaian_mitra_title;
  String kuesioner_penilaian_mitra_start_date;
  String kuesioner_penilaian_mitra_end_date;
  String? kegiatan_uuid;
  String? kegiatan_name;
  String? penilai_username;
  String? penilai_fullname;
  String? mitra_username;
  String? mitra_id;
  String? mitra_fullname;
  String? survei_uuid;
  String? survei_name;
  String? survei_type;
  bool? isHaveResponse;
  String? response_uuid;
  bool? response_is_completed;
  String? response_updated_at;
  StructurePenilaianMitraDetails({
    this.uuid,
    required this.kuesioner_penilaian_mitra_uuid,
    required this.kuesioner_penilaian_mitra_title,
    required this.kuesioner_penilaian_mitra_start_date,
    required this.kuesioner_penilaian_mitra_end_date,
    this.kegiatan_uuid,
    this.kegiatan_name,
    this.penilai_username,
    this.penilai_fullname,
    this.mitra_username,
    this.mitra_id,
    this.mitra_fullname,
    this.survei_uuid,
    this.survei_name,
    this.survei_type,
    this.isHaveResponse,
    this.response_uuid,
    this.response_is_completed,
    this.response_updated_at,
  });

  StructurePenilaianMitraDetails copyWith({
    String? uuid,
    String? kuesioner_penilaian_mitra_uuid,
    String? kuesioner_penilaian_mitra_title,
    String? kuesioner_penilaian_mitra_start_date,
    String? kuesioner_penilaian_mitra_end_date,
    String? kegiatan_uuid,
    String? kegiatan_name,
    String? penilai_username,
    String? penilai_fullname,
    String? mitra_username,
    String? mitra_id,
    String? mitra_fullname,
    String? survei_uuid,
    String? survei_name,
    String? survei_type,
    bool? isHaveResponse,
    String? response_uuid,
    bool? response_is_completed,
    String? response_updated_at,
  }) {
    return StructurePenilaianMitraDetails(
      uuid: uuid ?? this.uuid,
      kuesioner_penilaian_mitra_uuid: kuesioner_penilaian_mitra_uuid ?? this.kuesioner_penilaian_mitra_uuid,
      kuesioner_penilaian_mitra_title: kuesioner_penilaian_mitra_title ?? this.kuesioner_penilaian_mitra_title,
      kuesioner_penilaian_mitra_start_date: kuesioner_penilaian_mitra_start_date ?? this.kuesioner_penilaian_mitra_start_date,
      kuesioner_penilaian_mitra_end_date: kuesioner_penilaian_mitra_end_date ?? this.kuesioner_penilaian_mitra_end_date,
      kegiatan_uuid: kegiatan_uuid ?? this.kegiatan_uuid,
      kegiatan_name: kegiatan_name ?? this.kegiatan_name,
      penilai_username: penilai_username ?? this.penilai_username,
      penilai_fullname: penilai_fullname ?? this.penilai_fullname,
      mitra_username: mitra_username ?? this.mitra_username,
      mitra_id: mitra_id ?? this.mitra_id,
      mitra_fullname: mitra_fullname ?? this.mitra_fullname,
      survei_uuid: survei_uuid ?? this.survei_uuid,
      survei_name: survei_name ?? this.survei_name,
      survei_type: survei_type ?? this.survei_type,
      isHaveResponse: isHaveResponse ?? this.isHaveResponse,
      response_uuid: response_uuid ?? this.response_uuid,
      response_is_completed: response_is_completed ?? this.response_is_completed,
      response_updated_at: response_updated_at ?? this.response_updated_at,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'kuesioner_penilaian_mitra_uuid': kuesioner_penilaian_mitra_uuid,
      'kuesioner_penilaian_mitra_title': kuesioner_penilaian_mitra_title,
      'kuesioner_penilaian_mitra_start_date': kuesioner_penilaian_mitra_start_date,
      'kuesioner_penilaian_mitra_end_date': kuesioner_penilaian_mitra_end_date,
      'kegiatan_uuid': kegiatan_uuid,
      'kegiatan_name': kegiatan_name,
      'penilai_username': penilai_username,
      'penilai_fullname': penilai_fullname,
      'mitra_username': mitra_username,
      'mitra_id': mitra_id,
      'mitra_fullname': mitra_fullname,
      'survei_uuid': survei_uuid,
      'survei_name': survei_name,
      'survei_type': survei_type,
      'isHaveResponse': isHaveResponse,
      'response_uuid': response_uuid,
      'response_is_completed': response_is_completed,
      'response_updated_at': response_updated_at,
    };
  }

  factory StructurePenilaianMitraDetails.fromJson(Map<String, dynamic> map) {
    return StructurePenilaianMitraDetails(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      kuesioner_penilaian_mitra_uuid: map['kuesioner_penilaian_mitra_uuid'] as String,
      kuesioner_penilaian_mitra_title: map['kuesioner_penilaian_mitra_title'] as String,
      kuesioner_penilaian_mitra_start_date: map['kuesioner_penilaian_mitra_start_date'] as String,
      kuesioner_penilaian_mitra_end_date: map['kuesioner_penilaian_mitra_end_date'] as String,
      kegiatan_uuid: map['kegiatan_uuid'] != null ? map['kegiatan_uuid'] as String : null,
      kegiatan_name: map['kegiatan_name'] != null ? map['kegiatan_name'] as String : null,
      penilai_username: map['penilai_username'] != null ? map['penilai_username'] as String : null,
      penilai_fullname: map['penilai_fullname'] != null ? map['penilai_fullname'] as String : null,
      mitra_username: map['mitra_username'] != null ? map['mitra_username'] as String : null,
      mitra_id: map['mitra_id'] != null ? map['mitra_id'] as String : null,
      mitra_fullname: map['mitra_fullname'] != null ? map['mitra_fullname'] as String : null,
      survei_uuid: map['survei_uuid'] != null ? map['survei_uuid'] as String : null,
      survei_name: map['survei_name'] != null ? map['survei_name'] as String : null,
      survei_type: map['survei_type'] != null ? map['survei_type'] as String : null,
      isHaveResponse: map['isHaveResponse'] != null ? map['isHaveResponse'] as bool : null,
      response_uuid: map['response_uuid'] != null ? map['response_uuid'] as String : null,
      response_is_completed: map['response_is_completed'] != null ? map['response_is_completed'] as bool : null,
      response_updated_at: map['response_updated_at'] != null ? map['response_updated_at'] as String : null,
    );
  }

  @override
  String toString() {
    return 'StructurePenilaianMitraDetails(uuid: $uuid, kuesioner_penilaian_mitra_uuid: $kuesioner_penilaian_mitra_uuid, kuesioner_penilaian_mitra_title: $kuesioner_penilaian_mitra_title, kuesioner_penilaian_mitra_start_date: $kuesioner_penilaian_mitra_start_date, kuesioner_penilaian_mitra_end_date: $kuesioner_penilaian_mitra_end_date, kegiatan_uuid: $kegiatan_uuid, kegiatan_name: $kegiatan_name, penilai_username: $penilai_username, penilai_fullname: $penilai_fullname, mitra_username: $mitra_username, mitra_id: $mitra_id, mitra_fullname: $mitra_fullname, survei_uuid: $survei_uuid, survei_name: $survei_name, survei_type: $survei_type, isHaveResponse: $isHaveResponse, response_uuid: $response_uuid, response_is_completed: $response_is_completed, response_updated_at: $response_updated_at)';
  }

  @override
  bool operator ==(covariant StructurePenilaianMitraDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.kuesioner_penilaian_mitra_uuid == kuesioner_penilaian_mitra_uuid &&
      other.kuesioner_penilaian_mitra_title == kuesioner_penilaian_mitra_title &&
      other.kuesioner_penilaian_mitra_start_date == kuesioner_penilaian_mitra_start_date &&
      other.kuesioner_penilaian_mitra_end_date == kuesioner_penilaian_mitra_end_date &&
      other.kegiatan_uuid == kegiatan_uuid &&
      other.kegiatan_name == kegiatan_name &&
      other.penilai_username == penilai_username &&
      other.penilai_fullname == penilai_fullname &&
      other.mitra_username == mitra_username &&
      other.mitra_id == mitra_id &&
      other.mitra_fullname == mitra_fullname &&
      other.survei_uuid == survei_uuid &&
      other.survei_name == survei_name &&
      other.survei_type == survei_type &&
      other.isHaveResponse == isHaveResponse &&
      other.response_uuid == response_uuid &&
      other.response_is_completed == response_is_completed &&
      other.response_updated_at == response_updated_at;
  }
}
