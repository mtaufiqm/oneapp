import 'package:my_first/models/ickm/response_assignment.dart';
import 'package:my_first/models/ickm/survei.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
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
}