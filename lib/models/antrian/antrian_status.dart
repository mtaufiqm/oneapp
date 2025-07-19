// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AntrianStatus {
  int id;
  String description;
  AntrianStatus({
    required this.id,
    required this.description,
  });

  AntrianStatus copyWith({
    int? id,
    String? description,
  }) {
    return AntrianStatus(
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'description': description,
    };
  }

  factory AntrianStatus.fromJson(Map<String, dynamic> map) {
    return AntrianStatus(
      id: map['id'] as int,
      description: map['description'] as String,
    );
  }

  @override
  String toString() => 'AntrianStatus(id: $id, description: $description)';

  @override
  bool operator ==(covariant AntrianStatus other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.description == description;
  }
}

class AntrianStatusDetails {
  int antrian_status_id;
  String antrian_status_description;
  AntrianStatusDetails({
    required this.antrian_status_id,
    required this.antrian_status_description,
  });

  AntrianStatusDetails copyWith({
    int? antrian_status_id,
    String? antrian_status_description,
  }) {
    return AntrianStatusDetails(
      antrian_status_id: antrian_status_id ?? this.antrian_status_id,
      antrian_status_description: antrian_status_description ?? this.antrian_status_description,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'antrian_status_id': antrian_status_id,
      'antrian_status_description': antrian_status_description,
    };
  }

  factory AntrianStatusDetails.fromJson(Map<String, dynamic> map) {
    return AntrianStatusDetails(
      antrian_status_id: map['antrian_status_id'] as int,
      antrian_status_description: map['antrian_status_description'] as String,
    );
  }

  @override
  String toString() => 'AntrianStatusDetails(antrian_status_id: $antrian_status_id, antrian_status_description: $antrian_status_description)';

  @override
  bool operator ==(covariant AntrianStatusDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.antrian_status_id == antrian_status_id &&
      other.antrian_status_description == antrian_status_description;
  }
}
