// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:my_first/models/ickm/answer_assignment.dart';
import 'package:my_first/models/ickm/response_assignment.dart';

class RequestAssignmentStructure {
  ResponseAssignment response;
  List<AnswerAssignment> answers;
  RequestAssignmentStructure({
    required this.response,
    required this.answers,
  });

  RequestAssignmentStructure copyWith({
    ResponseAssignment? response,
    List<AnswerAssignment>? answers,
  }) {
    return RequestAssignmentStructure(
      response: response ?? this.response,
      answers: answers ?? this.answers,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'response': response.toJson(),
      'answers': answers.map((x) => x.toJson()).toList(),
    };
  }

  factory RequestAssignmentStructure.fromJson(Map<String, dynamic> map) {
    return RequestAssignmentStructure(
      response: ResponseAssignment.fromJson(map['response'] as Map<String,dynamic>),
      answers: List<AnswerAssignment>.from((map['answers'] as List<dynamic>).map<AnswerAssignment>((x) => AnswerAssignment.fromJson(x as Map<String,dynamic>),),),
    );
  }

  @override
  String toString() => 'RequestAssignmentStructure(response: $response, answers: $answers)';

  @override
  bool operator ==(covariant RequestAssignmentStructure other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.response == response &&
      listEquals(other.answers, answers);
  }
}
