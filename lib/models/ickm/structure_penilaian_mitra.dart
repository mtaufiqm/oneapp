// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StructurePenilaianMitra {
  String? uuid;
  String kuesioner_penilaian_mitra_uuid;
  String? penilai_username;
  String mitra_username;
  String survei_uuid;
  StructurePenilaianMitra({
    this.uuid,
    required this.kuesioner_penilaian_mitra_uuid,
    this.penilai_username,
    required this.mitra_username,
    required this.survei_uuid,
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
      mitra_username: map['mitra_username'] as String,
      survei_uuid: map['survei_uuid'] as String,
    );
  }

  @override
  String toString() {
    return 'StructurePenilaianMitra(uuid: $uuid, kuesioner_penilaian_mitra_uuid: $kuesioner_penilaian_mitra_uuid, penilai_username: $penilai_username, mitra_username: $mitra_username, survei_uuid: $survei_uuid)';
  }

}
