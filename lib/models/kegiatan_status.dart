// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class KegiatanStatus {
  int? id;
  String description;
  KegiatanStatus({
    this.id,
    required this.description,
  });

  KegiatanStatus copyWith({
    int? id,
    String? description,
  }) {
    return KegiatanStatus(
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'description': description,
    };
  }

  factory KegiatanStatus.fromJson(Map<String, dynamic> map) {
    return KegiatanStatus(
      id: map['id'] != null ? map['id'] as int : null,
      description: map['description'] as String,
    );
  }

  @override
  String toString() => 'KegiatanStatus(id: $id, description: $description)';

  @override
  bool operator ==(covariant KegiatanStatus other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.description == description;
  }

}
