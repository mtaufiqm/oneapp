// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

  // id text pk
  // name text [not null]
  // code text [not null]
  // type text [not null]
  // dt4_id text
class DaerahTingkat5 {
  String id;
  String name;
  String code;
  String type;
  String dt4_id;
  DaerahTingkat5({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.dt4_id,
  });
  

  DaerahTingkat5 copyWith({
    String? id,
    String? name,
    String? code,
    String? type,
    String? dt4_id,
  }) {
    return DaerahTingkat5(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      type: type ?? this.type,
      dt4_id: dt4_id ?? this.dt4_id,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'type': type,
      'dt4_id': dt4_id,
    };
  }

  factory DaerahTingkat5.fromJson(Map<String, dynamic> map) {
    return DaerahTingkat5(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      type: map['type'] as String,
      dt4_id: map['dt4_id'] as String,
    );
  }

  @override
  String toString() {
    return 'DaerahTingkat5(id: $id, name: $name, code: $code, type: $type, dt4_id: $dt4_id)';
  }
  
}
