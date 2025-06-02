import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';

  // String? uuid;
  // String kuesioner_penilaian_mitra_uuid;
  // String penilai_username;
  // String mitra_username;
  // String survei_uuid;

class StructurePenilaianRepository extends MyRepository<StructurePenilaianMitra>{
  final MyConnectionPool conn;

  StructurePenilaianRepository(this.conn);

  @override
  Future<StructurePenilaianMitra> getById(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM structure_penilaian_mitra WHERE uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is No Data with uuid ${uuid}");
      }
      var resultMap = result.first.toColumnMap();
      StructurePenilaianMitra documentation = StructurePenilaianMitra.fromJson(resultMap);
      return documentation;
    });
  }

  Future<StructurePenilaianMitra> update(dynamic uuid, StructurePenilaianMitra object) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"UPDATE structure_penilaian_mitra SET kuesioner_penilaian_mitra_uuid = $1, penilai_username = $2, mitra_username = $3, survei_uuid = $4 WHERE uuid = $8",parameters: [
        object.kuesioner_penilaian_mitra_uuid,
        object.penilai_username,
        object.mitra_username,
        object.survei_uuid,
        uuid as String
      ]);
      if(result.affectedRows <= 0){
        throw Exception("Data not updated.");
      }
      object.uuid = uuid as String;
      return object;
    });
  }

  Future<StructurePenilaianMitra> create(StructurePenilaianMitra object) async {
    return this.conn.connectionPool.runTx((tx) async {
      String uuid =  Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO structure_penilaian_mitra VALUES($1,$2,$3,$4,$5) RETURNING uuid", parameters: [
        object.uuid,
        object.kuesioner_penilaian_mitra_uuid,
        object.penilai_username,
        object.mitra_username,
        object.survei_uuid
      ]);
      if(result.isEmpty){
        throw Exception("Error Create structure ${uuid}");
      }
      return object;
    });
  }

  Future<List<StructurePenilaianMitra>> readAll() async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM structure_penilaian_mitra");
      List<StructurePenilaianMitra> listStructure = [];
      for(var item in result){
        var itemStructure = StructurePenilaianMitra.fromJson(item.toColumnMap());
        listStructure.add(itemStructure);
      }
      return listStructure;
    });
  }

  Future<void> delete(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"DELETE FROM structure_penilaian_mitra WHERE uuid = $1",parameters: [uuid as String]);
      if(result.affectedRows <= 0){
        throw Exception("Fail to delete structure ${uuid}");
      }
      return;
    });
  }
}