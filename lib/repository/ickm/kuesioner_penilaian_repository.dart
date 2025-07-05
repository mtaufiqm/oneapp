import 'package:my_first/models/ickm/kuesioner_penilaian_mitra.dart';
import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';

  // String? uuid;
  // String kegiatan_uuid;
  // String title;
  // String description;
  // String? start_date;
  // String? end_date;

class KuesionerPenilaianRepository extends MyRepository<KuesionerPenilaianMitra>{
  MyConnectionPool conn;

  KuesionerPenilaianRepository(this.conn);

  Future<KuesionerPenilaianMitra> getById(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM kuesioner_penilaian_mitra WHERE uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is No Data with uuid ${uuid}");
      }
      var resultMap = result.first.toColumnMap();
      KuesionerPenilaianMitra object = KuesionerPenilaianMitra.fromJson(resultMap);
      return object;
    });
  }

  Future<KuesionerPenilaianMitraDetails> getDetailsById(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM kuesioner_penilaian_mitra WHERE uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is No Data with uuid ${uuid}");
      }
      var resultMap = result.first.toColumnMap();
      var result2 = await tx.execute(r"SELECT * FROM kegiatan k WHERE k.uuid = $1",parameters: [resultMap["kegiatan_uuid"] as String]);
      var result2Map = result2.first.toColumnMap();

      KuesionerPenilaianMitraDetails object = KuesionerPenilaianMitraDetails.fromJson(resultMap);
      Kegiatan object2 = Kegiatan.fromJson(result2Map);
      
      object.kegiatan = object2;
      return object;
    });
  }

  Future<KuesionerPenilaianMitra> getByKegiatan(dynamic uuid) async {
    return this.conn.connectionPool.runTx<KuesionerPenilaianMitra>((tx) async {
      var result = await tx.execute(r"SELECT * FROM kuesioner_penilaian_mitra WHERE kegiatan_uuid = $1");
      //if there is no penilaian for spesific kegiatan
      if(result.isEmpty){
        throw Exception("There is no Data with kegiatan_uuid ${uuid as String}");
      }
      var resultMap = result.first.toColumnMap();
      KuesionerPenilaianMitra object = KuesionerPenilaianMitra.fromJson(resultMap);
      return object;
    });
  }

  Future<bool> checkKuesionerPenilaianByKegiatan(dynamic uuid) async {
    return this.conn.connectionPool.runTx<bool>((tx) async {
      var result = await tx.execute(r"SELECT uuid FROM kuesioner_penilaian_mitra WHERE kegiatan_uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        return false;
      } else {
        return true;
      }
    });
  }

  Future<KuesionerPenilaianMitra> update(dynamic uuid, KuesionerPenilaianMitra object) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"UPDATE kuesioner_penilaian_mitra SET kegiatan_uuid = $1, title = $2, description = $3, start_date = $4, end_date = $5 WHERE uuid = $6",parameters: [
        object.kegiatan_uuid,
        object.title,
        object.description,
        object.start_date,
        object.end_date,
        uuid as String
      ]);
      if(result.affectedRows <= 0){
        throw Exception("Data not updated.");
      }
      object.uuid = uuid as String;
      return object;
    });
  }

  Future<KuesionerPenilaianMitra> create(KuesionerPenilaianMitra object) async {
    return this.conn.connectionPool.runTx((tx) async {
      String uuid =  Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO kuesioner_penilaian_mitra(uuid, kegiatan_uuid, title, description, start_date, end_date) VALUES($1,$2,$3,$4,$5,$6) RETURNING uuid", parameters: [
        object.uuid,
        object.kegiatan_uuid,
        object.title,
        object.description,
        object.start_date,
        object.end_date
      ]);
      if(result.isEmpty){
        throw Exception("Error Create Kuesioner Penilaian Mitra ${uuid}");
      }
      return object;
    });
  }


  //continue this implementation
  Future<KuesionerPenilaianMitra> createWithStructure(KuesionerPenilaianMitra object,List<StructurePenilaianMitra> listStructure) async {
    return this.conn.connectionPool.runTx((tx) async {
      String uuid =  Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO kuesioner_penilaian_mitra(uuid, kegiatan_uuid, title, description, start_date, end_date) VALUES($1,$2,$3,$4,$5,$6) RETURNING uuid", parameters: [
        object.uuid,
        object.kegiatan_uuid,
        object.title,
        object.description,
        object.start_date,
        object.end_date
      ]);

      if(result.isEmpty){
        throw Exception("Error Create Kuesioner Penilaian Mitra ${uuid}");
      }
      return object;
    });
  }

  Future<List<KuesionerPenilaianMitra>> readAll() async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM kuesioner_penilaian_mitra ORDER BY end_date DESC");
      List<KuesionerPenilaianMitra> listObject = [];
      for(var item in result){
        var object = KuesionerPenilaianMitra.fromJson(item.toColumnMap());
        listObject.add(object);
      }
      return listObject;
    });
  }

  Future<List<KuesionerPenilaianMitra>> readAllByPenilai(String username) async {
    return this.conn.connectionPool.runTx<List<KuesionerPenilaianMitra>>((tx) async {
      var result = await tx.execute(r"SELECT * FROM kuesioner_penilaian_mitra WHERE uuid IN(SELECT kuesioner_penilaian_mitra_uuid FROM structure_penilaian_mitra spm WHERE spm.penilai_username = $1) ORDER BY end_date DESC",parameters: [username]);
      List<KuesionerPenilaianMitra> listObject = [];
      for(var item in result){
        KuesionerPenilaianMitra kpm = KuesionerPenilaianMitra.fromJson(item.toColumnMap());
        listObject.add(kpm);
      }
      return listObject;
    });
  }

  Future<void> delete(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"DELETE FROM kuesioner_penilaian_mitra WHERE uuid = $1",parameters: [uuid as String]);
      if(result.affectedRows <= 0){
        throw Exception("Fail to delete Kuesioner Penilaian Mitra ${uuid}");
      }
      return;
    });
  }
}