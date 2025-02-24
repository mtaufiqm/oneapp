// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Categories {
  String? uuid;
  String name;
  Categories({
    this.uuid,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'name': name,
    };
  }

  factory Categories.fromJson(Map<String, dynamic> map) {
    return Categories(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      name: map['name'] as String,
    );
  }

  @override
  String toString() => 'Categories(uuid: $uuid, name: $name)';
  
}