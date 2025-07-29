// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:my_first/models/kegiatan.dart';

class KegiatanMitraBridge {
  String? uuid;
  String kegiatan_uuid;
  String mitra_id;
  String status;
  String? pengawas;
  KegiatanMitraBridge({
    this.uuid,
    required this.kegiatan_uuid,
    required this.mitra_id,
    required this.status,
    this.pengawas,
  });

  KegiatanMitraBridge copyWith({
    String? uuid,
    String? kegiatan_uuid,
    String? mitra_id,
    String? status,
    String? pengawas,
  }) {
    return KegiatanMitraBridge(
      uuid: uuid ?? this.uuid,
      kegiatan_uuid: kegiatan_uuid ?? this.kegiatan_uuid,
      mitra_id: mitra_id ?? this.mitra_id,
      status: status ?? this.status,
      pengawas: pengawas ?? this.pengawas,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'kegiatan_uuid': kegiatan_uuid,
      'mitra_id': mitra_id,
      'status': status,
      'pengawas': pengawas,
    };
  }

  factory KegiatanMitraBridge.fromJson(Map<String, dynamic> map) {
    return KegiatanMitraBridge(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      kegiatan_uuid: map['kegiatan_uuid'] as String,
      mitra_id: map['mitra_id'] as String,
      status: map['status'] as String,
      pengawas: map['pengawas'] != null ? map['pengawas'] as String : null,
    );
  }

  
  factory KegiatanMitraBridge.fromDb(Map<String, dynamic> map) {
    return KegiatanMitraBridge(
      uuid: map['kmb_uuid'] != null ? map['kmb_uuid'] as String : null,
      kegiatan_uuid: map['kmb_kegiatan_uuid'] as String,
      mitra_id: map['kmb_mitra_id'] as String,
      status: map['kmb_status'] as String,
      pengawas: map['kmb_pengawas'] != null ? map['kmb_pengawas'] as String : null,
    );
  }

  @override
  String toString() {
    return 'KegiatanMitraBridge(uuid: $uuid, kegiatan_uuid: $kegiatan_uuid, mitra_id: $mitra_id, status: $status, pengawas: $pengawas)';
  }

  @override
  bool operator ==(covariant KegiatanMitraBridge other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.kegiatan_uuid == kegiatan_uuid &&
      other.mitra_id == mitra_id &&
      other.status == status &&
      other.pengawas == pengawas;
  }
}


class KegiatanMitraBridgeDetails {
  Kegiatan kegiatan;
  KegiatanMitraBridge status;
  KegiatanMitraBridgeDetails({
    required this.kegiatan,
    required this.status,
  });

  KegiatanMitraBridgeDetails copyWith({
    Kegiatan? kegiatan,
    KegiatanMitraBridge? status,
  }) {
    return KegiatanMitraBridgeDetails(
      kegiatan: kegiatan ?? this.kegiatan,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'kegiatan': kegiatan.toJson(),
      'status': status.toJson(),
    };
  }

  factory KegiatanMitraBridgeDetails.fromJson(Map<String, dynamic> map) {
    return KegiatanMitraBridgeDetails(
      kegiatan: Kegiatan.fromJson(map['kegiatan'] as Map<String,dynamic>),
      status: KegiatanMitraBridge.fromJson(map['status'] as Map<String,dynamic>),
    );
  }

   @override
  String toString() => 'KegiatanMitraBridgeDetails(kegiatan: $kegiatan, status: $status)';
  
}

class KegiatanMitraBridgeMoreDetails {
  String? uuid;
  String kegiatan_uuid;
  String kegiatan_name;
  String mitra_id;
  String mitra_username;
  String mitra_fullname;
  String status;
  String? pengawas_username;
  String? pengawas_name;
  bool? is_pengawas_organic;
  KegiatanMitraBridgeMoreDetails({
    this.uuid,
    required this.kegiatan_uuid,
    required this.kegiatan_name,
    required this.mitra_id,
    required this.mitra_username,
    required this.mitra_fullname,
    required this.status,
    this.pengawas_username,
    this.pengawas_name,
    this.is_pengawas_organic,
  });

  KegiatanMitraBridgeMoreDetails copyWith({
    String? uuid,
    String? kegiatan_uuid,
    String? kegiatan_name,
    String? mitra_id,
    String? mitra_username,
    String? mitra_fullname,
    String? status,
    String? pengawas_username,
    String? pengawas_name,
    bool? is_pengawas_organic,
  }) {
    return KegiatanMitraBridgeMoreDetails(
      uuid: uuid ?? this.uuid,
      kegiatan_uuid: kegiatan_uuid ?? this.kegiatan_uuid,
      kegiatan_name: kegiatan_name ?? this.kegiatan_name,
      mitra_id: mitra_id ?? this.mitra_id,
      mitra_username: mitra_username ?? this.mitra_username,
      mitra_fullname: mitra_fullname ?? this.mitra_fullname,
      status: status ?? this.status,
      pengawas_username: pengawas_username ?? this.pengawas_username,
      pengawas_name: pengawas_name ?? this.pengawas_name,
      is_pengawas_organic: is_pengawas_organic ?? this.is_pengawas_organic,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'kegiatan_uuid': kegiatan_uuid,
      'kegiatan_name': kegiatan_name,
      'mitra_id': mitra_id,
      'mitra_username': mitra_username,
      'mitra_fullname': mitra_fullname,
      'status': status,
      'pengawas_username': pengawas_username,
      'pengawas_name': pengawas_name,
      'is_pengawas_organic': is_pengawas_organic,
    };
  }

  factory KegiatanMitraBridgeMoreDetails.fromJson(Map<String, dynamic> map) {
    return KegiatanMitraBridgeMoreDetails(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      kegiatan_uuid: map['kegiatan_uuid'] as String,
      kegiatan_name: map['kegiatan_name'] as String,
      mitra_id: map['mitra_id'] as String,
      mitra_username: map['mitra_username'] as String,
      mitra_fullname: map['mitra_fullname'] as String,
      status: map['status'] as String,
      pengawas_username: map['pengawas_username'] != null ? map['pengawas_username'] as String : null,
      pengawas_name: map['pengawas_name'] != null ? map['pengawas_name'] as String : null,
      is_pengawas_organic: map['is_pengawas_organic'] != null ? map['is_pengawas_organic'] as bool : null,
    );
  }

  @override
  String toString() {
    return 'KegiatanMitraBridgeMoreDetails(uuid: $uuid, kegiatan_uuid: $kegiatan_uuid, kegiatan_name: $kegiatan_name, mitra_id: $mitra_id, mitra_username: $mitra_username, mitra_fullname: $mitra_fullname, status: $status, pengawas_username: $pengawas_username, pengawas_name: $pengawas_name, is_pengawas_organic: $is_pengawas_organic)';
  }

  @override
  bool operator ==(covariant KegiatanMitraBridgeMoreDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.kegiatan_uuid == kegiatan_uuid &&
      other.kegiatan_name == kegiatan_name &&
      other.mitra_id == mitra_id &&
      other.mitra_username == mitra_username &&
      other.mitra_fullname == mitra_fullname &&
      other.status == status &&
      other.pengawas_username == pengawas_username &&
      other.pengawas_name == pengawas_name &&
      other.is_pengawas_organic == is_pengawas_organic;
  }
}
