// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:my_first/models/ickm/questions_group.dart';

class QuestionsBloc {
  String? uuid;
  String title;
  String description;
  int order;
  String survei_uuid;
  String tag;
  QuestionsBloc({
    this.uuid,
    required this.title,
    required this.description,
    required this.order,
    required this.survei_uuid,
    required this.tag,
  });

  QuestionsBloc copyWith({
    String? uuid,
    String? title,
    String? description,
    int? order,
    String? survei_uuid,
    String? tag,
  }) {
    return QuestionsBloc(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      survei_uuid: survei_uuid ?? this.survei_uuid,
      tag: tag ?? this.tag,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'title': title,
      'description': description,
      'order': order,
      'survei_uuid': survei_uuid,
      'tag': tag,
    };
  }

  factory QuestionsBloc.fromJson(Map<String, dynamic> map) {
    return QuestionsBloc(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      title: map['title'] as String,
      description: map['description'] as String,
      order: map['order'] as int,
      survei_uuid: map['survei_uuid'] as String,
      tag: map['tag'] as String,
    );
  }

  @override
  String toString() {
    return 'QuestionsBloc(uuid: $uuid, title: $title, description: $description, order: $order, survei_uuid: $survei_uuid, tag: $tag)';
  }
}


class QuestionsBlocWithGroup {
  String? uuid;
  String title;
  String description;
  int order;
  String survei_uuid;
  String tag;
  List<QuestionsGroupWithItems> questions_groups = [];
  QuestionsBlocWithGroup({
    this.uuid,
    required this.title,
    required this.description,
    required this.order,
    required this.survei_uuid,
    required this.tag,
    required this.questions_groups,
  });


  QuestionsBlocWithGroup copyWith({
    String? uuid,
    String? title,
    String? description,
    int? order,
    String? survei_uuid,
    String? tag,
    List<QuestionsGroupWithItems>? questions_groups,
  }) {
    return QuestionsBlocWithGroup(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      survei_uuid: survei_uuid ?? this.survei_uuid,
      tag: tag ?? this.tag,
      questions_groups: questions_groups ?? this.questions_groups,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'title': title,
      'description': description,
      'order': order,
      'survei_uuid': survei_uuid,
      'tag': tag,
      'questions_groups': questions_groups.map((x) => x.toJson()).toList(),
    };
  }

  factory QuestionsBlocWithGroup.fromJson(Map<String, dynamic> map) {
    return QuestionsBlocWithGroup(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      title: map['title'] as String,
      description: map['description'] as String,
      order: map['order'] as int,
      survei_uuid: map['survei_uuid'] as String,
      tag: map['tag'] as String,
      questions_groups: List<QuestionsGroupWithItems>.from((map['questions_groups'] as List<int>).map<QuestionsGroupWithItems>((x) => QuestionsGroupWithItems.fromJson(x as Map<String,dynamic>),),),
    );
  }

  @override
  String toString() {
    return 'QuestionsBlocWithGroup(uuid: $uuid, title: $title, description: $description, order: $order, survei_uuid: $survei_uuid, tag: $tag, questions_groups: $questions_groups)';
  }
}


class QuestionsBlocResponseStructure {
  String? uuid;
  String title;
  String description;
  int order;
  String survei_uuid;
  String tag;
  List<QuestionsGroupResponseStructure> groups;
  QuestionsBlocResponseStructure({
    this.uuid,
    required this.title,
    required this.description,
    required this.order,
    required this.survei_uuid,
    required this.tag,
    required this.groups,
  });

  QuestionsBlocResponseStructure copyWith({
    String? uuid,
    String? title,
    String? description,
    int? order,
    String? survei_uuid,
    String? tag,
    List<QuestionsGroupResponseStructure>? groups,
  }) {
    return QuestionsBlocResponseStructure(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      survei_uuid: survei_uuid ?? this.survei_uuid,
      tag: tag ?? this.tag,
      groups: groups ?? this.groups,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'title': title,
      'description': description,
      'order': order,
      'survei_uuid': survei_uuid,
      'tag': tag,
      'groups': groups.map((x) => x.toJson()).toList(),
    };
  }

  factory QuestionsBlocResponseStructure.fromMap(Map<String, dynamic> map) {
    return QuestionsBlocResponseStructure(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      title: map['title'] as String,
      description: map['description'] as String,
      order: map['order'] as int,
      survei_uuid: map['survei_uuid'] as String,
      tag: map['tag'] as String,
      groups: List<QuestionsGroupResponseStructure>.from((map['groups'] as List<dynamic>).map<QuestionsGroupResponseStructure>((x) => QuestionsGroupResponseStructure.fromJson(x as Map<String,dynamic>)))
    );
  }
  @override
  String toString() {
    return 'QuestionsBlocResponseStructure(uuid: $uuid, title: $title, description: $description, order: $order, survei_uuid: $survei_uuid, tag: $tag, groups: $groups)';
  }
}
