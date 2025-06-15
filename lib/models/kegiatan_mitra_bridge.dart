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
