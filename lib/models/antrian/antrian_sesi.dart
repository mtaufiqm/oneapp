// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AntrianSesi {
  String? uuid;
  int order;
  String description;
  String tag;
  AntrianSesi({
    this.uuid,
    required this.order,
    required this.description,
    required this.tag,
  });

  AntrianSesi copyWith({
    String? uuid,
    int? order,
    String? description,
    String? tag,
  }) {
    return AntrianSesi(
      uuid: uuid ?? this.uuid,
      order: order ?? this.order,
      description: description ?? this.description,
      tag: tag ?? this.tag,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'order': order,
      'description': description,
      'tag': tag,
    };
  }

  factory AntrianSesi.fromJson(Map<String, dynamic> map) {
    return AntrianSesi(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      order: map['order'] as int,
      description: map['description'] as String,
      tag: map['tag'] as String,
    );
  }

  @override
  String toString() {
    return 'AntrianSesi(uuid: $uuid, order: $order, description: $description, tag: $tag)';
  }

  @override
  bool operator ==(covariant AntrianSesi other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.order == order &&
      other.description == description &&
      other.tag == tag;
  }
}

class AntrianSesiDetails {
  String? antrian_sesi_uuid;
  int antrian_sesi_order;
  String antrian_sesi_description;
  String antrian_sesi_tag;
  AntrianSesiDetails({
    this.antrian_sesi_uuid,
    required this.antrian_sesi_order,
    required this.antrian_sesi_description,
    required this.antrian_sesi_tag,
  });

  AntrianSesiDetails copyWith({
    String? antrian_sesi_uuid,
    int? antrian_sesi_order,
    String? antrian_sesi_description,
    String? antrian_sesi_tag,
  }) {
    return AntrianSesiDetails(
      antrian_sesi_uuid: antrian_sesi_uuid ?? this.antrian_sesi_uuid,
      antrian_sesi_order: antrian_sesi_order ?? this.antrian_sesi_order,
      antrian_sesi_description: antrian_sesi_description ?? this.antrian_sesi_description,
      antrian_sesi_tag: antrian_sesi_tag ?? this.antrian_sesi_tag,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'antrian_sesi_uuid': antrian_sesi_uuid,
      'antrian_sesi_order': antrian_sesi_order,
      'antrian_sesi_description': antrian_sesi_description,
      'antrian_sesi_tag': antrian_sesi_tag,
    };
  }

  factory AntrianSesiDetails.fromJson(Map<String, dynamic> map) {
    return AntrianSesiDetails(
      antrian_sesi_uuid: map['antrian_sesi_uuid'] != null ? map['antrian_sesi_uuid'] as String : null,
      antrian_sesi_order: map['antrian_sesi_order'] as int,
      antrian_sesi_description: map['antrian_sesi_description'] as String,
      antrian_sesi_tag: map['antrian_sesi_tag'] as String,
    );
  }


  @override
  String toString() {
    return 'AntrianSesiDetails(antrian_sesi_uuid: $antrian_sesi_uuid, antrian_sesi_order: $antrian_sesi_order, antrian_sesi_description: $antrian_sesi_description, antrian_sesi_tag: $antrian_sesi_tag)';
  }

  @override
  bool operator ==(covariant AntrianSesiDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.antrian_sesi_uuid == antrian_sesi_uuid &&
      other.antrian_sesi_order == antrian_sesi_order &&
      other.antrian_sesi_description == antrian_sesi_description &&
      other.antrian_sesi_tag == antrian_sesi_tag;
  }

}

