// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PenugasanPhoto {
  String? uuid;
  String kmp_uuid;
  String? photo1_loc;
  String? photo1_ext;
  String? photo2_loc;
  String? photo2_ext;
  String? photo3_loc;
  String? photo3_ext;
  String last_updated;
  PenugasanPhoto({
    this.uuid,
    required this.kmp_uuid,
    this.photo1_loc,
    this.photo1_ext,
    this.photo2_loc,
    this.photo2_ext,
    this.photo3_loc,
    this.photo3_ext,
    required this.last_updated,
  });

  PenugasanPhoto copyWith({
    String? uuid,
    String? kmp_uuid,
    String? photo1_loc,
    String? photo1_ext,
    String? photo2_loc,
    String? photo2_ext,
    String? photo3_loc,
    String? photo3_ext,
    String? last_updated,
  }) {
    return PenugasanPhoto(
      uuid: uuid ?? this.uuid,
      kmp_uuid: kmp_uuid ?? this.kmp_uuid,
      photo1_loc: photo1_loc ?? this.photo1_loc,
      photo1_ext: photo1_ext ?? this.photo1_ext,
      photo2_loc: photo2_loc ?? this.photo2_loc,
      photo2_ext: photo2_ext ?? this.photo2_ext,
      photo3_loc: photo3_loc ?? this.photo3_loc,
      photo3_ext: photo3_ext ?? this.photo3_ext,
      last_updated: last_updated ?? this.last_updated,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'kmp_uuid': kmp_uuid,
      'photo1_loc': photo1_loc,
      'photo1_ext': photo1_ext,
      'photo2_loc': photo2_loc,
      'photo2_ext': photo2_ext,
      'photo3_loc': photo3_loc,
      'photo3_ext': photo3_ext,
      'last_updated': last_updated,
    };
  }

  factory PenugasanPhoto.fromJson(Map<String, dynamic> map) {
    return PenugasanPhoto(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      kmp_uuid: map['kmp_uuid'] as String,
      photo1_loc: map['photo1_loc'] != null ? map['photo1_loc'] as String : null,
      photo1_ext: map['photo1_ext'] != null ? map['photo1_ext'] as String : null,
      photo2_loc: map['photo2_loc'] != null ? map['photo2_loc'] as String : null,
      photo2_ext: map['photo2_ext'] != null ? map['photo2_ext'] as String : null,
      photo3_loc: map['photo3_loc'] != null ? map['photo3_loc'] as String : null,
      photo3_ext: map['photo3_ext'] != null ? map['photo3_ext'] as String : null,
      last_updated: map['last_updated'] as String,
    );
  }

  factory PenugasanPhoto.fromDb(Map<String, dynamic> map) {
    return PenugasanPhoto(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      kmp_uuid: map['kmp_uuid'] as String,
      photo1_loc: map['photo1_loc'] != null ? map['photo1_loc'] as String : null,
      photo1_ext: map['photo1_ext'] != null ? map['photo1_ext'] as String : null,
      photo2_loc: map['photo2_loc'] != null ? map['photo2_loc'] as String : null,
      photo2_ext: map['photo2_ext'] != null ? map['photo2_ext'] as String : null,
      photo3_loc: map['photo3_loc'] != null ? map['photo3_loc'] as String : null,
      photo3_ext: map['photo3_ext'] != null ? map['photo3_ext'] as String : null,
      last_updated: map['last_updated'] as String,
    );
  }

  @override
  String toString() {
    return 'PenugasanPhoto(uuid: $uuid, kmp_uuid: $kmp_uuid, photo1_loc: $photo1_loc, photo1_ext: $photo1_ext, photo2_loc: $photo2_loc, photo2_ext: $photo2_ext, photo3_loc: $photo3_loc, photo3_ext: $photo3_ext, last_updated: $last_updated)';
  }

  @override
  bool operator ==(covariant PenugasanPhoto other) {
    if (identical(this, other)) return true;
  
    return 
      other.uuid == uuid &&
      other.kmp_uuid == kmp_uuid &&
      other.photo1_loc == photo1_loc &&
      other.photo1_ext == photo1_ext &&
      other.photo2_loc == photo2_loc &&
      other.photo2_ext == photo2_ext &&
      other.photo3_loc == photo3_loc &&
      other.photo3_ext == photo3_ext &&
      other.last_updated == last_updated;
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
      kmp_uuid.hashCode ^
      photo1_loc.hashCode ^
      photo1_ext.hashCode ^
      photo2_loc.hashCode ^
      photo2_ext.hashCode ^
      photo3_loc.hashCode ^
      photo3_ext.hashCode ^
      last_updated.hashCode;
  }
}
