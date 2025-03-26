// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:my_first/models/ickm/questions_options.dart';

class QuestionsItem {
  String? uuid;
  String title;
  String description;
  String validation;
  int order;
  String questions_group_uuid;
  String tag;
  QuestionsItem({
    this.uuid,
    required this.title,
    required this.description,
    required this.validation,
    required this.order,
    required this.questions_group_uuid,
    required this.tag,
  });

  QuestionsItem copyWith({
    String? uuid,
    String? title,
    String? description,
    String? validation,
    int? order,
    String? questions_group_uuid,
    String? tag,
  }) {
    return QuestionsItem(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      validation: validation ?? this.validation,
      order: order ?? this.order,
      questions_group_uuid: questions_group_uuid ?? this.questions_group_uuid,
      tag: tag ?? this.tag,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'title': title,
      'description': description,
      'validation': validation,
      'order': order,
      'questions_group_uuid': questions_group_uuid,
      'tag': tag,
    };
  }

  factory QuestionsItem.fromJson(Map<String, dynamic> map) {
    return QuestionsItem(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      title: map['title'] as String,
      description: map['description'] as String,
      validation: map['validation'] as String,
      order: map['order'] as int,
      questions_group_uuid: map['questions_group_uuid'] as String,
      tag: map['tag'] as String,
    );
  }

  @override
  String toString() {
    return 'QuestionsItem(uuid: $uuid, title: $title, description: $description, validation: $validation, order: $order, questions_group_uuid: $questions_group_uuid, tag: $tag)';
  }
  
}


class QuestionItemWithOptions {
  String? uuid;
  String title;
  String description;
  String validation;
  int order;
  String questions_group_uuid;
  String tag;
  List<QuestionsOptions> questions_options = [];
  QuestionItemWithOptions({
    this.uuid,
    required this.title,
    required this.description,
    required this.validation,
    required this.order,
    required this.questions_group_uuid,
    required this.tag,
    required this.questions_options,
  });

  QuestionItemWithOptions copyWith({
    String? uuid,
    String? title,
    String? description,
    String? validation,
    int? order,
    String? questions_group_uuid,
    String? tag,
    List<QuestionsOptions>? questions_options,
  }) {
    return QuestionItemWithOptions(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      validation: validation ?? this.validation,
      order: order ?? this.order,
      questions_group_uuid: questions_group_uuid ?? this.questions_group_uuid,
      tag: tag ?? this.tag,
      questions_options: questions_options ?? this.questions_options,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'title': title,
      'description': description,
      'validation': validation,
      'order': order,
      'questions_group_uuid': questions_group_uuid,
      'tag': tag,
      'questions_options': questions_options.map((x) => x.toJson()).toList(),
    };
  }

  factory QuestionItemWithOptions.fromJson(Map<String, dynamic> map) {
    return QuestionItemWithOptions(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      title: map['title'] as String,
      description: map['description'] as String,
      validation: map['validation'] as String,
      order: map['order'] as int,
      questions_group_uuid: map['questions_group_uuid'] as String,
      tag: map['tag'] as String,
      questions_options: List<QuestionsOptions>.from((map['questions_options'] as List<dynamic>).map<QuestionsOptions>((x) => QuestionsOptions.fromJson(x as Map<String,dynamic>)))
    );
  }


  @override
  String toString() {
    return 'QuestionItemWithOptions(uuid: $uuid, title: $title, description: $description, validation: $validation, order: $order, questions_group_uuid: $questions_group_uuid, tag: $tag, questions_options: $questions_options)';
  }

}
