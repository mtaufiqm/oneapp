
class KuesionerPenilaianMitra {
  String? uuid;
  String kegiatan_uuid;
  String title;
  String description;
  KuesionerPenilaianMitra({
    this.uuid,
    required this.kegiatan_uuid,
    required this.title,
    required this.description,
  });

  KuesionerPenilaianMitra copyWith({
    String? uuid,
    String? kegiatan_uuid,
    String? title,
    String? description,
  }) {
    return KuesionerPenilaianMitra(
      uuid: uuid ?? this.uuid,
      kegiatan_uuid: kegiatan_uuid ?? this.kegiatan_uuid,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'kegiatan_uuid': kegiatan_uuid,
      'title': title,
      'description': description,
    };
  }

  factory KuesionerPenilaianMitra.fromJson(Map<String, dynamic> map) {
    return KuesionerPenilaianMitra(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      kegiatan_uuid: map['kegiatan_uuid'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

  @override
  String toString() {
    return 'KuesionerPenilaianMitra(uuid: $uuid, kegiatan_uuid: $kegiatan_uuid, title: $title, description: $description)';
  }

}
