// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:my_first/models/ickm/questions_item.dart';

class QuestionsGroup {
  String? uuid;
  String title;
  String description;
  int order;
  String questions_bloc_uuid;
  String tag;
  QuestionsGroup({
    this.uuid,
    required this.title,
    required this.description,
    required this.order,
    required this.questions_bloc_uuid,
    required this.tag,
  });

  QuestionsGroup copyWith({
    String? uuid,
    String? title,
    String? description,
    int? order,
    String? questions_bloc_uuid,
    String? tag,
  }) {
    return QuestionsGroup(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      questions_bloc_uuid: questions_bloc_uuid ?? this.questions_bloc_uuid,
      tag: tag ?? this.tag,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'title': title,
      'description': description,
      'order': order,
      'questions_bloc_uuid': questions_bloc_uuid,
      'tag': tag,
    };
  }

  factory QuestionsGroup.fromJson(Map<String, dynamic> map) {
    return QuestionsGroup(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      title: map['title'] as String,
      description: map['description'] as String,
      order: map['order'] as int,
      questions_bloc_uuid: map['questions_bloc_uuid'] as String,
      tag: map['tag'] as String,
    );
  }

 
  @override
  String toString() {
    return 'QuestionsGroup(uuid: $uuid, title: $title, description: $description, order: $order, questions_bloc_uuid: $questions_bloc_uuid, tag: $tag)';
  }

}

class QuestionsGroupWithItems {
  String? uuid;
  String title;
  String description;
  int order;
  String questions_bloc_uuid;
  String tag;
  List<QuestionItemWithOptions> questions_items = [];
  QuestionsGroupWithItems({
    this.uuid,
    required this.title,
    required this.description,
    required this.order,
    required this.questions_bloc_uuid,
    required this.tag,
    required this.questions_items,
  });

  QuestionsGroupWithItems copyWith({
    String? uuid,
    String? title,
    String? description,
    int? order,
    String? questions_bloc_uuid,
    String? tag,
    List<QuestionItemWithOptions>? questions_items,
  }) {
    return QuestionsGroupWithItems(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      questions_bloc_uuid: questions_bloc_uuid ?? this.questions_bloc_uuid,
      tag: tag ?? this.tag,
      questions_items: questions_items ?? this.questions_items,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'title': title,
      'description': description,
      'order': order,
      'questions_bloc_uuid': questions_bloc_uuid,
      'tag': tag,
      'questions_items': questions_items.map((x) => x.toJson()).toList(),
    };
  }

  factory QuestionsGroupWithItems.fromJson(Map<String, dynamic> map) {
    return QuestionsGroupWithItems(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      title: map['title'] as String,
      description: map['description'] as String,
      order: map['order'] as int,
      questions_bloc_uuid: map['questions_bloc_uuid'] as String,
      tag: map['tag'] as String,
      questions_items: List<QuestionItemWithOptions>.from((map['questions_items'] as List<dynamic>).map<QuestionItemWithOptions>((x) => QuestionItemWithOptions.fromJson(x as Map<String,dynamic>),),),
    );
  }


  @override
  String toString() {
    return 'QuestionsGroupWithItems(uuid: $uuid, title: $title, description: $description, order: $order, questions_bloc_uuid: $questions_bloc_uuid, tag: $tag, questions_items: $questions_items)';
  }
}


class QuestionsGroupResponseStructure {
  String? questions_group_uuid;
  String questions_group_title;
  String questions_group_description;
  int questions_group_order;
  String questions_bloc_uuid;
  String questions_group_tag;
  List<QuestionsItemResponseStructure>? items;
  QuestionsGroupResponseStructure({
    this.questions_group_uuid,
    required this.questions_group_title,
    required this.questions_group_description,
    required this.questions_group_order,
    required this.questions_bloc_uuid,
    required this.questions_group_tag,
    this.items,
  });

  QuestionsGroupResponseStructure copyWith({
    String? questions_group_uuid,
    String? questions_group_title,
    String? questions_group_description,
    int? questions_group_order,
    String? questions_bloc_uuid,
    String? questions_group_tag,
    List<QuestionsItemResponseStructure>? items,
  }) {
    return QuestionsGroupResponseStructure(
      questions_group_uuid: questions_group_uuid ?? this.questions_group_uuid,
      questions_group_title: questions_group_title ?? this.questions_group_title,
      questions_group_description: questions_group_description ?? this.questions_group_description,
      questions_group_order: questions_group_order ?? this.questions_group_order,
      questions_bloc_uuid: questions_bloc_uuid ?? this.questions_bloc_uuid,
      questions_group_tag: questions_group_tag ?? this.questions_group_tag,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'questions_group_uuid': questions_group_uuid,
      'questions_group_title': questions_group_title,
      'questions_group_description': questions_group_description,
      'questions_group_order': questions_group_order,
      'questions_bloc_uuid': questions_bloc_uuid,
      'questions_group_tag': questions_group_tag,
      'items': items?.map((x) => x?.toJson()).toList(),
    };
  }

  factory QuestionsGroupResponseStructure.fromJson(Map<String, dynamic> map) {
    return QuestionsGroupResponseStructure(
      questions_group_uuid: map['questions_group_uuid'] != null ? map['questions_group_uuid'] as String : null,
      questions_group_title: map['questions_group_title'] as String,
      questions_group_description: map['questions_group_description'] as String,
      questions_group_order: map['questions_group_order'] as int,
      questions_bloc_uuid: map['questions_bloc_uuid'] as String,
      questions_group_tag: map['questions_group_tag'] as String,
      items: map['items'] != null ? List<QuestionsItemResponseStructure>.from((map['items'] as List<dynamic>).map<QuestionsItemResponseStructure?>((x) => QuestionsItemResponseStructure.fromJson(x as Map<String,dynamic>))) : null,
    );
  }

  @override
  String toString() {
    return 'QuestionsGroupResponseStructure(questions_group_uuid: $questions_group_uuid, questions_group_title: $questions_group_title, questions_group_description: $questions_group_description, questions_group_order: $questions_group_order, questions_bloc_uuid: $questions_bloc_uuid, questions_group_tag: $questions_group_tag, items: $items)';
  }

  @override
  bool operator ==(covariant QuestionsGroupResponseStructure other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.questions_group_uuid == questions_group_uuid &&
      other.questions_group_title == questions_group_title &&
      other.questions_group_description == questions_group_description &&
      other.questions_group_order == questions_group_order &&
      other.questions_bloc_uuid == questions_bloc_uuid &&
      other.questions_group_tag == questions_group_tag &&
      listEquals(other.items, items);
  }
}
