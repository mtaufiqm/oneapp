// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AntrianServiceType {
  String? uuid;
  String description;
  AntrianServiceType({
    this.uuid,
    required this.description,
  });

  AntrianServiceType copyWith({
    String? uuid,
    String? description,
  }) {
    return AntrianServiceType(
      uuid: uuid ?? this.uuid,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'description': description,
    };
  }

  factory AntrianServiceType.fromJson(Map<String, dynamic> map) {
    return AntrianServiceType(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      description: map['description'] as String,
    );
  }

  @override
  String toString() => 'AntrianServiceType(uuid: $uuid, description: $description)';

  @override
  bool operator ==(covariant AntrianServiceType other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.description == description;
  }
}

class AntrianServiceTypeDetails {
  String? antrian_service_uuid;
  String antrian_service_description;
  AntrianServiceTypeDetails({
    this.antrian_service_uuid,
    required this.antrian_service_description,
  });

  AntrianServiceTypeDetails copyWith({
    String? antrian_service_uuid,
    String? antrian_service_description,
  }) {
    return AntrianServiceTypeDetails(
      antrian_service_uuid: antrian_service_uuid ?? this.antrian_service_uuid,
      antrian_service_description: antrian_service_description ?? this.antrian_service_description,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'antrian_service_uuid': antrian_service_uuid,
      'antrian_service_description': antrian_service_description,
    };
  }

  factory AntrianServiceTypeDetails.fromJson(Map<String, dynamic> map) {
    return AntrianServiceTypeDetails(
      antrian_service_uuid: map['antrian_service_uuid'] != null ? map['antrian_service_uuid'] as String : null,
      antrian_service_description: map['antrian_service_description'] as String,
    );
  }

  @override
  String toString() => 'AntrianServiceTypeDetails(antrian_service_uuid: $antrian_service_uuid, antrian_service_description: $antrian_service_description)';

  @override
  bool operator ==(covariant AntrianServiceTypeDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.antrian_service_uuid == antrian_service_uuid &&
      other.antrian_service_description == antrian_service_description;
  }

}
