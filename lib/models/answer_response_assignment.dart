class AnswerResponseAssignment {
  // "id" serial PRIMARY KEY,
  // "uuid" text UNIQUE,
  // "value" text,
  // "question_id" integer,
  // "response_id" integer
  int? id;
  String uuid;
  String value;
  int question_id;
  int response_id;

  AnswerResponseAssignment({
    this.id,
    required this.uuid,
    required this.value,
    required this.question_id,
    required this.response_id,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'value': value,
      'question_id': question_id,
      'response_id': response_id,
    };
  }

  factory AnswerResponseAssignment.from(Map<String, dynamic> map) {
    return AnswerResponseAssignment(
      id: map['id'] != null ? map['id'] as int : null,
      uuid: map['uuid'] as String,
      value: map['value'] as String,
      question_id: map['question_id'] as int,
      response_id: map['response_id'] as int,
    );
  }
}
