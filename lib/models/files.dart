// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// uuid,name,extension,location,created_at,created_by
class Files {
  String? uuid;
  String name;
  String extension;
  String location;
  String created_at;
  String created_by;

  Files({
    this.uuid,
    required this.name,
    required this.extension,
    required this.location,
    required this.created_at,
    required this.created_by,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'name': name,
      'extension': extension,
      'location': location,
      'created_at': created_at,
      'created_by': created_by,
    };
  }

  factory Files.fromJson(Map<String, dynamic> map) {
    return Files(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      name: map['name'] as String,
      extension: map['extension'] as String,
      location: map['location'] as String,
      created_at: map['created_at'] as String,
      created_by: map['created_by'] as String,
    );
  }

  @override
  String toString() {
    return 'Files(uuid: $uuid, name: $name, extension: $extension, location: $location, created_at: $created_at, created_by: $created_by)';
  }
}
