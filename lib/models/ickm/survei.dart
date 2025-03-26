

class Survei {
  String? uuid;
  String survei_type;
  String description;
  Survei({
    this.uuid,
    required this.survei_type,
    required this.description,
  });
  
  Survei copyWith({
    String? uuid,
    String? survei_type,
    String? description,
  }) {
    return Survei(
      uuid: uuid ?? this.uuid,
      survei_type: survei_type ?? this.survei_type,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'survei_type': survei_type,
      'description': description,
    };
  }

  factory Survei.fromJson(Map<String, dynamic> map) {
    return Survei(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      survei_type: map['survei_type'] as String,
      description: map['description'] as String,
    );
  }

  @override
  String toString() => 'Survei(uuid: $uuid, survei_type: $survei_type, description: $description)';

}
