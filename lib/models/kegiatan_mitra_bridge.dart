
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
