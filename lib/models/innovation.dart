// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// uuid: text pk not null
// name: text not null
// alias: text not null
// description: text not null
// files_uuid: text not null
// is_locked: boolean not null
// pwd: text
// created_at: text not null
// created_by: text not null
// last_updated: text not null

class Innovation {
  String? uuid;
  String name;
  String alias;
  String description;
  String files_uuid;
  String innovation_link;
  bool is_locked;
  String? pwd;
  String created_at;
  String created_by;
  String last_updated;
  Innovation({
    this.uuid,
    required this.name,
    required this.alias,
    required this.description,
    required this.files_uuid,
    required this.innovation_link,
    required this.is_locked,
    this.pwd,
    required this.created_at,
    required this.created_by,
    required this.last_updated,
  });

  Innovation copyWith({
    String? uuid,
    String? name,
    String? alias,
    String? description,
    String? files_uuid,
    String? innovation_link,
    bool? is_locked,
    String? pwd,
    String? created_at,
    String? created_by,
    String? last_updated,
  }) {
    return Innovation(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      alias: alias ?? this.alias,
      description: description ?? this.description,
      files_uuid: files_uuid ?? this.files_uuid,
      innovation_link: innovation_link ?? this.innovation_link,
      is_locked: is_locked ?? this.is_locked,
      pwd: pwd ?? this.pwd,
      created_at: created_at ?? this.created_at,
      created_by: created_by ?? this.created_by,
      last_updated: last_updated ?? this.last_updated,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'name': name,
      'alias': alias,
      'description': description,
      'files_uuid': files_uuid,
      'innovation_link': innovation_link,
      'is_locked': is_locked,
      'pwd': pwd,
      'created_at': created_at,
      'created_by': created_by,
      'last_updated': last_updated,
    };
  }

  factory Innovation.fromJson(Map<String, dynamic> map) {
    return Innovation(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      name: map['name'] as String,
      alias: map['alias'] as String,
      description: map['description'] as String,
      files_uuid: map['files_uuid'] as String,
      innovation_link: map['innovation_link'] as String,
      is_locked: map['is_locked'] as bool,
      pwd: map['pwd'] != null ? map['pwd'] as String : null,
      created_at: map['created_at'] as String,
      created_by: map['created_by'] as String,
      last_updated: map['last_updated'] as String,
    );
  }

  @override
  String toString() {
    return 'Innovation(uuid: $uuid, name: $name, alias: $alias, description: $description, files_uuid: $files_uuid, innovation_link: $innovation_link, is_locked: $is_locked, pwd: $pwd, created_at: $created_at, created_by: $created_by, last_updated: $last_updated)';
  }

}
