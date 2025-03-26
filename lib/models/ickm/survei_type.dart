// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SurveiType {
  String description;
  SurveiType({
    required this.description
  });

  SurveiType copyWith({
    String? description,
  }) {
    return SurveiType(
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'description': description,
    };
  }

  factory SurveiType.fromJson(Map<String, dynamic> map) {
    return SurveiType(
      description: map['description'] as String,
    );
  }

  @override
  String toString() => 'SurveiType(description: $description)';
}
