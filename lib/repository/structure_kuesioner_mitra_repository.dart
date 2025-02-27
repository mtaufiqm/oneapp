import 'package:my_first/models/structure_kuesioner_mitra.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';

class StructureKuesionerMitraRepository extends MyRepository<StructureKuesionerMitra>{
    final MyConnectionPool conn;

    StructureKuesionerMitraRepository(this.conn);

    Future<StructureKuesionerMitra> getById(dynamic uuid) async {
      try{
        return this.conn.connectionPool.runTx<StructureKuesionerMitra>((tx) async {
          var result = await tx.execute(r"SELECT * FROM structure_kuesioner_mitra WHERE uuid = $1",parameters: [uuid]);
          if(result.isEmpty){
            throw Exception("Data not Exists!");
          }
          var model = StructureKuesionerMitra.from(result.first.toColumnMap());
          return model;
        });
      } catch(e){
        throw Exception("Data Not Exists!");
      }
    }

    Future<StructureKuesionerMitra> update(dynamic uuid, StructureKuesionerMitra object) async {
      return this.conn.connectionPool.runTx((tx) async {
        var result = await tx.execute(r"UPDATE structure_kuesioner_mitra SET kuesioner_mitra = $1, penilai_username = $2,mitra_username = $3,mitra_role = $4, versi_kuesioner = $5 WHERE uuid = $6",parameters: [object.kuesioner_mitra,object.penilai_username,object.mitra_username,object.mitra_role,object.versi_kuesioner,uuid as String]);
        if(result.affectedRows <= 0){
          throw Exception("Fails to Update Sctructure");
        }
        return object;
      });
    }

    Future<StructureKuesionerMitra> create(StructureKuesionerMitra object) async {
      return this.conn.connectionPool.runTx<StructureKuesionerMitra>((tx) async {
        String uuid = Uuid().v1();
        object.uuid = uuid;
        var result = await tx.execute(r"INSERT INTO structure_kuesioner_mitra(uuid,kuesioner_mitra,penilai_username,mitra_username,mitra_role,versi_kuesioner) VALUES($1,$2,$3,$4,$5,$6) RETURNING uuid",parameters: [
          object.uuid,
          object.kuesioner_mitra,
          object.penilai_username,
          object.mitra_username,
          object.mitra_role,
          object.versi_kuesioner
        ]);
        if(result.isEmpty){
          throw Exception("Error Create Structure Kuesioner");
        }
        return object;
      });
    }

    Future<List<StructureKuesionerMitra>> readAll() async {
      return await this.conn.connectionPool.runTx((tx) async {
        List<StructureKuesionerMitra> returnValue = [];
        var result = await tx.execute("SELECT * FROM structure_kuesioner_mitra");
        returnValue = result.map((item){
          return StructureKuesionerMitra.from(item.toColumnMap());
        }).toList();
        return returnValue;
      });
    }

    //CONTINUE THIS
    Future<void> delete(dynamic uuid) async {
      //still there is no implementation
      return await this.conn.connectionPool.runTx((tx) async {
        var result = await tx.execute(r"DELETE from structure_kuesioner_mitra WHERE uuid = $1");
        if(result.affectedRows <= 0){
          throw Exception("Error");
        }
        return;
      });
    }
}