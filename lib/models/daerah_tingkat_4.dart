  // id text pk
  // name text [not null]
  // code text [not null]
  // type text [not null]
  // dt3_id text
class DaerahTingkat4 {
  String id;
  String name;
  String code;
  String type;
  String dt3_id;
  DaerahTingkat4({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.dt3_id,
  });

  DaerahTingkat4 copyWith({
    String? id,
    String? name,
    String? code,
    String? type,
    String? dt3_id,
  }) {
    return DaerahTingkat4(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      type: type ?? this.type,
      dt3_id: dt3_id ?? this.dt3_id,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'type': type,
      'dt3_id': dt3_id,
    };
  }

  factory DaerahTingkat4.fromJson(Map<String, dynamic> map) {
    return DaerahTingkat4(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      type: map['type'] as String,
      dt3_id: map['dt3_id'] as String,
    );
  }

  @override
  String toString() {
    return 'DaerahTingkat4(id: $id, name: $name, code: $code, type: $type, dt3_id: $dt3_id)';
  }

}
