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
  String? survei_uuid;
  String survei_type;
  String survei_description;
  int survei_version;
  List<QuestionsBlocResponseStructure>? blocs;
  SurveiResponseStructure({
    this.survei_uuid,
    required this.survei_type,
    required this.survei_description,
    required this.survei_version,
    this.blocs,
  });

  SurveiResponseStructure copyWith({
    String? survei_uuid,
    String? survei_type,
    String? survei_description,
    int? survei_version,
    List<QuestionsBlocResponseStructure>? blocs,
  }) {
    return SurveiResponseStructure(
      survei_uuid: survei_uuid ?? this.survei_uuid,
      survei_type: survei_type ?? this.survei_type,
      survei_description: survei_description ?? this.survei_description,
      survei_version: survei_version ?? this.survei_version,
      blocs: blocs ?? this.blocs,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'survei_uuid': survei_uuid,
      'survei_type': survei_type,
      'survei_description': survei_description,
      'survei_version': survei_version,
      'blocs': blocs?.map((x) => x?.toJson()).toList(),
    };
  }

  factory SurveiResponseStructure.fromJson(Map<String, dynamic> map) {
    return SurveiResponseStructure(
      survei_uuid: map['survei_uuid'] != null ? map['survei_uuid'] as String : null,
      survei_type: map['survei_type'] as String,
      survei_description: map['survei_description'] as String,
      survei_version: map['survei_version'] as int,
      blocs: map['blocs'] != null ? List<QuestionsBlocResponseStructure>.from((map['blocs'] as List<dynamic>).map<QuestionsBlocResponseStructure?>((x) => QuestionsBlocResponseStructure.fromJson(x as Map<String,dynamic>),),) : null,
    );
  }

  @override
  String toString() {
    return 'SurveiResponseStructure(survei_uuid: $survei_uuid, survei_type: $survei_type, survei_description: $survei_description, survei_version: $survei_version, blocs: $blocs)';
  }

  @override
  bool operator ==(covariant SurveiResponseStructure other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.survei_uuid == survei_uuid &&
      other.survei_type == survei_type &&
      other.survei_description == survei_description &&
      other.survei_version == survei_version &&
      listEquals(other.blocs, blocs);
  }
}

