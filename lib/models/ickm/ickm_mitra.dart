// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class IckmMitra {
  String? uuid;
  String mitra_id;
  String kegiatan_uuid;
  double ickm;
  IckmMitra({
    this.uuid,
    required this.mitra_id,
    required this.kegiatan_uuid,
    required this.ickm,
  });

  IckmMitra copyWith({
    String? uuid,
    String? mitra_id,
    String? kegiatan_uuid,
    double? ickm,
  }) {
    return IckmMitra(
      uuid: uuid ?? this.uuid,
      mitra_id: mitra_id ?? this.mitra_id,
      kegiatan_uuid: kegiatan_uuid ?? this.kegiatan_uuid,
      ickm: ickm ?? this.ickm,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'mitra_id': mitra_id,
      'kegiatan_uuid': kegiatan_uuid,
      'ickm': ickm,
    };
  }

  factory IckmMitra.fromJson(Map<String, dynamic> map) {
    return IckmMitra(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      mitra_id: map['mitra_id'] as String,
      kegiatan_uuid: map['kegiatan_uuid'] as String,
      ickm: map['ickm'] as double,
    );
  }

  @override
  String toString() {
    return 'IckmMitra(uuid: $uuid, mitra_id: $mitra_id, kegiatan_uuid: $kegiatan_uuid, ickm: $ickm)';
  }

  @override
  bool operator ==(covariant IckmMitra other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.mitra_id == mitra_id &&
      other.kegiatan_uuid == kegiatan_uuid &&
      other.ickm == ickm;
  }
}
