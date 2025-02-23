import 'package:my_first/models/kuesioner_mitra.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

class KuesionerMitraRepository extends MyRepository<KuesionerMitra>{
  final MyConnectionPool conn;

  KuesionerMitraRepository(this.conn);

  //Continue This
  Future<KuesionerMitra> getById(dynamic uuid) async {
    return await this.conn.connectionPool.runTx<KuesionerMitra>((tx) async {
      Result result = await tx.execute(r"select * from kuesioner_mitra where uuid = $1",parameters: [uuid as String]);
      var kuesionerMitra = KuesionerMitra.from(result.first.toColumnMap());
      return kuesionerMitra;
    });
  }

    // required this.uuid,
    // required this.kegiatan_id,
    // required this.title,
    // required this.description,
  Future<KuesionerMitra> update(dynamic id, KuesionerMitra object) async {
    return await this.conn.connectionPool.runTx<KuesionerMitra>((tx) async {
      Result result = await tx.execute(r"UPDATE kuesioner_mitra SET kegiatan_id = $1, title = $2, description = $3 where uuid = $4",parameters: [
        object.kegiatan_id,
        object.title,
        object.description,
        object.uuid
      ]);
      return object;
    });

  }

  Future<KuesionerMitra> create(KuesionerMitra object) async {
    return await this.conn.connectionPool.runTx((tx) async {
      String uuid = Uuid().v1();
      Result result = await tx.execute(r"INSERT INTO kuesioner_mitra(uuid,kegiatan_id,title,description) VALUES($1,$2,$3,$4)",parameters: [
        uuid,
        object.kegiatan_id,
        object.title,
        object.description
      ]);
      return object;
    });
  }

  Future<List<KuesionerMitra>> readAll() async {
    return await this.conn.connectionPool.runTx((tx) async{
      Result result = await tx.execute(r"SELECT * FROM kuesioner_mitra");
      List<KuesionerMitra> returnValue = [];
      for(var item in result){
        returnValue.add(KuesionerMitra.from(item.toColumnMap()));
      }
      return returnValue;
    });
  }

  Future<void> delete(dynamic id) async {
    await this.conn.connectionPool.runTx((tx) async{
      Result result = await tx.execute(r"DELETE from kuesioner_mitra WHERE uuid = $1",parameters: [id as String]);
      if(result.affectedRows <= 0){
        throw Exception("Failed to delete data.");
      }
    });
  }

  Future<KuesionerMitra?> getByKegiatanUuid(String kegiatanUuid) async{
    try{
      return await this.conn.connectionPool.runTx((tx) async {
        Result result = await tx.execute(r"SELECT * FROM kuesioner_mitra WHERE kegiatan_id = $1",parameters: [kegiatanUuid]);
        if(result.isEmpty){
          return null;
        }
        return KuesionerMitra.from(result.first.toColumnMap());
      });
    } catch(e){
      return null;
    }
  }
}