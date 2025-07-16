import 'package:my_first/models/ickm/ickm_mitra.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';

class IckmMitraRepository extends MyRepository<IckmMitra> {
  MyConnectionPool conn;

  IckmMitraRepository(this.conn);

  Future<IckmMitra> getById(dynamic id) async {
    return this.conn.connectionPool.runTx<IckmMitra>((tx) async {
      var result = await tx.execute(r"SELECT * FROM ickm_mitra WHERE uuid = $1",parameters: [id as String]);
      if(result.isEmpty){
        throw Exception("There is No Data with ID ${id as String}");
      }
      IckmMitra item = IckmMitra.fromJson(result.first.toColumnMap());
      return item;
    });
  }
  Future<IckmMitra> update(dynamic id, IckmMitra object) async {
      return this.conn.connectionPool.runTx<IckmMitra>((tx) async {
      var result = await tx.execute(r"UPDATE ickm_mitra SET ickm = $1 WHERE uuid = $2 RETURNING uuid",
      parameters: [
        object.ickm,
        id as String
      ]);
      if(result.isEmpty){
        throw Exception("Failed Update Data with ID ${id as String}");
      }
      IckmMitra item = IckmMitra.fromJson(result.first.toColumnMap());
      return item;
    });
  }

  Future<IckmMitra> create(IckmMitra object) async {
    return this.conn.connectionPool.runTx<IckmMitra>((tx) async {
      String uuid = Uuid().v1();
      var result = await tx.execute(r"INSERT INTO ickm_mitra VALUES($1,$2,$3,$4) RETURNING uuid",
      parameters: [
        uuid,
        object.mitra_id,
        object.kegiatan_uuid,
        object.ickm
      ]);
      if(result.isEmpty){
        throw Exception("Failed Insert New Data");
      }
      object.uuid = uuid;
      return object;
    });
  }

  
  Future<IckmMitra> upsertByMitraIdAndKegiatanUuid(IckmMitra object) async {
      return this.conn.connectionPool.runTx<IckmMitra>((tx) async {
      var uuid = Uuid().v1();
      var result = await tx.execute(r"INSERT INTO ickm_mitra VALUES($1,$2,$3,$4) ON CONFLICT(mitra_id,kegiatan_uuid) DO UPDATE SET ickm = $5 RETURNING *",
      parameters: [
        uuid,
        object.mitra_id,
        object.kegiatan_uuid,
        object.ickm,
        object.ickm
      ]);
      if(result.isEmpty){
        throw Exception("Failed Insert or Update Data");
      }
      IckmMitra item = IckmMitra.fromJson(result.first.toColumnMap());
      return item;
    });
  }

  Future<double> getAverageIckmByMitraId(dynamic mitra_id) async {
    return this.conn.connectionPool.runTx<double>((tx) async {
      var result = await tx.execute(r"SELECT * FROM ickm_mitra WHERE mitra_id = $1",parameters: [mitra_id as String]);
      //if still there is no data just return 0.0
      if(result.isEmpty){
        return 0.0;
      }
      List<double> allValue = result.map((el) {
        IckmMitra item = IckmMitra.fromJson(el.toColumnMap());
        return item.ickm;
      }).toList();

      double total = 0.0;
      double average = 0.0;
      allValue.forEach((el) {
        total += el;
      });
      average = total/allValue.length;
      return average;
    });
  }

  //no implementations for now
  Future<List<IckmMitra>> readAll() async {
    return [];
  }


  Future<void> delete(dynamic id) async {
    return this.conn.connectionPool.runTx<void>((tx) async {
      var result = await tx.execute(r"DELETE FROM ickm_mitra WHERE uuid = $1 RETURNING uuid",parameters: [id as String]);
      if(result.isEmpty){
        throw Exception("Failed Delete Data with ID ${id as String}");
      }
      return;
    });
  }
}