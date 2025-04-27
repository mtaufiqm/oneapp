// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class QuestionsOption {
  String? uuid;
  String title;
  String description;
  int order;
  int value;
  String tag;
  String questions_item_uuid;
  QuestionsOption({
    this.uuid,
    required this.title,
    required this.description,
    required this.order,
    required this.value,
    required this.tag,
    required this.questions_item_uuid,
  });

  QuestionsOption copyWith({
    String? uuid,
    String? title,
    String? description,
    int? order,
    int? value,
    String? tag,
    String? questions_item_uuid,
  }) {
    return QuestionsOption(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      value: value ?? this.value,
      tag: tag ?? this.tag,
      questions_item_uuid: questions_item_uuid ?? this.questions_item_uuid,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'title': title,
      'description': description,
      'order': order,
      'value': value,
      'tag': tag,
      'questions_item_uuid': questions_item_uuid,
    };
  }

  factory QuestionsOption.fromJson(Map<String, dynamic> map) {
    return QuestionsOption(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      title: map['title'] as String,
      description: map['description'] as String,
      order: map['order'] as int,
      value: map['value'] as int,
      tag: map['tag'] as String,
      questions_item_uuid: map['questions_item_uuid'] as String,
    );
  }

  @override
  String toString() {
    return 'QuestionsOptions(uuid: $uuid, title: $title, description: $description, order: $order, value: $value, tag: $tag, questions_item_uuid: $questions_item_uuid)';
  }

}
