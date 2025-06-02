// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:my_first/models/ickm/questions_bloc.dart';

class Survei {
  String? uuid;
  String survei_type;
  String description;
  int version;
  Survei({
    this.uuid,
    required this.survei_type,
    required this.description,
    required this.version,
  });

  Survei copyWith({
    String? uuid,
    String? survei_type,
    String? description,
    int? version,
  }) {
    return Survei(
      uuid: uuid ?? this.uuid,
      survei_type: survei_type ?? this.survei_type,
      description: description ?? this.description,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'survei_type': survei_type,
      'description': description,
      'version': version,
    };
  }

  factory Survei.fromJson(Map<String, dynamic> map) {
    return Survei(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      survei_type: map['survei_type'] as String,
      description: map['description'] as String,
      version: map['version'] as int,
    );
  }

  @override
  String toString() {
    return 'Survei(uuid: $uuid, survei_type: $survei_type, description: $description, version: $version)';
  }
}


class SurveiResponseStructure {
  String? uuid;
  String survei_type;
  String description;
  int version;
  List<QuestionsBlocResponseStructure> blocs;
  SurveiResponseStructure({
    this.uuid,
    required this.survei_type,
    required this.description,
    required this.version,
    required this.blocs,
  });

  SurveiResponseStructure copyWith({
    String? uuid,
    String? survei_type,
    String? description,
    int? version,
    List<QuestionsBlocResponseStructure>? blocs,
  }) {
    return SurveiResponseStructure(
      uuid: uuid ?? this.uuid,
      survei_type: survei_type ?? this.survei_type,
      description: description ?? this.description,
      version: version ?? this.version,
      blocs: blocs ?? this.blocs,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'survei_type': survei_type,
      'description': description,
      'version': version,
      'blocs': blocs.map((x) => x.toJson()).toList(),
    };
  }

  factory SurveiResponseStructure.fromJson(Map<String, dynamic> map) {
    return SurveiResponseStructure(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      survei_type: map['survei_type'] as String,
      description: map['description'] as String,
      version: map['version'] as int,
      blocs: List<QuestionsBlocResponseStructure>.from((map['blocs'] as List<dynamic>).map<QuestionsBlocResponseStructure>((x) => QuestionsBlocResponseStructure.fromMap(x as Map<String,dynamic>),),),
    );
  }

  @override
  String toString() {
    return 'SurveiResponseStructure(uuid: $uuid, survei_type: $survei_type, description: $description, version: $version, blocs: $blocs)';
  }
}
