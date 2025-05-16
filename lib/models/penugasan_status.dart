// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PenugasanStatus {
  int? id;
  String description;
  PenugasanStatus({
    this.id,
    required this.description,
  });

  PenugasanStatus copyWith({
    int? id,
    String? description,
  }) {
    return PenugasanStatus(
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

  factory PenugasanStatus.fromJson(Map<String, dynamic> map) {
    return PenugasanStatus(
      id: map['id'] != null ? map['id'] as int : null,
      description: map['description'] as String,
    );
  }

  @override
  String toString() => 'PenugasanStatus(id: $id, description: $description)';
}
