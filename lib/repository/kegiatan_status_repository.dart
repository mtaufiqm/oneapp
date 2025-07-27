import 'package:my_first/models/kegiatan_status.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';

class KegiatanStatusRepository extends MyRepository<KegiatanStatus>{
  MyConnectionPool conn;

  KegiatanStatusRepository(this.conn);

  Future<KegiatanStatus> getById(dynamic id) async {
    return this.conn.connectionPool.runTx<KegiatanStatus>((tx) async {
      var result = await tx.execute(r"SELECT * FROM kegiatan_status ks WHERE ks.id = $1",parameters: [id as int]);
      if(result.isEmpty){
        throw Exception("There is no Data ${id as int}");
      }
      return KegiatanStatus.fromJson(result.first.toColumnMap());
    });
  }
  Future<KegiatanStatus> update(dynamic id, KegiatanStatus object) async {
    return this.conn.connectionPool.runTx<KegiatanStatus>((tx) async {
      var result = await tx.execute(r"UPDATE kegiatan_status SET description = $1 WHERE id = $2",parameters: [object.description, id as int]);
      if(result.affectedRows <= 0){
        throw Exception("Failed Update Data");
      }
      object.id = id as int;
      return object;
    });
  }

  //currently there is no implementations
  Future<KegiatanStatus> create(KegiatanStatus object) async {
    return object;
  }

  Future<List<KegiatanStatus>> readAll() async {
    return this.conn.connectionPool.runTx<List<KegiatanStatus>>((tx) async {
      var result = await tx.execute(r"SELECT * FROM kegiatan_status ks ORDER BY ks.id ASC");
      List<KegiatanStatus> listObject = [];
      for(var item in result){
        KegiatanStatus object = KegiatanStatus.fromJson(item.toColumnMap());
        listObject.add(object);
      }
      return listObject;
    });
  }

  Future<void> delete(dynamic id) async {
    return this.conn.connectionPool.runTx<void>((tx) async {
      var result = await tx.execute(r"DELETE FROM kegiatan_status WHERE id = $1",parameters: [id as int]);
      if(result.affectedRows <= 0){
        throw Exception("Failed Delete Data ${id as int}");
      }
      return;
    });
  }
}