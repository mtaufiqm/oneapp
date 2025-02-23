
class KuesionerMitra {
  // "id" serial PRIMARY KEY,
  // "uuid" text UNIQUE,
  // "kegiatan_id" text UNIQUE,
  // "title" text,
  // "description" text
  String? id;
  String uuid;
  String kegiatan_id;
  String title;
  String description;

  KuesionerMitra({
    this.id,
    required this.uuid,
    required this.kegiatan_id,
    required this.title,
    required this.description,
  });


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'kegiatan_id': kegiatan_id,
      'title': title,
      'description': description,
    };
  }

  factory KuesionerMitra.from(Map<String, dynamic> map) {
    return KuesionerMitra(
      id: map['id'] != null ? map['id'] as String : null,
      uuid: map['uuid'] as String,
      kegiatan_id: map['kegiatan_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

}
