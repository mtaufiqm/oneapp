import 'package:my_first/models/innovation.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';

class InnovationRepository extends MyRepository<Innovation>{
  final MyConnectionPool conn;

  InnovationRepository(this.conn);

  Future<Innovation> getById(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM innovation WHERE uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is No Data with uuid ${uuid}");
      }
      var resultMap = result.first.toColumnMap();
      Innovation innovation = Innovation.fromJson(resultMap);
      return innovation;
    });
  }

  Future<Innovation> update(dynamic uuid, Innovation object) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"UPDATE innovation SET name = $1, alias = $2, description = $3, files_uuid = $4, is_locked = $5, pwd = $6, created_at = $7, created_by = $8, last_updated = $9 WHERE uuid = $10",parameters: [
        object.name,
        object.alias,
        object.description,
        object.files_uuid,
        object.is_locked,
        object.pwd,
        object.created_at,
        object.created_by,
        object.last_updated,
        uuid as String
      ]);
      if(result.affectedRows <= 0){
        throw Exception("Data not updated.");
      }
      object.uuid = uuid as String;
      return object;
    });
  }

  Future<Innovation> create(Innovation object) async {
    return this.conn.connectionPool.runTx((tx) async {
      String uuid =  Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO innovation VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) RETURNING uuid", parameters: [
        object.uuid,
        object.name,
        object.alias,
        object.description,
        object.files_uuid,
        object.is_locked,
        object.pwd,
        object.created_at,
        object.created_by,
        object.last_updated,
      ]);
      if(result.isEmpty){
        throw Exception("Error Create Files ${uuid}");
      }
      return object;
    });
  }

  Future<List<Innovation>> readAll() async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM innovation");
      List<Innovation> listInnovations = [];
      for(var item in result){
        var itemInnovation = Innovation.fromJson(item.toColumnMap());
        listInnovations.add(itemInnovation);
      }
      return listInnovations;
    });
  }

  Future<void> delete(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"DELETE FROM innovation WHERE uuid = $1",parameters: [uuid as String]);
      if(result.affectedRows <= 0){
        throw Exception("Fail to delete Files ${uuid}");
      }
      return;
    });
  }
}