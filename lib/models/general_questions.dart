// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GeneralQuestions {
  // "id" serial PRIMARY KEY,
  // "uuid" text UNIQUE,
  // "version" integer,
  // "group" integer,
  // "group_desc" text,
  // "order_in_group" integer,
  // "question" text,
  // "description" text,
  // "type" text
  int? id;
  String uuid;
  int version;
  int group;
  String group_desc;
  int order_in_group;
  String question;
  String description;
  String type; 
  GeneralQuestions({
    this.id,
    required this.uuid,
    required this.version,
    required this.group,
    required this.group_desc,
    required this.order_in_group,
    required this.question,
    required this.description,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'version': version,
      'group': group,
      'group_desc': group_desc,
      'order_in_group': order_in_group,
      'question': question,
      'description': description,
      'type': type,
    };
  }

  factory GeneralQuestions.from(Map<String, dynamic> map) {
    return GeneralQuestions(
      id: map['id'] == null? null :map['id'] as int, 
      uuid: map['uuid'] as String,
      version: map['version'] as int,
      group: map['group'] as int,
      group_desc: map['group_desc'] as String,
      order_in_group: map['order_in_group'] as int,
      question: map['question'] as String,
      description: map['description'] as String,
      type: map['type'] as String,
    );
  }
}
