import 'dart:developer';

import 'package:my_first/blocs/datetime_helper.dart';
import 'package:my_first/blocs/ickm/ickm_helper.dart';
import 'package:my_first/models/ickm/answer_assignment.dart';
import 'package:my_first/models/ickm/questions_bloc.dart';
import 'package:my_first/models/ickm/questions_group.dart';
import 'package:my_first/models/ickm/questions_item.dart';
import 'package:my_first/models/ickm/questions_option.dart';
import 'package:my_first/models/ickm/response_assignment.dart';
import 'package:my_first/models/ickm/survei.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:my_first/responses/ickm/response_assignment_structure.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

  // String? uuid;
  // String structure_uuid;
  // String created_at;
  // String updated_at;
  // bool is_completed;
  // String survei_uuid;
  // String? notes;

class ResponseAssignmentRepository extends MyRepository<ResponseAssignment>{
  MyConnectionPool conn;
  ResponseAssignmentRepository(this.conn);

  Future<ResponseAssignment> getById(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM response_assignment WHERE uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is No Data with uuid ${uuid}");
      }
      var resultMap = result.first.toColumnMap();
      ResponseAssignment object = ResponseAssignment.fromJson(resultMap);
      return object;
    });
  }

  Future<ResponseAssignment> update(dynamic uuid, ResponseAssignment object) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"UPDATE response_assignment SET structure_uuid = $1, created_at = $2, updated_at = $3, is_completed = $4, survei_uuid = $5, notes = $6 WHERE uuid = $7",parameters: [
        object.structure_uuid,
        object.created_at,
        object.updated_at,
        object.is_completed,
        object.survei_uuid,
        object.notes,
        uuid as String
      ]);
      if(result.affectedRows <= 0){
        throw Exception("Data not updated.");
      }
      object.uuid = uuid as String;
      return object;
    });
  }

  Future<ResponseAssignment> create(ResponseAssignment object) async {
    return this.conn.connectionPool.runTx((tx) async {
      String uuid =  Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO response_assignment(uuid, structure_uuid, created_at, updated_at, is_completed, survei_uuid, notes) VALUES($1,$2,$3,$4,$5,$6) RETURNING uuid", parameters: [
        object.uuid,
        object.structure_uuid,
        object.created_at,
        object.updated_at,
        object.is_completed,
        object.survei_uuid,
        object.notes
      ]);
      if(result.isEmpty){
        throw Exception("Error Create Survei ${uuid}");
      }
      return object;
    });
  }

  Future<List<ResponseAssignment>> readAll() async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM response_assignment");
      List<ResponseAssignment> listObject = [];
      for(var item in result){
        var object = ResponseAssignment.fromJson(item.toColumnMap());
        listObject.add(object);
      }
      return listObject;
    });
  }

  Future<void> delete(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"DELETE FROM survei WHERE uuid = $1",parameters: [uuid as String]);
      if(result.affectedRows <= 0){
        throw Exception("Fail to delete Survei ${uuid}");
      }
      return;
    });
  }

  Future<ResponseAssignmentStructure> generateResponseStructure(dynamic uuid) async {
    return await this.conn.connectionPool.runTx((tx) async {
      try {
        var result = await tx.execute(r"select ra.*, k.uuid as kegiatan_uuid, k.name as kegiatan_name, k.start as kegiatan_start, k.end  as kegiatan_end, kpm.start_date as kuesioner_penilaian_start, kpm.end_date as kuesioner_penilaian_mitra_end, p.username as penilai_username, p.fullname as penilai_name, m.mitra_id as mitra_id, m.username  as mitra_username, m.fullname as mitra_name from response_assignment ra left join structure_penilaian_mitra spm on ra.structure_uuid = spm.uuid left join kuesioner_penilaian_mitra kpm on spm.kuesioner_penilaian_mitra_uuid  = kpm.uuid left join kegiatan k on kpm.kegiatan_uuid = k.uuid left join mitra m on spm.mitra_username = m.username left join pegawai p on spm.penilai_username = p.username WHERE ra.uuid = $1",parameters: [uuid as String]);
        if(result.isEmpty){
          throw Exception("There is No Response Assignment ${uuid as String}");
        }
        ResponseAssignmentStructure structure = ResponseAssignmentStructure.fromJson(result.first.toColumnMap());
        ResponseAssignment response = ResponseAssignment.fromJson(result.first.toColumnMap());
        structure.response = response;

        //add implementations to get others field froms structure : 
        //status
        var result2 = await tx.execute(r"SELECT * FROM kegiatan_mitra_bridge kmb WHERE kmb.kegiatan_uuid = $1 AND kmb.mitra_id = $2",parameters: [
          structure.kegiatan_uuid!,
          structure.mitra_id!
        ]);
        if(result2.isEmpty){
          throw Exception("This Mitra Not Have Relation For That Kegiatan, Maybe Deleted. Try to add again");
        }
        KegiatanMitraBridge kmb = KegiatanMitraBridge.fromJson(result2.first.toColumnMap());
        structure.mitra_status = kmb.status;

        //List<String> : List Penugasan Group
        var result3 = await tx.execute(r"SELECT kmp.group, kmp.group_desc FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid WHERE kmb.kegiatan_uuid = $1 AND kmb.mitra_id = $2 GROUP BY kmp.group,kmp.group_desc",parameters: [structure.kegiatan_uuid!,structure.mitra_id!]);
        List<String> mitra_penugasan = [];
        result3.forEach((el){
          mitra_penugasan.add((el.toColumnMap()["group_desc"] as String?)??"");
        });
        structure.mitra_penugasan = mitra_penugasan;

        //SurveiResponseStructure
        var resultSurvei = await tx.execute(r'SELECT s.uuid as survei_uuid, s.survei_type as survei_type, s.description as survei_description, s.version as survei_version,  qb.uuid as questions_bloc_uuid, qb.title as questions_bloc_title, qb.description as questions_bloc_description, qb."order" as questions_bloc_order, qb.tag as questions_bloc_tag, qg.uuid as questions_group_uuid, qg.title as questions_group_title, qg.description as questions_group_description, qg."order" as questions_group_order, qg.tag as questions_group_tag, qi.uuid as questions_item_uuid, qi.title as questions_item_title, qi.description as questions_item_description, qi."order" as questions_item_order, qi.tag as questions_item_tag, qi.validation as questions_item_validation, qo.uuid as questions_option_uuid, qo.title as questions_option_title, qo.description as questions_option_description, qo."order" as questions_option_order, qo.value as questions_option_value, qo.tag as questions_option_tag FROM survei s left join questions_bloc qb ON s.uuid = qb.survei_uuid left join questions_group qg on qb.uuid = qg.questions_bloc_uuid left join questions_item qi on qg.uuid = qi.questions_group_uuid left join questions_option qo on qi.uuid = qo.questions_item_uuid where s.uuid = $1 order by qo."order" ASC, qi."order" ASC, qg."order" ASC, qb."order" ASC',parameters: [
          structure.response!.survei_uuid
        ]);

        if(resultSurvei.isEmpty){
          throw Exception("There is No Data For This Survei ${structure.response!.survei_uuid}");
        }

        Map<String,AnswerAssignment> mapAnswers = {};
        var resultCurrentResponse = await tx.execute(r"SELECT * FROM answer_assignment aa WHERE aa.response_assignment_uuid = $1",parameters: [structure.response!.uuid!]);
        resultCurrentResponse.forEach((el){
          try {
            AnswerAssignment answer = AnswerAssignment.fromJson(el.toColumnMap());
            mapAnswers[answer.uuid!] = answer;
          } catch(err){
            print(err);
          }
        });
        

        //iterate for survei
        Map<String,SurveiResponseStructure> surveiStructureMap = {};
        for(var item in resultSurvei){
          try {
            Map<String,dynamic> itemMap = item.toColumnMap();
            String survei_uuid = itemMap["survei_uuid"] as String;
            if(!surveiStructureMap.containsKey(survei_uuid)){
              String survei_type = itemMap["survei_type"] as String;
              String survei_description = itemMap["survei_description"] as String;
              int survei_version = itemMap["survei_version"] as int;
              List<QuestionsBlocResponseStructure> questions_bloc = [];
              SurveiResponseStructure surveiStructure = SurveiResponseStructure(
                survei_uuid: survei_uuid,
                survei_type: survei_type, 
                survei_description: survei_description, 
                survei_version: survei_version, 
                blocs: questions_bloc
              );
              surveiStructureMap[survei_uuid] = surveiStructure;
              continue;
            }
          } catch(e){
            print("Error ${e}");
          }
        }

        // String? uuid;
        // String title;
        // String description;
        // int order;
        // int value;
        // String tag;
        // String questions_item_uuid;

        //iterate options
        Map<String,List<QuestionsOption>> mapQI = {};
        for(var item in resultSurvei){
          try {
            Map<String,dynamic> mapItem = item.toColumnMap();
            QuestionsItemResponseStructure qi = QuestionsItemResponseStructure.fromJson(item.toColumnMap());


            String? questions_option_uuid = mapItem["questions_option_uuid"] as String?; 
            String questions_option_title = mapItem["questions_option_title"] as String;
            String questions_option_description = mapItem["questions_option_description"] as String;
            int questions_option_order = mapItem["questions_option_order"] as int;
            int questions_option_value = mapItem["questions_option_value"] as int;
            String questions_option_tag = mapItem["questions_option_tag"] as String;

            QuestionsOption qo = QuestionsOption(uuid:questions_option_uuid,title: questions_option_title, description: questions_option_description, order: questions_option_order, value: questions_option_value, tag: questions_option_tag, questions_item_uuid: qi.questions_item_uuid!);

            if(qo.uuid == null){
              continue;
            }

            if(mapQI.containsKey(qi.questions_item_uuid)){
              List<QuestionsOption> listQO = mapQI[qi.questions_item_uuid]??[];
              listQO.add(qo);
              continue;
            }
            mapQI[qi.questions_item_uuid!] = [qo];
          } catch(e){
            print(e);
            continue;
          }
        }

        // String? uuid;
        // String title;
        // String description;
        // String validation;
        // int order;
        // String questions_group_uuid;
        // String tag;
        // List<QuestionsOption> options;
        // AnswerAssignment? answer;

        //iterate item
        Map<String,List<QuestionsItemResponseStructure>> mapQG = {};
        List<String> doneQI = [];
        for(var item in resultSurvei){
          try {
            Map<String,dynamic> mapItem = item.toColumnMap();
            QuestionsGroupResponseStructure qg = QuestionsGroupResponseStructure.fromJson(mapItem);
            if(qg.questions_group_uuid == null) {continue;}
            QuestionsItemResponseStructure qi = QuestionsItemResponseStructure.fromJson(mapItem);
            if(doneQI.contains(qi.questions_item_uuid)){
              continue;
            }
            qi.answer = mapAnswers[qi.questions_item_uuid];
            if(mapQG.containsKey(qg.questions_group_uuid)){
              qi.questions_options = mapQI[qi.questions_item_uuid]??[];
              mapQG[qg.questions_group_uuid]!.add(qi);
              doneQI.add(qi.questions_item_uuid!);
              continue;
            }
            qi.questions_options = mapQI[qi.questions_item_uuid]??[];
            mapQG[qg.questions_group_uuid!] = [qi];
            doneQI.add(qi.questions_item_uuid!);
          } catch(e){
            print("Error Iterate ${e}");
            continue;
          }
        }

        //iterate group
        Map<String,List<QuestionsGroupResponseStructure>> mapQB = {};
        List<String> doneQG = [];
        for(var item in resultSurvei){
            try {
              Map<String,dynamic> mapItem = item.toColumnMap();
              QuestionsBlocResponseStructure qb = QuestionsBlocResponseStructure.fromJson(mapItem);
              if(qb.questions_bloc_uuid == null){
                continue;
              }
              QuestionsGroupResponseStructure qg = QuestionsGroupResponseStructure.fromJson(mapItem);
              if(doneQG.contains(qg.questions_group_uuid)){
                continue;
              }
              if(mapQB.containsKey(qb.questions_bloc_uuid)){
                qg.items = mapQG[qg.questions_group_uuid]??[];
                mapQB[qb.questions_bloc_uuid]!.add(qg);
                doneQG.add(qg.questions_group_uuid!);
                continue;
              }
              qg.items = mapQG[qg.questions_group_uuid]??[];
              // qb.groups!.add(qg);
              mapQB[qb.questions_bloc_uuid!] = [qg];
              doneQG.add(qg.questions_group_uuid!);
            } catch(e){
              log("Error Iterate ${e}");
              continue;
            }
        }

        //iterate bloc
        List<String> doneQB = [];
        Map<String,List<QuestionsBlocResponseStructure>> mapSurvei = {};
        for(var item in resultSurvei){
            try {
              Map<String,dynamic> mapItem = item.toColumnMap();
              SurveiResponseStructure survei = SurveiResponseStructure.fromJson(mapItem);
              if(survei.survei_uuid == null){
                continue;
              }
              QuestionsBlocResponseStructure qb = QuestionsBlocResponseStructure.fromJson(mapItem);
              if(doneQB.contains(qb.questions_bloc_uuid)){
                continue;
              }
              if(mapSurvei.containsKey(survei.survei_uuid)){
                qb.groups = mapQB[qb.questions_bloc_uuid]??[];
                mapSurvei[qb.questions_bloc_uuid]!.add(qb);
                doneQB.add(qb.questions_bloc_uuid!);
                continue;
              }
              qb.groups = mapQB[qb.questions_bloc_uuid]??[];
              // qb.groups!.add(qb);     
              mapSurvei[survei.survei_uuid!] = [qb];
              doneQB.add(qb.questions_bloc_uuid!);
            } catch(e){
              print("Error Iterate ${e}");
              continue;
            }
        }
        structure.survei = surveiStructureMap.values.first..blocs = mapSurvei.values.first;
        return structure;
      } catch(err){
        log("Error Generate Response Assignment ${err}");
        throw Exception("Error Generate Response Assignment ${err}");
      }
    });
  }


  Future<ResponseAssignmentStructure> generateResponseStructureWithAnswers(dynamic uuid) async {
    return await this.conn.connectionPool.runTx((tx) async {
      try {
        var result = await tx.execute(r"select ra.*, k.uuid as kegiatan_uuid, k.name as kegiatan_name, k.start as kegiatan_start, k.end  as kegiatan_end, kpm.start_date as kuesioner_penilaian_start, kpm.end_date as kuesioner_penilaian_mitra_end, p.username as penilai_username, p.fullname as penilai_name, m.mitra_id as mitra_id, m.username  as mitra_username, m.fullname as mitra_name from response_assignment ra left join structure_penilaian_mitra spm on ra.structure_uuid = spm.uuid left join kuesioner_penilaian_mitra kpm on spm.kuesioner_penilaian_mitra_uuid  = kpm.uuid left join kegiatan k on kpm.kegiatan_uuid = k.uuid left join mitra m on spm.mitra_username = m.username left join pegawai p on spm.penilai_username = p.username WHERE ra.uuid = $1",parameters: [uuid as String]);
        if(result.isEmpty){
          throw Exception("There is No Response Assignment ${uuid as String}");
        }
        ResponseAssignmentStructure structure = ResponseAssignmentStructure.fromJson(result.first.toColumnMap());
        ResponseAssignment response = ResponseAssignment.fromJson(result.first.toColumnMap());
        structure.response = response;

        //add implementations to get others field froms structure : 
        //status
        var result2 = await tx.execute(r"SELECT * FROM kegiatan_mitra_bridge kmb WHERE kmb.kegiatan_uuid = $1 AND kmb.mitra_id = $2",parameters: [
          structure.kegiatan_uuid!,
          structure.mitra_id!
        ]);
        if(result2.isEmpty){
          throw Exception("This Mitra Not Have Relation For That Kegiatan, Maybe Deleted. Try to add again");
        }
        KegiatanMitraBridge kmb = KegiatanMitraBridge.fromJson(result2.first.toColumnMap());
        structure.mitra_status = kmb.status;

        //List<String> : List Penugasan Group
        var result3 = await tx.execute(r"SELECT kmp.group, kmp.group_desc FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid WHERE kmb.kegiatan_uuid = $1 AND kmb.mitra_id = $2 GROUP BY kmp.group,kmp.group_desc",parameters: [structure.kegiatan_uuid!,structure.mitra_id!]);
        List<String> mitra_penugasan = [];
        result3.forEach((el){
          mitra_penugasan.add((el.toColumnMap()["group_desc"] as String?)??"");
        });
        structure.mitra_penugasan = mitra_penugasan;

        //SurveiResponseStructure
        var resultSurvei = await tx.execute(r'SELECT s.uuid as survei_uuid, s.survei_type as survei_type, s.description as survei_description, s.version as survei_version,  qb.uuid as questions_bloc_uuid, qb.title as questions_bloc_title, qb.description as questions_bloc_description, qb."order" as questions_bloc_order, qb.tag as questions_bloc_tag, qg.uuid as questions_group_uuid, qg.title as questions_group_title, qg.description as questions_group_description, qg."order" as questions_group_order, qg.tag as questions_group_tag, qi.uuid as questions_item_uuid, qi.title as questions_item_title, qi.description as questions_item_description, qi."order" as questions_item_order, qi.tag as questions_item_tag, qi.validation as questions_item_validation, qo.uuid as questions_option_uuid, qo.title as questions_option_title, qo.description as questions_option_description, qo."order" as questions_option_order, qo.value as questions_option_value, qo.tag as questions_option_tag FROM survei s left join questions_bloc qb ON s.uuid = qb.survei_uuid left join questions_group qg on qb.uuid = qg.questions_bloc_uuid left join questions_item qi on qg.uuid = qi.questions_group_uuid left join questions_option qo on qi.uuid = qo.questions_item_uuid where s.uuid = $1 order by qo."order" ASC, qi."order" ASC, qg."order" ASC, qb."order" ASC',parameters: [
          structure.response!.survei_uuid
        ]);

        if(resultSurvei.isEmpty){
          throw Exception("There is No Data For This Survei ${structure.response!.survei_uuid}");
        }

        Map<String,AnswerAssignment> mapAnswers = {};
        var resultCurrentResponse = await tx.execute(r"SELECT * FROM answer_assignment aa WHERE aa.response_assignment_uuid = $1",parameters: [structure.response!.uuid!]);
        resultCurrentResponse.forEach((el){
          try {
            AnswerAssignment answer = AnswerAssignment.fromJson(el.toColumnMap());
            mapAnswers[answer.uuid!] = answer;
          } catch(err){
            print(err);
          }
        });
        

        //iterate for survei
        Map<String,SurveiResponseStructure> surveiStructureMap = {};
        for(var item in resultSurvei){
          try {
            Map<String,dynamic> itemMap = item.toColumnMap();
            String survei_uuid = itemMap["survei_uuid"] as String;
            if(!surveiStructureMap.containsKey(survei_uuid)){
              String survei_type = itemMap["survei_type"] as String;
              String survei_description = itemMap["survei_description"] as String;
              int survei_version = itemMap["survei_version"] as int;
              List<QuestionsBlocResponseStructure> questions_bloc = [];
              SurveiResponseStructure surveiStructure = SurveiResponseStructure(
                survei_uuid: survei_uuid,
                survei_type: survei_type, 
                survei_description: survei_description, 
                survei_version: survei_version, 
                blocs: questions_bloc
              );
              surveiStructureMap[survei_uuid] = surveiStructure;
              continue;
            }
          } catch(e){
            print("Error ${e}");
          }
        }

        // String? uuid;
        // String title;
        // String description;
        // int order;
        // int value;
        // String tag;
        // String questions_item_uuid;

        //iterate options
        Map<String,List<QuestionsOption>> mapQI = {};
        for(var item in resultSurvei){
          try {
            Map<String,dynamic> mapItem = item.toColumnMap();
            print("Item : ${item.toColumnMap()}");
            QuestionsItemResponseStructure qi = QuestionsItemResponseStructure.fromJson(item.toColumnMap());
            String? questions_option_uuid = mapItem["questions_option_uuid"] as String?; 
            String questions_option_title = mapItem["questions_option_title"] as String;
            String questions_option_description = mapItem["questions_option_description"] as String;
            int questions_option_order = mapItem["questions_option_order"] as int;
            int questions_option_value = mapItem["questions_option_value"] as int;
            String questions_option_tag = mapItem["questions_option_tag"] as String;

            QuestionsOption qo = QuestionsOption(uuid:questions_option_uuid,title: questions_option_title, description: questions_option_description, order: questions_option_order, value: questions_option_value, tag: questions_option_tag, questions_item_uuid: qi.questions_item_uuid!);

            if(qo.uuid == null){
              continue;
            }

            if(mapQI.containsKey(qi.questions_item_uuid)){
              List<QuestionsOption> listQO = mapQI[qi.questions_item_uuid]??[];
              listQO.add(qo);
              continue;
            }
            mapQI[qi.questions_item_uuid!] = [qo];
          } catch(e){
            print(e);
            continue;
          }
        }

        // String? uuid;
        // String title;
        // String description;
        // String validation;
        // int order;
        // String questions_group_uuid;
        // String tag;
        // List<QuestionsOption> options;
        // AnswerAssignment? answer;

        print('EXECUTED 1');

        //iterate item
        Map<String,List<QuestionsItemResponseStructure>> mapQG = {};
        List<String> doneQI = [];
        for(var item in resultSurvei){
          try {
            Map<String,dynamic> mapItem = item.toColumnMap();
            QuestionsGroupResponseStructure qg = QuestionsGroupResponseStructure.fromJson(mapItem);
            if(qg.questions_group_uuid == null) {continue;}
            QuestionsItemResponseStructure qi = QuestionsItemResponseStructure.fromJson(mapItem);
            if(doneQI.contains(qi.questions_item_uuid)){
              continue;
            }
            qi.answer = mapAnswers[qi.questions_item_uuid];
            if(mapQG.containsKey(qg.questions_group_uuid)){
              qi.questions_options = mapQI[qi.questions_item_uuid]??[];
              mapQG[qg.questions_group_uuid]!.add(qi);
              doneQI.add(qi.questions_item_uuid!);
              continue;
            }
            qi.questions_options = mapQI[qi.questions_item_uuid]??[];
            mapQG[qg.questions_group_uuid!] = [qi];
            doneQI.add(qi.questions_item_uuid!);
          } catch(e){
            print("Error Iterate ${e}");
            continue;
          }
        }

        print('EXECUTED 2');

        //iterate group
        Map<String,List<QuestionsGroupResponseStructure>> mapQB = {};
        List<String> doneQG = [];
        for(var item in resultSurvei){
            try {
              Map<String,dynamic> mapItem = item.toColumnMap();
              QuestionsBlocResponseStructure qb = QuestionsBlocResponseStructure.fromJson(mapItem);
              if(qb.questions_bloc_uuid == null){
                continue;
              }
              QuestionsGroupResponseStructure qg = QuestionsGroupResponseStructure.fromJson(mapItem);
              if(doneQG.contains(qg.questions_group_uuid)){
                continue;
              }
              if(mapQB.containsKey(qb.questions_bloc_uuid)){
                qg.items = mapQG[qg.questions_group_uuid]??[];
                mapQB[qb.questions_bloc_uuid]!.add(qg);
                doneQG.add(qg.questions_group_uuid!);
                continue;
              }
              qg.items = mapQG[qg.questions_group_uuid]??[];
              // qb.groups!.add(qg);
              mapQB[qb.questions_bloc_uuid!] = [qg];
              doneQG.add(qg.questions_group_uuid!);
            } catch(e){
              log("Error Iterate ${e}");
              continue;
            }
        }

        //iterate bloc
        List<String> doneQB = [];
        Map<String,List<QuestionsBlocResponseStructure>> mapSurvei = {};
        for(var item in resultSurvei){
            try {
              Map<String,dynamic> mapItem = item.toColumnMap();
              SurveiResponseStructure survei = SurveiResponseStructure.fromJson(mapItem);
              if(survei.survei_uuid == null){
                continue;
              }
              QuestionsBlocResponseStructure qb = QuestionsBlocResponseStructure.fromJson(mapItem);
              if(doneQB.contains(qb.questions_bloc_uuid)){
                continue;
              }
              if(mapSurvei.containsKey(survei.survei_uuid)){
                qb.groups = mapQB[qb.questions_bloc_uuid]??[];
                mapSurvei[qb.questions_bloc_uuid]!.add(qb);
                doneQB.add(qb.questions_bloc_uuid!);
                continue;
              }
              qb.groups = mapQB[qb.questions_bloc_uuid]??[];
              // qb.groups!.add(qb);     
              mapSurvei[survei.survei_uuid!] = [qb];
              doneQB.add(qb.questions_bloc_uuid!);
            } catch(e){
              print("Error Iterate ${e}");
              continue;
            }
        }
        structure.survei = surveiStructureMap.values.first..blocs = mapSurvei.values.first;

        //then get all answer for this response_assignment
        Result allAnswerResult = await tx.execute(r"SELECT * FROM answer_assignment aa WHERE aa.response_assignment_uuid = $1",parameters: [uuid as String]); 
        //map all answer with key is questions_item_uuid
        Map<String,AnswerAssignment> allAnswerMap = {};
        for(var item in allAnswerResult){
          AnswerAssignment answer = AnswerAssignment.fromJson(item.toColumnMap());
          allAnswerMap[answer.questions_item_uuid] = answer;
        }
        structure.survei?.blocs?.forEach((el) {
          el.groups?.forEach((el2) {
            el2.items?.forEach((el3){
              el3.answer = allAnswerMap[el3.questions_item_uuid]??null;
            });
          });
        });

        return structure;
      } catch(err){
        log("Error Generate Response Assignment ${err}");
        throw Exception("Error Generate Response Assignment ${err}");
      }
    });
  }

  //this only upsert data, not check it if its complete
  Future<void> upsertResponseAnswersByUuidSave(dynamic uuid, ResponseAssignment response, List<AnswerAssignment> answers) async {
    return this.conn.connectionPool.runTx<void>((tx) async {
      String currentTime = DatetimeHelper.getCurrentMakassarTime();

      //update response_assignment
      var result1 = await tx.execute(r"UPDATE response_assignment SET updated_at = $1, notes = $2 WHERE uuid = $3",parameters: [currentTime,response.notes,uuid as String]);
      if(result1.affectedRows <= 0){
        throw Exception("NO Data Updated");
      }

      //insert or update answers
      for(var item in answers){
        // String? uuid;
        // String response_assignment_uuid;
        // String questions_item_uuid;
        // String? questions_option_uuid;
        String uuid = Uuid().v1();
        var result2 = await tx.execute(r"INSERT INTO answer_assignment VALUES($1,$2,$3,$4) ON CONFLICT(response_assignment_uuid,questions_item_uuid) DO UPDATE SET questions_option_uuid = $5 returning uuid",parameters: [
          uuid as String,
          item.response_assignment_uuid,
          item.questions_item_uuid,
          item.questions_option_uuid,
          item.questions_option_uuid
        ]);
        if(result2.isEmpty){
          throw Exception("Error Occured While insert Answer ${response.structure_uuid}}");
        }
      }
    });
  }

  //this upsert data, and validate check based survei_uuid
  Future<ResponseAssignment?> upsertResponseAnswersByUuidSubmit(dynamic uuid, ResponseAssignment response, List<AnswerAssignment> answers) async {
    return this.conn.connectionPool.runTx<ResponseAssignment?>((tx) async {
      String currentTime = DatetimeHelper.getCurrentMakassarTime();

      //update response_assignment
      var result1 = await tx.execute(r"UPDATE response_assignment SET updated_at = $1, notes = $2 WHERE uuid = $3",parameters: [currentTime,response.notes,uuid as String]);
      if(result1.affectedRows <= 0){
        throw Exception("NO Data Updated");
      }

      //insert or update answers
      for(var item in answers){
        // String? uuid;
        // String response_assignment_uuid;
        // String questions_item_uuid;
        // String? questions_option_uuid;
        String uuid = Uuid().v1();
        var result2 = await tx.execute(r"INSERT INTO answer_assignment VALUES($1,$2,$3,$4) ON CONFLICT(response_assignment_uuid,questions_item_uuid) DO UPDATE SET questions_option_uuid = $5 returning uuid",parameters: [
          uuid as String,
          item.response_assignment_uuid,
          item.questions_item_uuid,
          item.questions_option_uuid,
          item.questions_option_uuid
        ]);
        if(result2.isEmpty){
          throw Exception("Error Occured While insert Answer ${response.structure_uuid}}");
        }
      }

      //validate if all questions items have answer assignment 
      try {
        var result2 = await tx.execute(r"SELECT qi.* FROM questions_item qi LEFT JOIN questions_group qg ON qi.questions_group_uuid = qg.uuid LEFT JOIN questions_bloc qb ON qg.questions_bloc_uuid = qb.uuid LEFT JOIN survei s ON qb.survei_uuid = s.uuid WHERE s.uuid = $1",parameters: [
          response.survei_uuid
        ]);
        Map<String,bool> answersExistance = {}; 
        List<QuestionsItem> listObject = result2.map((el) {
          QuestionsItem qi = QuestionsItem.fromJson(el.toColumnMap());
          answersExistance[qi.uuid!] = false;
          return qi;
        }).toList();

        String query3 = r'''
SELECT
aa.uuid as aa_uuid,
aa.response_assignment_uuid as aa_response_assignment_uuid,
aa.questions_item_uuid as aa_questions_item_uuid,

qo.uuid as qo_uuid,
qo.title as qo_title,
qo.description as qo_description,
qo.order as qo_order,
qo.value as qo_value,
qo.tag as qo_tag,
qo.questions_item_uuid as qo_questions_item_uuid

FROM answer_assignment aa 
LEFT JOIN questions_option qo
ON aa.questions_option_uuid = qo.uuid

WHERE aa.response_assignment_uuid = $1
''';

        var result3 = await tx.execute(query3,parameters: [
          response.uuid!
        ]);
        if(result3.isEmpty){
          throw Exception("There is No Answer Detected");
        }
        List<AnswerAssignmentWithOptionDetails> listAnswer = result3.map((el) {
          AnswerAssignmentWithOptionDetails answer = AnswerAssignmentWithOptionDetails.fromJson(el.toColumnMap());
          answer.aa_questions_option_details = QuestionsOptionDetails.fromJson(el.toColumnMap());
          if(answersExistance.containsKey(answer.aa_questions_item_uuid)){
            answersExistance[answer.aa_questions_item_uuid] = true;
          }
          return answer;
        }).toList();

        //check answersExistance value, is all value true?
        //if there false value, it will throw Error and return null;
        answersExistance.keys.forEach((el){
          if(answersExistance[el] == false){
            throw Exception("There is No Answer For This Questions Item UUID ${el}");
          }
        });


      //get all response_structure
      ResponseAssignmentStructure responseStructure =  await generateResponseStructureWithAnswersByTx(tx, uuid);


      //if it all fine, then calculate ickm value for this response, if it failed nothing happen
      try {
        //calculate ickm value for this kegiatan_mitra
        double ickm = await IckmHelper.calculateIndex(responseStructure.survei!, listAnswer);

        String newUuid = Uuid().v1();
        //insert or update it to ickm table
        String query4 = r"INSERT INTO ickm_mitra(uuid,mitra_id,kegiatan_uuid,ickm) VALUES($1,$2,$3,$4) ON CONFLICT(mitra_id,kegiatan_uuid) DO UPDATE SET ickm = $5 RETURNING uuid";
        var resultInsertIckm = await tx.execute(query4,parameters:[
          newUuid,
          responseStructure.mitra_id!,
          responseStructure.kegiatan_uuid!,
          ickm,
          ickm
        ]);
        if(resultInsertIckm.isEmpty){
          return null;
        }
      } catch(err){
        return null;
      }

      //after all update response_assignment set completed
      var lastUpdate = await tx.execute(
        r"UPDATE response_assignment SET updated_at = $1, is_completed = $2 WHERE uuid = $3 RETURNING *",
        parameters: [currentTime, true, uuid as String]
      );
      if(result1.affectedRows <= 0){
        // print("Failed");
        throw Exception("NO Data Updated");
      }
      // print("Success");
      return ResponseAssignment.fromJson(lastUpdate.first.toColumnMap());
        
      } catch(err){
        log("Error while Validate and Calculate ICKM ${err}");
        return null;
      }
    });
  }
}


