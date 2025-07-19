// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AntrianSesi {
  String uuid;
  int order;
  String description;
  String tag;
  String code;
  String sesi_start;
  String sesi_end;
  AntrianSesi({
    required this.uuid,
    required this.order,
    required this.description,
    required this.tag,
    required this.code,
    required this.sesi_start,
    required this.sesi_end,
  });

  AntrianSesi copyWith({
    String? uuid,
    int? order,
    String? description,
    String? tag,
    String? code,
    String? sesi_start,
    String? sesi_end,
  }) {
    return AntrianSesi(
      uuid: uuid ?? this.uuid,
      order: order ?? this.order,
      description: description ?? this.description,
      tag: tag ?? this.tag,
      code: code ?? this.code,
      sesi_start: sesi_start ?? this.sesi_start,
      sesi_end: sesi_end ?? this.sesi_end,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'order': order,
      'description': description,
      'tag': tag,
      'code': code,
      'sesi_start': sesi_start,
      'sesi_end': sesi_end,
    };
  }

  factory AntrianSesi.fromJson(Map<String, dynamic> map) {
    return AntrianSesi(
      uuid: map['uuid'] as String,
      order: map['order'] as int,
      description: map['description'] as String,
      tag: map['tag'] as String,
      code: map['code'] as String,
      sesi_start: map['sesi_start'] as String,
      sesi_end: map['sesi_end'] as String,
    );
  }

  @override
  String toString() {
    return 'AntrianSesi(uuid: $uuid, order: $order, description: $description, tag: $tag, code: $code, sesi_start: $sesi_start, sesi_end: $sesi_end)';
  }

  @override
  bool operator ==(covariant AntrianSesi other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.order == order &&
      other.description == description &&
      other.tag == tag &&
      other.code == code &&
      other.sesi_start == sesi_start &&
      other.sesi_end == sesi_end;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
      order.hashCode ^
      description.hashCode ^
      tag.hashCode ^
      code.hashCode ^
      sesi_start.hashCode ^
      sesi_end.hashCode;
  }
}


  // String uuid;
  // int order;
  // String description;
  // String tag;
  // String code;
  // String sesi_start;
  // String sesi_end;
class AntrianSesiDetails {
  String? antrian_sesi_uuid;
  int antrian_sesi_order;
  String antrian_sesi_description;
  String antrian_sesi_tag;
  String antrian_sesi_code;
  String antrian_sesi_start;
  String antrian_sesi_end;
  AntrianSesiDetails({
    this.antrian_sesi_uuid,
    required this.antrian_sesi_order,
    required this.antrian_sesi_description,
    required this.antrian_sesi_tag,
    required this.antrian_sesi_code,
    required this.antrian_sesi_start,
    required this.antrian_sesi_end,
  });

  AntrianSesiDetails copyWith({
    String? antrian_sesi_uuid,
    int? antrian_sesi_order,
    String? antrian_sesi_description,
    String? antrian_sesi_tag,
    String? antrian_sesi_code,
    String? antrian_sesi_start,
    String? antrian_sesi_end,
  }) {
    return AntrianSesiDetails(
      antrian_sesi_uuid: antrian_sesi_uuid ?? this.antrian_sesi_uuid,
      antrian_sesi_order: antrian_sesi_order ?? this.antrian_sesi_order,
      antrian_sesi_description: antrian_sesi_description ?? this.antrian_sesi_description,
      antrian_sesi_tag: antrian_sesi_tag ?? this.antrian_sesi_tag,
      antrian_sesi_code: antrian_sesi_code ?? this.antrian_sesi_code,
      antrian_sesi_start: antrian_sesi_start ?? this.antrian_sesi_start,
      antrian_sesi_end: antrian_sesi_end ?? this.antrian_sesi_end,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'antrian_sesi_uuid': antrian_sesi_uuid,
      'antrian_sesi_order': antrian_sesi_order,
      'antrian_sesi_description': antrian_sesi_description,
      'antrian_sesi_tag': antrian_sesi_tag,
      'antrian_sesi_code': antrian_sesi_code,
      'antrian_sesi_start': antrian_sesi_start,
      'antrian_sesi_end': antrian_sesi_end,
    };
  }

  factory AntrianSesiDetails.fromJson(Map<String, dynamic> map) {
    return AntrianSesiDetails(
      antrian_sesi_uuid: map['antrian_sesi_uuid'] != null ? map['antrian_sesi_uuid'] as String : null,
      antrian_sesi_order: map['antrian_sesi_order'] as int,
      antrian_sesi_description: map['antrian_sesi_description'] as String,
      antrian_sesi_tag: map['antrian_sesi_tag'] as String,
      antrian_sesi_code: map['antrian_sesi_code'] as String,
      antrian_sesi_start: map['antrian_sesi_start'] as String,
      antrian_sesi_end: map['antrian_sesi_end'] as String,
    );
  }

  @override
  String toString() {
    return 'AntrianSesiDetails(antrian_sesi_uuid: $antrian_sesi_uuid, antrian_sesi_order: $antrian_sesi_order, antrian_sesi_description: $antrian_sesi_description, antrian_sesi_tag: $antrian_sesi_tag, antrian_sesi_code: $antrian_sesi_code, antrian_sesi_start: $antrian_sesi_start, antrian_sesi_end: $antrian_sesi_end)';
  }

  @override
  bool operator ==(covariant AntrianSesiDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.antrian_sesi_uuid == antrian_sesi_uuid &&
      other.antrian_sesi_order == antrian_sesi_order &&
      other.antrian_sesi_description == antrian_sesi_description &&
      other.antrian_sesi_tag == antrian_sesi_tag &&
      other.antrian_sesi_code == antrian_sesi_code &&
      other.antrian_sesi_start == antrian_sesi_start &&
      other.antrian_sesi_end == antrian_sesi_end;
  }

  @override
  int get hashCode {
    return antrian_sesi_uuid.hashCode ^
      antrian_sesi_order.hashCode ^
      antrian_sesi_description.hashCode ^
      antrian_sesi_tag.hashCode ^
      antrian_sesi_code.hashCode ^
      antrian_sesi_start.hashCode ^
      antrian_sesi_end.hashCode;
  }
}
