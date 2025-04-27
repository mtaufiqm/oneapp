// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

  // id text pk
  // name text [not null]
  // code text [not null]
  // type text [not null]
  // dt1_id text

class DaerahTingkat2 {
  String id;
  String name;
  String code;
  String type;
  String dt1_id;
  DaerahTingkat2({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.dt1_id,
  });

  DaerahTingkat2 copyWith({
    String? id,
    String? name,
    String? code,
    String? type,
    String? dt1_id,
  }) {
    return DaerahTingkat2(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      type: type ?? this.type,
      dt1_id: dt1_id ?? this.dt1_id,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'type': type,
      'dt1_id': dt1_id,
    };
  }

  factory DaerahTingkat2.fromJson(Map<String, dynamic> map) {
    return DaerahTingkat2(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      type: map['type'] as String,
      dt1_id: map['dt1_id'] as String,
    );
  }

  @override
  String toString() {
    return 'DaerahTingkat2(id: $id, name: $name, code: $code, type: $type, dt1_id: $dt1_id)';
  }
}
