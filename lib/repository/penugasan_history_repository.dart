import 'package:my_first/blocs/datetime_helper.dart';
import 'package:my_first/models/penugasan_history.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

class PenugasanHistoryRepository extends MyRepository<PenugasanHistory>{
  MyConnectionPool conn;
  PenugasanHistoryRepository(this.conn);

  Future<PenugasanHistory> getById(dynamic id) async {
    return this.conn.connectionPool.runTx<PenugasanHistory>((tx) async {
      var result = await tx.execute(r"SELECT * FROM penugasan_history WHERE uuid = $1",parameters: [id as String]);
      return PenugasanHistory.fromJson(result.first.toColumnMap());
    });
  }

  Future<PenugasanHistory> update(dynamic id, PenugasanHistory object) async {
    return this.conn.connectionPool.runTx<PenugasanHistory>((tx) async {
      var result = await tx.execute(r"UPDATE penugasan_history SET penugasan_uuid = $1, status = $2, created_at = $3 WHERE uuid = $4",parameters: [
        object.penugasan_uuid,
        object.status,
        object.created_at,
        id as String
      ]);

      return PenugasanHistory.fromJson(result.first.toColumnMap());
    });
  }
  Future<PenugasanHistory> create(PenugasanHistory object) async {
    return this.conn.connectionPool.runTx((tx) async {
      var uuid = Uuid().v1();
      var created_at = DatetimeHelper.getCurrentMakassarTime();
      var result = await tx.execute(r"INSERT INTO penugasan_history VALUES($1,$2,$3,$4) returning uuid",
      parameters: [
        uuid,
        object.penugasan_uuid,
        object.status,
        created_at
      ]);
      if(result.isEmpty){
        throw Exception("Failed to Insert Data");
      }
      object.uuid = uuid;
      return object;
    });
  }

  //for now limit it to 100 rows, because there are no reasons to get all data 
  Future<List<PenugasanHistory>> readAll() async {
    return this.conn.connectionPool.runTx<List<PenugasanHistory>>((tx) async {
      List<PenugasanHistory> listObject = [];
      var result = await tx.execute(r"SELECT * FROM penugasan_history LIMIT 100");
      result.forEach((el){
        listObject.add(PenugasanHistory.fromJson(el.toColumnMap()));
      });
      return listObject;
    });
  }

  Future<List<PenugasanHistory>> readAllByPenugasanUuid(dynamic penugasan_uuid) async {
    return this.conn.connectionPool.runTx<List<PenugasanHistory>>((tx) async {
      List<PenugasanHistory> listObject = [];
      var result = await tx.execute(r"SELECT * FROM penugasan_history WHERE penugasan_uuid = $1 ORDER BY created_at ASC",parameters: [penugasan_uuid as String]);
      result.forEach((el){
        listObject.add(PenugasanHistory.fromJson(el.toColumnMap()));
      });
      return listObject;
    });
  }

  Future<void> delete(dynamic id) async {
    return this.conn.connectionPool.runTx<void>((tx) async {
      var result = await tx.execute(r"DELETE FROM penugasan_history WHERE uuid = $1",parameters: [
        id as String
      ]);

      //if no affected row
      if(result.affectedRows == 0) {
        throw Exception("Failed to Delete Data ${id as String}");
      }
    });
  }

}