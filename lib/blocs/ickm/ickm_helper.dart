import 'dart:math';

import 'package:my_first/models/ickm/answer_assignment.dart';
import 'package:my_first/models/ickm/questions_bloc.dart';
import 'package:my_first/models/ickm/questions_option.dart';
import 'package:my_first/models/ickm/survei.dart';
import 'package:my_first/responses/ickm/request_assignment_structure.dart';
import 'package:my_first/responses/ickm/response_assignment_structure.dart';




class IckmHelper {
  static Future<double> calculateIndex(SurveiResponseStructure surveiStructure,List<AnswerAssignmentWithOptionDetails> listAnswer) async {
    var calledFunction = mapFunction[surveiStructure.survei_uuid!];
    if(calledFunction == null){
      return 0.0;
    }
    return await calledFunction(surveiStructure, listAnswer);
  }
}



Map<String,Future<double> Function(SurveiResponseStructure surveiStructure, List<AnswerAssignmentWithOptionDetails> listAnswerAndOption)> mapFunction = {
  "70fe23b4-4bf3-11f0-9fe2-0242ac120002":calculateFirstPPL
};

//first PPL
Future<double> calculateFirstPPL(SurveiResponseStructure surveiStructure, List<AnswerAssignmentWithOptionDetails> listAnswerAndOption) async {
  try {
    List<QuestionsBlocResponseStructure> blocs = surveiStructure.blocs!;

    //this is what blocs you set to calcuated, future implementations
    QuestionsBlocResponseStructure calculatedBlob = blocs.first;

    //options map
    Map<String,QuestionsOptionDetails> optionsMap = {};
    listAnswerAndOption.forEach((el) {
      optionsMap[el.aa_questions_option_details!.qo_uuid!] = el.aa_questions_option_details!;
    });

    double groupsSum = 0.0;
    Map<String, double> groupsValue = {};

    for(var group in calculatedBlob.groups!) {
      int sum = 0;
      group.items!.forEach((el) {
        sum += optionsMap[el.answer!.questions_option_uuid!]!.qo_value;
      });
      groupsValue[group.questions_group_uuid!] = sum / group.items!.length;
    }

    groupsValue.values.forEach((el){
     groupsSum += el;
    });

    return (groupsSum/groupsValue.values.length);
  } catch (err){
    print("Error Calculate ICKM ${err}");
    throw Exception("Error ${err}");
  }
}

//first PML

//fisrt KOSEKA