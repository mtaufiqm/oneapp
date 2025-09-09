import 'dart:math';

import 'package:my_first/models/ickm/answer_assignment.dart';
import 'package:my_first/models/ickm/questions_bloc.dart';
import 'package:my_first/models/ickm/questions_option.dart';
import 'package:my_first/models/ickm/survei.dart';
import 'package:my_first/responses/ickm/request_assignment_structure.dart';
import 'package:my_first/responses/ickm/response_assignment_structure.dart';




class IckmHelper {
  static Future<double> calculateIndex(SurveiResponseStructure surveiStructure,List<AnswerAssignmentWithOptionDetails> listAnswer) async {
    var calledFunction = mapFunctionProd[surveiStructure.survei_uuid!];
    if(calledFunction == null){
      return 0.0;
    }
    return await calledFunction(surveiStructure, listAnswer);
  }
}



Map<String,Future<double> Function(SurveiResponseStructure surveiStructure, List<AnswerAssignmentWithOptionDetails> listAnswerAndOption)> mapFunctionDev = {
  "70fe23b4-4bf3-11f0-9fe2-0242ac120002":calculateFirstPPL,
};

Map<String,Future<double> Function(SurveiResponseStructure surveiStructure, List<AnswerAssignmentWithOptionDetails> listAnswerAndOption)> mapFunctionProd = {
  //PPL_PAPI
  "5ef6880e-8d26-11f0-9616-325096b39f47":calculateFirstPPL,
  //PPL_CAPI
  "5ef68e62-8d26-11f0-8bc8-325096b39f47":calculateFirstPPL,
  //PML_PAPI
  "5ef68df4-8d26-11f0-9bb7-325096b39f47":calculateFirstPML,
  //PML_CAPI
  "5ef68d90-8d26-11f0-bdc9-325096b39f47":calculateFirstPML,
  //PPL_CAWI
  "5ef68caa-8d26-11f0-8f38-325096b39f47":calculateFirstPPL,
  //PML_CAWI
  "5ef68c46-8d26-11f0-a1e3-325096b39f47":calculateFirstPML
};


//first PPL_PAPI
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
Future<double> calculateFirstPML(SurveiResponseStructure surveiStructure, List<AnswerAssignmentWithOptionDetails> listAnswerAndOption) async {
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