
class StructureKuesionerMitra {
  // "id" serial PRIMARY KEY,
  // "uuid" text UNIQUE,
  // "kuesioner_mitra" integer,
  // "penilai_username" text,
  // "mitra_username" text,
  // "mitra_role" text,
  // "versi_kuesioner" integer
  int? id;
  String? uuid;
  int kuesioner_mitra;
  String penilai_username;
  String mitra_username;
  String mitra_role;
  int versi_kuesioner;

  StructureKuesionerMitra({
    this.id,
    this.uuid,
    required this.kuesioner_mitra,
    required this.penilai_username,
    required this.mitra_username,
    required this.mitra_role,
    required this.versi_kuesioner,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'kuesioner_mitra': kuesioner_mitra,
      'penilai_username': penilai_username,
      'mitra_username': mitra_username,
      'mitra_role': mitra_role,
      'versi_kuesioner': versi_kuesioner,
    };
  }

  factory StructureKuesionerMitra.from(Map<String, dynamic> map) {
    return StructureKuesionerMitra(
      id: map['id'] != null ? map['id'] as int : null,
      uuid: map['uuid'] != null ? map["uuid"] as String : null,
      kuesioner_mitra: map['kuesioner_mitra'] as int,
      penilai_username: map['penilai_username'] as String,
      mitra_username: map['mitra_username'] as String,
      mitra_role: map['mitra_role'] as String,
      versi_kuesioner: map['versi_kuesioner'] as int,
    );
  }

}
