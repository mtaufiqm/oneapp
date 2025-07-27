// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:my_first/models/ickm/questions_option.dart';

// CREATE TABLE "answer_assignment" (
//   "uuid" text PRIMARY KEY,
//   "response_assignment_uuid" text,
//   "questions_item_uuid" text,
//   "questions_option_uuid" text
// );

class AnswerAssignment {
  String? uuid;
  String response_assignment_uuid;
  String questions_item_uuid;
  String? questions_option_uuid;
  AnswerAssignment({
    this.uuid,
    required this.response_assignment_uuid,
    required this.questions_item_uuid,
    this.questions_option_uuid,
  });

  AnswerAssignment copyWith({
    String? uuid,
    String? response_assignment_uuid,
    String? questions_item_uuid,
    String? questions_option_uuid,
  }) {
    return AnswerAssignment(
      uuid: uuid ?? this.uuid,
      response_assignment_uuid: response_assignment_uuid ?? this.response_assignment_uuid,
      questions_item_uuid: questions_item_uuid ?? this.questions_item_uuid,
      questions_option_uuid: questions_option_uuid ?? this.questions_option_uuid,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'response_assignment_uuid': response_assignment_uuid,
      'questions_item_uuid': questions_item_uuid,
      'questions_option_uuid': questions_option_uuid,
    };
  }

  factory AnswerAssignment.fromJson(Map<String, dynamic> map) {
    return AnswerAssignment(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      response_assignment_uuid: map['response_assignment_uuid'] as String,
      questions_item_uuid: map['questions_item_uuid'] as String,
      questions_option_uuid: map['questions_option_uuid'] != null ? map['questions_option_uuid'] as String : null,
    );
  }

  @override
  String toString() {
    return 'AnswerAssignment(uuid: $uuid, response_assignment_uuid: $response_assignment_uuid, questions_item_uuid: $questions_item_uuid, questions_option_uuid: $questions_option_uuid)';
  }

}


class AnswerAssignmentWithOptionDetails {
  String? aa_uuid;
  String aa_response_assignment_uuid;
  String aa_questions_item_uuid;
  QuestionsOptionDetails? aa_questions_option_details;
  AnswerAssignmentWithOptionDetails({
    this.aa_uuid,
    required this.aa_response_assignment_uuid,
    required this.aa_questions_item_uuid,
    this.aa_questions_option_details,
  });

  AnswerAssignmentWithOptionDetails copyWith({
    String? aa_uuid,
    String? aa_response_assignment_uuid,
    String? aa_questions_item_uuid,
    QuestionsOptionDetails? aa_questions_option_details,
  }) {
    return AnswerAssignmentWithOptionDetails(
      aa_uuid: aa_uuid ?? this.aa_uuid,
      aa_response_assignment_uuid: aa_response_assignment_uuid ?? this.aa_response_assignment_uuid,
      aa_questions_item_uuid: aa_questions_item_uuid ?? this.aa_questions_item_uuid,
      aa_questions_option_details: aa_questions_option_details ?? this.aa_questions_option_details,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'aa_uuid': aa_uuid,
      'aa_response_assignment_uuid': aa_response_assignment_uuid,
      'aa_questions_item_uuid': aa_questions_item_uuid,
      'aa_questions_option_details': aa_questions_option_details?.toJson(),
    };
  }

  factory AnswerAssignmentWithOptionDetails.fromJson(Map<String, dynamic> map) {
    return AnswerAssignmentWithOptionDetails(
      aa_uuid: map['aa_uuid'] != null ? map['aa_uuid'] as String : null,
      aa_response_assignment_uuid: map['aa_response_assignment_uuid'] as String,
      aa_questions_item_uuid: map['aa_questions_item_uuid'] as String,
      aa_questions_option_details: map['aa_questions_option_details'] != null ? QuestionsOptionDetails.fromJson(map['aa_questions_option_details'] as Map<String,dynamic>) : null,
    );
  }

  @override
  String toString() {
    return 'AnswerAssignmentWithOptionDetails(aa_uuid: $aa_uuid, aa_response_assignment_uuid: $aa_response_assignment_uuid, aa_questions_item_uuid: $aa_questions_item_uuid, aa_questions_option_details: $aa_questions_option_details)';
  }

  @override
  bool operator ==(covariant AnswerAssignmentWithOptionDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.aa_uuid == aa_uuid &&
      other.aa_response_assignment_uuid == aa_response_assignment_uuid &&
      other.aa_questions_item_uuid == aa_questions_item_uuid &&
      other.aa_questions_option_details == aa_questions_option_details;
  }

  @override
  int get hashCode {
    return aa_uuid.hashCode ^
      aa_response_assignment_uuid.hashCode ^
      aa_questions_item_uuid.hashCode ^
      aa_questions_option_details.hashCode;
  }
} 
