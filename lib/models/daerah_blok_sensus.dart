// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DaerahBlokSensus {
  String id;
  String name;
  String code;
  String type;
  String dt4_id;
  DaerahBlokSensus({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.dt4_id,
  });

  DaerahBlokSensus copyWith({
    String? id,
    String? name,
    String? code,
    String? type,
    String? dt4_id,
  }) {
    return DaerahBlokSensus(
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

  factory DaerahBlokSensus.fromJson(Map<String, dynamic> map) {
    return DaerahBlokSensus(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      type: map['type'] as String,
      dt4_id: map['dt4_id'] as String,
    );
  }

  @override
  String toString() {
    return 'DaerahBlokSensus(id: $id, name: $name, code: $code, type: $type, dt4_id: $dt4_id)';
  }
}
