import 'package:my_first/models/ickm/survei.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';

class SurveiRepository extends MyRepository<Survei> {
  MyConnectionPool conn;

  SurveiRepository(this.conn);

  Future<Survei> getById(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM survei WHERE uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is No Data with uuid ${uuid}");
      }
      var resultMap = result.first.toColumnMap();
      Survei survei = Survei.fromJson(resultMap);
      return survei;
    });
  }

  Future<Survei> update(dynamic uuid, Survei object) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"UPDATE survei SET survei_type = $1, description = $2 WHERE uuid = $11",parameters: [
        object.survei_type,
        object.description,
        uuid as String
      ]);
      if(result.affectedRows <= 0){
        throw Exception("Data not updated.");
      }
      object.uuid = uuid as String;
      return object;
    });
  }

  Future<Survei> create(Survei object) async {
    return this.conn.connectionPool.runTx((tx) async {
      String uuid =  Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO survei(uuid, survei_type, description) VALUES($1,$2,$3) RETURNING uuid", parameters: [
        object.uuid,
        object.survei_type,
        object.description
      ]);
      if(result.isEmpty){
        throw Exception("Error Create Survei ${uuid}");
      }
      return object;
    });
  }

  Future<List<Survei>> readAll() async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM survei");
      List<Survei> listSurvei = [];
      for(var item in result){
        var itemSurvei = Survei.fromJson(item.toColumnMap());
        listSurvei.add(itemSurvei);
      }
      return listSurvei;
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