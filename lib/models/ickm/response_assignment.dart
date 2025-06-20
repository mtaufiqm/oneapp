// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dart_frog/dart_frog.dart';

import 'package:my_first/models/ickm/answer_assignment.dart';
import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';

class ResponseAssignment {
  String? uuid;
  String structure_uuid;
  String created_at;
  String updated_at;
  bool is_completed;
  String survei_uuid;
  String? notes;
  ResponseAssignment({
    this.uuid,
    required this.structure_uuid,
    required this.created_at,
    required this.updated_at,
    required this.is_completed,
    required this.survei_uuid,
    this.notes,
  });

  ResponseAssignment copyWith({
    String? uuid,
    String? structure_uuid,
    String? created_at,
    String? updated_at,
    bool? is_completed,
    String? survei_uuid,
    String? notes,
  }) {
    return ResponseAssignment(
      uuid: uuid ?? this.uuid,
      structure_uuid: structure_uuid ?? this.structure_uuid,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_completed: is_completed ?? this.is_completed,
      survei_uuid: survei_uuid ?? this.survei_uuid,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'structure_uuid': structure_uuid,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_completed': is_completed,
      'survei_uuid': survei_uuid,
      'notes': notes,
    };
  }

  factory ResponseAssignment.fromJson(Map<String, dynamic> map) {
    return ResponseAssignment(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      structure_uuid: map['structure_uuid'] as String,
      created_at: map['created_at'] as String,
      updated_at: map['updated_at'] as String,
      is_completed: map['is_completed'] as bool,
      survei_uuid: map['survei_uuid'] as String,
      notes: map['notes'] != null ? map['notes'] as String : null,
    );
  }

  @override
  String toString() {
    return 'ResponseAssignment(uuid: $uuid, structure_uuid: $structure_uuid, created_at: $created_at, updated_at: $updated_at, is_completed: $is_completed, survei_uuid: $survei_uuid, notes: $notes)';
  }
}


class ResponseAssignmentWithAnswerAssignment {
  ResponseAssignment response;
  List<AnswerAssignment> answers = [];
  ResponseAssignmentWithAnswerAssignment({
    required this.response,
    required this.answers,
  });

  ResponseAssignmentWithAnswerAssignment copyWith({
    ResponseAssignment? response,
    List<AnswerAssignment>? answers,
  }) {
    return ResponseAssignmentWithAnswerAssignment(
      response: response ?? this.response,
      answers: answers ?? this.answers,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'response': response.toJson(),
      'answers': answers.map((x) => x.toJson()).toList(),
    };
  }

  factory ResponseAssignmentWithAnswerAssignment.fromJson(Map<String, dynamic> map) {
    return ResponseAssignmentWithAnswerAssignment(
      response: ResponseAssignment.fromJson(map['response'] as Map<String,dynamic>),
      answers: List<AnswerAssignment>.from((map['answers'] as List<dynamic>).map<AnswerAssignment>((x) => AnswerAssignment.fromJson(x as Map<String,dynamic>)))
    );
  }

  @override
  String toString() => 'ResponseAssignmentWithAnswerAssignment(response: $response, answers: $answers)';

  @override
  bool operator ==(covariant ResponseAssignmentWithAnswerAssignment other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.response == response &&
      listEquals(other.answers, answers);
  }
}