Future<ResponseAssignmentStructure> generateResponseStructureWithAnswersByTx(TxSession tx, dynamic uuid) async {
  try {
    var result = await tx.execute(r"select ra.*, k.uuid as kegiatan_uuid, k.name as kegiatan_name, k.start as kegiatan_start, k.end  as kegiatan_end, kpm.start_date as kuesioner_penilaian_start, kpm.end_date as kuesioner_penilaian_mitra_end, p.username as penilai_username, p.fullname as penilai_name, m.mitra_id as mitra_id, m.username  as mitra_username, m.fullname as mitra_name from response_assignment ra left join structure_penilaian_mitra spm on ra.structure_uuid = spm.uuid left join kuesioner_penilaian_mitra kpm on spm.kuesioner_penilaian_mitra_uuid  = kpm.uuid left join kegiatan k on kpm.kegiatan_uuid = k.uuid left join mitra m on spm.mitra_username = m.username left join pegawai p on spm.penilai_username = p.username WHERE ra.uuid = $1",parameters: [uuid as String]);
        if(result.isEmpty){
          throw Exception("There is No Response Assignment ${uuid as String}");
        }
        ResponseAssignmentStructure structure = ResponseAssignmentStructure.fromJson(result.first.toColumnMap());
        ResponseAssignment response = ResponseAssignment.fromJson(result.first.toColumnMap());
        structure.response = response;

        //add implementations to get others field froms structure : 
        //status
        var result2 = await tx.execute(r"SELECT * FROM kegiatan_mitra_bridge kmb WHERE kmb.kegiatan_uuid = $1 AND kmb.mitra_id = $2",parameters: [
          structure.kegiatan_uuid!,
          structure.mitra_id!
        ]);
        if(result2.isEmpty){
          throw Exception("This Mitra Not Have Relation For That Kegiatan, Maybe Deleted. Try to add again");
        }
        KegiatanMitraBridge kmb = KegiatanMitraBridge.fromJson(result2.first.toColumnMap());
        structure.mitra_status = kmb.status;

        //List<String> : List Penugasan Group
        var result3 = await tx.execute(r"SELECT kmp.group, kmp.group_desc FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid WHERE kmb.kegiatan_uuid = $1 AND kmb.mitra_id = $2 GROUP BY kmp.group,kmp.group_desc",parameters: [structure.kegiatan_uuid!,structure.mitra_id!]);
        List<String> mitra_penugasan = [];
        result3.forEach((el){
          mitra_penugasan.add((el.toColumnMap()["group_desc"] as String?)??"");
        });
        structure.mitra_penugasan = mitra_penugasan;

        //SurveiResponseStructure
        var resultSurvei = await tx.execute(r'SELECT s.uuid as survei_uuid, s.survei_type as survei_type, s.description as survei_description, s.version as survei_version,  qb.uuid as questions_bloc_uuid, qb.title as questions_bloc_title, qb.description as questions_bloc_description, qb."order" as questions_bloc_order, qb.tag as questions_bloc_tag, qg.uuid as questions_group_uuid, qg.title as questions_group_title, qg.description as questions_group_description, qg."order" as questions_group_order, qg.tag as questions_group_tag, qi.uuid as questions_item_uuid, qi.title as questions_item_title, qi.description as questions_item_description, qi."order" as questions_item_order, qi.tag as questions_item_tag, qi.validation as questions_item_validation, qo.uuid as questions_option_uuid, qo.title as questions_option_title, qo.description as questions_option_description, qo."order" as questions_option_order, qo.value as questions_option_value, qo.tag as questions_option_tag FROM survei s left join questions_bloc qb ON s.uuid = qb.survei_uuid left join questions_group qg on qb.uuid = qg.questions_bloc_uuid left join questions_item qi on qg.uuid = qi.questions_group_uuid left join questions_option qo on qi.uuid = qo.questions_item_uuid where s.uuid = $1 order by qo."order" ASC, qi."order" ASC, qg."order" ASC, qb."order" ASC',parameters: [
          structure.response!.survei_uuid
        ]);

        if(resultSurvei.isEmpty){
          throw Exception("There is No Data For This Survei ${structure.response!.survei_uuid}");
        }

        Map<String,AnswerAssignment> mapAnswers = {};
        var resultCurrentResponse = await tx.execute(r"SELECT * FROM answer_assignment aa WHERE aa.response_assignment_uuid = $1",parameters: [structure.response!.uuid!]);
        resultCurrentResponse.forEach((el){
          try {
            AnswerAssignment answer = AnswerAssignment.fromJson(el.toColumnMap());
            mapAnswers[answer.uuid!] = answer;
          } catch(err){
            print(err);
          }
        });
        

        //iterate for survei
        Map<String,SurveiResponseStructure> surveiStructureMap = {};
        for(var item in resultSurvei){
          try {
            Map<String,dynamic> itemMap = item.toColumnMap();
            String survei_uuid = itemMap["survei_uuid"] as String;
            if(!surveiStructureMap.containsKey(survei_uuid)){
              String survei_type = itemMap["survei_type"] as String;
              String survei_description = itemMap["survei_description"] as String;
              int survei_version = itemMap["survei_version"] as int;
              List<QuestionsBlocResponseStructure> questions_bloc = [];
              SurveiResponseStructure surveiStructure = SurveiResponseStructure(
                survei_uuid: survei_uuid,
                survei_type: survei_type, 
                survei_description: survei_description, 
                survei_version: survei_version, 
                blocs: questions_bloc
              );
              surveiStructureMap[survei_uuid] = surveiStructure;
              continue;
            }
          } catch(e){
            print("Error ${e}");
          }
        }

        // String? uuid;
        // String title;
        // String description;
        // int order;
        // int value;
        // String tag;
        // String questions_item_uuid;

        //iterate options
        Map<String,List<QuestionsOption>> mapQI = {};
        for(var item in resultSurvei){
          try {
            Map<String,dynamic> mapItem = item.toColumnMap();
            QuestionsItemResponseStructure qi = QuestionsItemResponseStructure.fromJson(item.toColumnMap());


            String? questions_option_uuid = mapItem["questions_option_uuid"] as String?; 
            String questions_option_title = mapItem["questions_option_title"] as String;
            String questions_option_description = mapItem["questions_option_description"] as String;
            int questions_option_order = mapItem["questions_option_order"] as int;
            int questions_option_value = mapItem["questions_option_value"] as int;
            String questions_option_tag = mapItem["questions_option_tag"] as String;

            QuestionsOption qo = QuestionsOption(uuid:questions_option_uuid,title: questions_option_title, description: questions_option_description, order: questions_option_order, value: questions_option_value, tag: questions_option_tag, questions_item_uuid: qi.questions_item_uuid!);

            if(qo.uuid == null){
              continue;
            }

            if(mapQI.containsKey(qi.questions_item_uuid)){
              List<QuestionsOption> listQO = mapQI[qi.questions_item_uuid]??[];
              listQO.add(qo);
              continue;
            }
            mapQI[qi.questions_item_uuid!] = [qo];
          } catch(e){
            print(e);
            continue;
          }
        }

        // String? uuid;
        // String title;
        // String description;
        // String validation;
        // int order;
        // String questions_group_uuid;
        // String tag;
        // List<QuestionsOption> options;
        // AnswerAssignment? answer;

        //iterate item
        Map<String,List<QuestionsItemResponseStructure>> mapQG = {};
        List<String> doneQI = [];
        for(var item in resultSurvei){
          try {
            Map<String,dynamic> mapItem = item.toColumnMap();
            QuestionsGroupResponseStructure qg = QuestionsGroupResponseStructure.fromJson(mapItem);
            if(qg.questions_group_uuid == null) {continue;}
            QuestionsItemResponseStructure qi = QuestionsItemResponseStructure.fromJson(mapItem);
            if(doneQI.contains(qi.questions_item_uuid)){
              continue;
            }
            qi.answer = mapAnswers[qi.questions_item_uuid];
            if(mapQG.containsKey(qg.questions_group_uuid)){
              qi.questions_options = mapQI[qi.questions_item_uuid]??[];
              mapQG[qg.questions_group_uuid]!.add(qi);
              doneQI.add(qi.questions_item_uuid!);
              continue;
            }
            qi.questions_options = mapQI[qi.questions_item_uuid]??[];
            mapQG[qg.questions_group_uuid!] = [qi];
            doneQI.add(qi.questions_item_uuid!);
          } catch(e){
            print("Error Iterate ${e}");
            continue;
          }
        }

        //iterate group
        Map<String,List<QuestionsGroupResponseStructure>> mapQB = {};
        List<String> doneQG = [];
        for(var item in resultSurvei){
            try {
              Map<String,dynamic> mapItem = item.toColumnMap();
              QuestionsBlocResponseStructure qb = QuestionsBlocResponseStructure.fromJson(mapItem);
              if(qb.questions_bloc_uuid == null){
                continue;
              }
              QuestionsGroupResponseStructure qg = QuestionsGroupResponseStructure.fromJson(mapItem);
              if(doneQG.contains(qg.questions_group_uuid)){
                continue;
              }
              if(mapQB.containsKey(qb.questions_bloc_uuid)){
                qg.items = mapQG[qg.questions_group_uuid]??[];
                mapQB[qb.questions_bloc_uuid]!.add(qg);
                doneQG.add(qg.questions_group_uuid!);
                continue;
              }
              qg.items = mapQG[qg.questions_group_uuid]??[];
              // qb.groups!.add(qg);
              mapQB[qb.questions_bloc_uuid!] = [qg];
              doneQG.add(qg.questions_group_uuid!);
            } catch(e){
              log("Error Iterate ${e}");
              continue;
            }
        }

        //iterate bloc
        List<String> doneQB = [];
        Map<String,List<QuestionsBlocResponseStructure>> mapSurvei = {};
        for(var item in resultSurvei){
            try {
              Map<String,dynamic> mapItem = item.toColumnMap();
              SurveiResponseStructure survei = SurveiResponseStructure.fromJson(mapItem);
              if(survei.survei_uuid == null){
                continue;
              }
              QuestionsBlocResponseStructure qb = QuestionsBlocResponseStructure.fromJson(mapItem);
              if(doneQB.contains(qb.questions_bloc_uuid)){
                continue;
              }
              if(mapSurvei.containsKey(survei.survei_uuid)){
                qb.groups = mapQB[qb.questions_bloc_uuid]??[];
                mapSurvei[qb.questions_bloc_uuid]!.add(qb);
                doneQB.add(qb.questions_bloc_uuid!);
                continue;
              }
              qb.groups = mapQB[qb.questions_bloc_uuid]??[];
              // qb.groups!.add(qb);     
              mapSurvei[survei.survei_uuid!] = [qb];
              doneQB.add(qb.questions_bloc_uuid!);
            } catch(e){
              print("Error Iterate ${e}");
              continue;
            }
        }
        structure.survei = surveiStructureMap.values.first..blocs = mapSurvei.values.first;

        //then get all answer for this response_assignment
        Result allAnswerResult = await tx.execute(r"SELECT * FROM answer_assignment aa WHERE aa.response_assignment_uuid = $1",parameters: [uuid as String]); 
        //map all answer with key is questions_item_uuid
        Map<String,AnswerAssignment> allAnswerMap = {};
        for(var item in allAnswerResult){
          AnswerAssignment answer = AnswerAssignment.fromJson(item.toColumnMap());
          allAnswerMap[answer.questions_item_uuid] = answer;
        }
        structure.survei?.blocs?.forEach((el) {
          el.groups?.forEach((el2) {
            el2.items?.forEach((el3){
              el3.answer = allAnswerMap[el3.questions_item_uuid]??null;
            });
          });
        });

        return structure;
  } catch(err){
    throw Exception("${err}");
  }
}