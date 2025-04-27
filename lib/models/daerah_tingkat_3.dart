// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

  // id text pk
  // name text [not null]
  // code text [not null]
  // type text [not null]
  // dt2_id text

class DaerahTingkat3 {
  String id;
  String name;
  String code;
  String type;
  String dt2_id;
  DaerahTingkat3({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.dt2_id,
  });

  DaerahTingkat3 copyWith({
    String? id,
    String? name,
    String? code,
    String? type,
    String? dt2_id,
  }) {
    return DaerahTingkat3(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      type: type ?? this.type,
      dt2_id: dt2_id ?? this.dt2_id,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'type': type,
      'dt2_id': dt2_id,
    };
  }

  factory DaerahTingkat3.fromJson(Map<String, dynamic> map) {
    return DaerahTingkat3(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      type: map['type'] as String,
      dt2_id: map['dt2_id'] as String,
    );
  }

  @override
  String toString() {
    return 'DaerahTingkat3(id: $id, name: $name, code: $code, type: $type, dt2_id: $dt2_id)';
  }
}
