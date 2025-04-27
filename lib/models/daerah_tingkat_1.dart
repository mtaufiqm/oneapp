// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

  // id text pk
  // name text [not null]
  // code text [not null]
  // type text [not null]

class DaerahTingkat1 {
  String id;
  String name;
  String code;
  String type;  //PROVINSI OR EQUALS LEVEL
  DaerahTingkat1({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
  });

  DaerahTingkat1 copyWith({
    String? id,
    String? name,
    String? code,
    String? type,
  }) {
    return DaerahTingkat1(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'type': type,
    };
  }

  factory DaerahTingkat1.fromJson(Map<String, dynamic> map) {
    return DaerahTingkat1(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      type: map['type'] as String,
    );
  }

  @override
  String toString() {
    return 'DaerahTingkat1(id: $id, name: $name, code: $code, type: $type)';
  }
  
}
