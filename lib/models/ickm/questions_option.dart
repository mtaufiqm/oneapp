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


class QuestionsOptionDetails {
  String? qo_uuid;
  String qo_title;
  String qo_description;
  int qo_order;
  int qo_value;
  String qo_tag;
  String qo_questions_item_uuid;
  QuestionsOptionDetails({
    this.qo_uuid,
    required this.qo_title,
    required this.qo_description,
    required this.qo_order,
    required this.qo_value,
    required this.qo_tag,
    required this.qo_questions_item_uuid,
  });

  QuestionsOptionDetails copyWith({
    String? qo_uuid,
    String? qo_title,
    String? qo_description,
    int? qo_order,
    int? qo_value,
    String? qo_tag,
    String? qo_questions_item_uuid,
  }) {
    return QuestionsOptionDetails(
      qo_uuid: qo_uuid ?? this.qo_uuid,
      qo_title: qo_title ?? this.qo_title,
      qo_description: qo_description ?? this.qo_description,
      qo_order: qo_order ?? this.qo_order,
      qo_value: qo_value ?? this.qo_value,
      qo_tag: qo_tag ?? this.qo_tag,
      qo_questions_item_uuid: qo_questions_item_uuid ?? this.qo_questions_item_uuid,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'qo_uuid': qo_uuid,
      'qo_title': qo_title,
      'qo_description': qo_description,
      'qo_order': qo_order,
      'qo_value': qo_value,
      'qo_tag': qo_tag,
      'qo_questions_item_uuid': qo_questions_item_uuid,
    };
  }

  factory QuestionsOptionDetails.fromJson(Map<String, dynamic> map) {
    return QuestionsOptionDetails(
      qo_uuid: map['qo_uuid'] != null ? map['qo_uuid'] as String : null,
      qo_title: map['qo_title'] as String,
      qo_description: map['qo_description'] as String,
      qo_order: map['qo_order'] as int,
      qo_value: map['qo_value'] as int,
      qo_tag: map['qo_tag'] as String,
      qo_questions_item_uuid: map['qo_questions_item_uuid'] as String,
    );
  }

  @override
  String toString() {
    return 'QuestionsOptionDetails(qo_uuid: $qo_uuid, qo_title: $qo_title, qo_description: $qo_description, qo_order: $qo_order, qo_value: $qo_value, qo_tag: $qo_tag, qo_questions_item_uuid: $qo_questions_item_uuid)';
  }

  @override
  bool operator ==(covariant QuestionsOptionDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.qo_uuid == qo_uuid &&
      other.qo_title == qo_title &&
      other.qo_description == qo_description &&
      other.qo_order == qo_order &&
      other.qo_value == qo_value &&
      other.qo_tag == qo_tag &&
      other.qo_questions_item_uuid == qo_questions_item_uuid;
  }

  @override
  int get hashCode {
    return qo_uuid.hashCode ^
      qo_title.hashCode ^
      qo_description.hashCode ^
      qo_order.hashCode ^
      qo_value.hashCode ^
      qo_tag.hashCode ^
      qo_questions_item_uuid.hashCode;
  }
}
