// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:my_first/models/kegiatan.dart';

class KegiatanMitraBridge {
  String? uuid;
  String kegiatan_uuid;
  String mitra_id;
  String status;
  KegiatanMitraBridge({
    this.uuid,
    required this.kegiatan_uuid,
    required this.mitra_id,
    required this.status,
  });

  KegiatanMitraBridge copyWith({
    String? uuid,
    String? kegiatan_uuid,
    String? mitra_id,
    String? status,
  }) {
    return KegiatanMitraBridge(
      uuid: uuid ?? this.uuid,
      kegiatan_uuid: kegiatan_uuid ?? this.kegiatan_uuid,
      mitra_id: mitra_id ?? this.mitra_id,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'kegiatan_uuid': kegiatan_uuid,
      'mitra_id': mitra_id,
      'status': status,
    };
  }

  factory KegiatanMitraBridge.fromJson(Map<String, dynamic> map) {
    return KegiatanMitraBridge(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      kegiatan_uuid: map['kegiatan_uuid'] as String,
      mitra_id: map['mitra_id'] as String,
      status: map['status'] as String,
    );
  }

  @override
  String toString() {
    return 'KegiatanMitraBridge(uuid: $uuid, kegiatan_uuid: $kegiatan_uuid, mitra_id: $mitra_id, status: $status)';
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
