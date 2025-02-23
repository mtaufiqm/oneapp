// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Roles {
  final String description;
  Roles({
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'description': description,
    };
  }

  factory Roles.from(Map<String, dynamic> map) {
    return Roles(
      description: map['description'] as String,
    );
  }
}

