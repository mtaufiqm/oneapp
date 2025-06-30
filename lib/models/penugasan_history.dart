// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PenugasanHistory {
  String? uuid;
  String penugasan_uuid;
  int status;
  String created_at;
  String? location_latitude;
  String? location_longitude;
  PenugasanHistory({
    this.uuid,
    required this.penugasan_uuid,
    required this.status,
    required this.created_at,
    this.location_latitude,
    this.location_longitude,
  });

  PenugasanHistory copyWith({
    String? uuid,
    String? penugasan_uuid,
    int? status,
    String? created_at,
    String? location_latitude,
    String? location_longitude,
  }) {
    return PenugasanHistory(
      uuid: uuid ?? this.uuid,
      penugasan_uuid: penugasan_uuid ?? this.penugasan_uuid,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      location_latitude: location_latitude ?? this.location_latitude,
      location_longitude: location_longitude ?? this.location_longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'penugasan_uuid': penugasan_uuid,
      'status': status,
      'created_at': created_at,
      'location_latitude': location_latitude,
      'location_longitude': location_longitude,
    };
  }

  factory PenugasanHistory.fromJson(Map<String, dynamic> map) {
    return PenugasanHistory(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      penugasan_uuid: map['penugasan_uuid'] as String,
      status: map['status'] as int,
      created_at: map['created_at'] as String,
      location_latitude: map['location_latitude'] != null ? map['location_latitude'] as String : null,
      location_longitude: map['location_longitude'] != null ? map['location_longitude'] as String : null,
    );
  }

  @override
  String toString() {
    return 'PenugasanHistory(uuid: $uuid, penugasan_uuid: $penugasan_uuid, status: $status, created_at: $created_at, location_latitude: $location_latitude, location_longitude: $location_longitude)';
  }

  @override
  bool operator ==(covariant PenugasanHistory other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.penugasan_uuid == penugasan_uuid &&
      other.status == status &&
      other.created_at == created_at &&
      other.location_latitude == location_latitude &&
      other.location_longitude == location_longitude;
  }
}

class PenugasanHistoryDetails {
  String? uuid;
  String penugasan_uuid;
  int status;
  String status_description;
  String created_at;
  String? location_latitude;
  String? location_longitude;
  PenugasanHistoryDetails({
    this.uuid,
    required this.penugasan_uuid,
    required this.status,
    required this.status_description,
    required this.created_at,
    this.location_latitude,
    this.location_longitude,
  });

  PenugasanHistoryDetails copyWith({
    String? uuid,
    String? penugasan_uuid,
    int? status,
    String? status_description,
    String? created_at,
    String? location_latitude,
    String? location_longitude,
  }) {
    return PenugasanHistoryDetails(
      uuid: uuid ?? this.uuid,
      penugasan_uuid: penugasan_uuid ?? this.penugasan_uuid,
      status: status ?? this.status,
      status_description: status_description ?? this.status_description,
      created_at: created_at ?? this.created_at,
      location_latitude: location_latitude ?? this.location_latitude,
      location_longitude: location_longitude ?? this.location_longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'penugasan_uuid': penugasan_uuid,
      'status': status,
      'status_description': status_description,
      'created_at': created_at,
      'location_latitude': location_latitude,
      'location_longitude': location_longitude,
    };
  }

  factory PenugasanHistoryDetails.fromJson(Map<String, dynamic> map) {
    return PenugasanHistoryDetails(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      penugasan_uuid: map['penugasan_uuid'] as String,
      status: map['status'] as int,
      status_description: map['status_description'] as String,
      created_at: map['created_at'] as String,
      location_latitude: map['location_latitude'] != null ? map['location_latitude'] as String : null,
      location_longitude: map['location_longitude'] != null ? map['location_longitude'] as String : null,
    );
  }

  @override
  String toString() {
    return 'PenugasanHistoryDetails(uuid: $uuid, penugasan_uuid: $penugasan_uuid, status: $status, status_description: $status_description, created_at: $created_at, location_latitude: $location_latitude, location_longitude: $location_longitude)';
  }

  @override
  bool operator ==(covariant PenugasanHistoryDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.penugasan_uuid == penugasan_uuid &&
      other.status == status &&
      other.status_description == status_description &&
      other.created_at == created_at &&
      other.location_latitude == location_latitude &&
      other.location_longitude == location_longitude;
  }
}
