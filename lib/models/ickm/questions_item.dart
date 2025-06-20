// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:my_first/models/ickm/answer_assignment.dart';
import 'package:my_first/models/ickm/questions_option.dart';

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
  List<QuestionsOption> questions_options = [];
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
    List<QuestionsOption>? questions_options,
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
      questions_options: List<QuestionsOption>.from((map['questions_options'] as List<dynamic>).map<QuestionsOption>((x) => QuestionsOption.fromJson(x as Map<String,dynamic>)))
    );
  }


  @override
  String toString() {
    return 'QuestionItemWithOptions(uuid: $uuid, title: $title, description: $description, validation: $validation, order: $order, questions_group_uuid: $questions_group_uuid, tag: $tag, questions_options: $questions_options)';
  }
}



class QuestionsItemResponseStructure {
  String? questions_item_uuid;
  String questions_item_title;
  String questions_item_description;
  String questions_item_validation;
  int questions_item_order;
  String questions_group_uuid;
  String questions_item_tag;
  List<QuestionsOption>? questions_options;
  AnswerAssignment? answer;
  QuestionsItemResponseStructure({
    this.questions_item_uuid,
    required this.questions_item_title,
    required this.questions_item_description,
    required this.questions_item_validation,
    required this.questions_item_order,
    required this.questions_group_uuid,
    required this.questions_item_tag,
    this.questions_options,
    this.answer,
  });

  QuestionsItemResponseStructure copyWith({
    String? questions_item_uuid,
    String? questions_item_title,
    String? questions_item_description,
    String? questions_item_validation,
    int? questions_item_order,
    String? questions_group_uuid,
    String? questions_item_tag,
    List<QuestionsOption>? questions_options,
    AnswerAssignment? answer,
  }) {
    return QuestionsItemResponseStructure(
      questions_item_uuid: questions_item_uuid ?? this.questions_item_uuid,
      questions_item_title: questions_item_title ?? this.questions_item_title,
      questions_item_description: questions_item_description ?? this.questions_item_description,
      questions_item_validation: questions_item_validation ?? this.questions_item_validation,
      questions_item_order: questions_item_order ?? this.questions_item_order,
      questions_group_uuid: questions_group_uuid ?? this.questions_group_uuid,
      questions_item_tag: questions_item_tag ?? this.questions_item_tag,
      questions_options: questions_options ?? this.questions_options,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'questions_item_uuid': questions_item_uuid,
      'questions_item_title': questions_item_title,
      'questions_item_description': questions_item_description,
      'questions_item_validation': questions_item_validation,
      'questions_item_order': questions_item_order,
      'questions_group_uuid': questions_group_uuid,
      'questions_item_tag': questions_item_tag,
      'questions_options': questions_options?.map((x) => x?.toJson()).toList(),
      'answer': answer?.toJson(),
    };
  }

  factory QuestionsItemResponseStructure.fromJson(Map<String, dynamic> map) {
    return QuestionsItemResponseStructure(
      questions_item_uuid: map['questions_item_uuid'] != null ? map['questions_item_uuid'] as String : null,
      questions_item_title: map['questions_item_title'] as String,
      questions_item_description: map['questions_item_description'] as String,
      questions_item_validation: map['questions_item_validation'] as String,
      questions_item_order: map['questions_item_order'] as int,
      questions_group_uuid: map['questions_group_uuid'] as String,
      questions_item_tag: map['questions_item_tag'] as String,
      questions_options: map['questions_options'] != null ? List<QuestionsOption>.from((map['questions_options'] as List<dynamic>).map<QuestionsOption?>((x) => QuestionsOption.fromJson(x as Map<String,dynamic>))) : null,
      answer: map['answer'] != null ? AnswerAssignment.fromJson(map['answer'] as Map<String,dynamic>) : null,
    );
  }

  @override
  String toString() {
    return 'QuestionsItemResponseStructure(questions_item_uuid: $questions_item_uuid, questions_item_title: $questions_item_title, questions_item_description: $questions_item_description, questions_item_validation: $questions_item_validation, questions_item_order: $questions_item_order, questions_group_uuid: $questions_group_uuid, questions_item_tag: $questions_item_tag, questions_options: $questions_options, answer: $answer)';
  }

  @override
  bool operator ==(covariant QuestionsItemResponseStructure other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.questions_item_uuid == questions_item_uuid &&
      other.questions_item_title == questions_item_title &&
      other.questions_item_description == questions_item_description &&
      other.questions_item_validation == questions_item_validation &&
      other.questions_item_order == questions_item_order &&
      other.questions_group_uuid == questions_group_uuid &&
      other.questions_item_tag == questions_item_tag &&
      listEquals(other.questions_options, questions_options) &&
      other.answer == answer;
  }

  @override
  int get hashCode {
    return questions_item_uuid.hashCode ^
      questions_item_title.hashCode ^
      questions_item_description.hashCode ^
      questions_item_validation.hashCode ^
      questions_item_order.hashCode ^
      questions_group_uuid.hashCode ^
      questions_item_tag.hashCode ^
      questions_options.hashCode ^
      answer.hashCode;
  }
}
