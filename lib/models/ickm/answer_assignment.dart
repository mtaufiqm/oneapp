// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
  String questions_option_uuid;
  AnswerAssignment({
    this.uuid,
    required this.response_assignment_uuid,
    required this.questions_item_uuid,
    required this.questions_option_uuid,
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
      questions_option_uuid: map['questions_option_uuid'] as String,
    );
  }

  @override
  String toString() {
    return 'AnswerAssignment(uuid: $uuid, response_assignment_uuid: $response_assignment_uuid, questions_item_uuid: $questions_item_uuid, questions_option_uuid: $questions_option_uuid)';
  }

}
