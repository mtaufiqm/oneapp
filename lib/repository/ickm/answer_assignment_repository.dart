import 'package:my_first/models/ickm/answer_assignment.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';


  // String? uuid;
  // String response_assignment_uuid;
  // String questions_item_uuid;
  // String questions_option_uuid;

class AnswerAssignmentRepository extends MyRepository<AnswerAssignment> {
  MyConnectionPool conn;

  AnswerAssignmentRepository(this.conn);

    Future<AnswerAssignment> getById(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM answer_assignment WHERE uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is No Data with uuid ${uuid}");
      }
      var resultMap = result.first.toColumnMap();
      AnswerAssignment object = AnswerAssignment.fromJson(resultMap);
      return object;
    });
  }

  Future<AnswerAssignment> update(dynamic uuid, AnswerAssignment object) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"UPDATE answer_assignment SET response_assignment_uuid = $2, question_item_uuid = $3, questions_option_uuid = $4 WHERE uuid = $5",parameters: [
        object.response_assignment_uuid,
        object.questions_item_uuid,
        object.questions_option_uuid,
        uuid as String
      ]);
      if(result.affectedRows <= 0){
        throw Exception("Data not updated.");
      }
      object.uuid = uuid as String;
      return object;
    });
  }

  Future<AnswerAssignment> create(AnswerAssignment object) async {
    return this.conn.connectionPool.runTx((tx) async {
      String uuid =  Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO answer_assignment(uuid, response_assignment_uuid, question_item_uuid, questions_option_uuid) VALUES($1,$2,$3,$4) RETURNING uuid", parameters: [
        object.uuid,
        object.response_assignment_uuid,
        object.questions_item_uuid,
        object.questions_option_uuid
      ]);
      if(result.isEmpty){
        throw Exception("Error Create Answer Assignment ${uuid}");
      }
      return object;
    });
  }

  Future<List<AnswerAssignment>> createList(List<AnswerAssignment> listObject) async {
    return this.conn.connectionPool.runTx<List<AnswerAssignment>>((tx) async {
      List<AnswerAssignment> listReturn = [];

      //if there is one error it will rollback
      for(var item in listObject) {
        var uuid = Uuid().v1();
        var result = await tx.execute(r"INSERT INTO answer_assignment(uuid, response_assignment_uuid, question_item_uuid, questions_option_uuid) VALUES($1,$2,$3,$4) RETURNING uuid",parameters: [
          uuid,
          item.response_assignment_uuid,
          item.questions_item_uuid,
          item.questions_option_uuid
        ]);
        if(result.isEmpty){
          throw Exception("Error Create One of Answer Assignments");
        }
        item.uuid = uuid;
        listReturn.add(item);
      }
      return listReturn;
    });
  }

  Future<List<AnswerAssignment>> readAll() async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM answer_assignment");
      List<AnswerAssignment> listObject = [];
      for(var item in result){
        var object = AnswerAssignment.fromJson(item.toColumnMap());
        listObject.add(object);
      }
      return listObject;
    });
  }

  Future<void> delete(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"DELETE FROM answer_assignment WHERE uuid = $1",parameters: [uuid as String]);
      if(result.affectedRows <= 0){
        throw Exception("Fail to delete answer assignment ${uuid}");
      }
      return;
    });
  }
}

