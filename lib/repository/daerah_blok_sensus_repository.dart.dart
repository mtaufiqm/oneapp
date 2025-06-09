  // String id;
  // String name;
  // String code;
  // String type;  //PROVINSI OR EQUALS LEVEL

import 'package:my_first/models/daerah_blok_sensus.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:postgres/postgres.dart';

class DaerahBlokSensusRepository extends MyRepository<DaerahBlokSensus>{
  MyConnectionPool conn;

  DaerahBlokSensusRepository(this.conn);

  Future<DaerahBlokSensus> getById(dynamic id) async {
    return await this.conn.connectionPool.runTx<DaerahBlokSensus>((tx) async {
      var result = await tx.execute(r"SELECT * FROM daerah_blok_sensus WHERE id = $1",parameters: [
        id as String
      ]);
      if(result.isEmpty){
        throw Exception("There is no Data ${id}");
      }
      return DaerahBlokSensus.fromJson(result.first.toColumnMap());
    });
  }

  //currently not support to update the id or code
  Future<DaerahBlokSensus> update(dynamic id, DaerahBlokSensus object) async {
    return await this.conn.connectionPool.runTx<DaerahBlokSensus>((tx) async {
      object.id = id as String;
      var result = await tx.execute(r"UPDATE daerah_blok_sensus SET name = $1, type = $2 WHERE id = $3",parameters: [
        object.name,
        object.type,
        object.id
      ]);
      if(result.affectedRows < 1){
        throw Exception("Failed to Update Data ${id as String}");
      }
      return object;
    });
  }
  Future<DaerahBlokSensus> create(DaerahBlokSensus object) async {
    return await this.conn.connectionPool.runTx<DaerahBlokSensus>((tx) async {
      var result = await tx.execute(r"INSERT INTO daerah_blok_sensus VALUES($1,$2,$3,$4,$5) RETURNING id",parameters: [
        object.id,
        object.name,
        object.code,
        object.type,
        object.dt4_id
      ]);
      if(result.isEmpty){
        throw Exception("Failed to Insert Data ${object.id as String}");
      }
      return object;
    });
  }
  

  Future<List<DaerahBlokSensus>> readAll() async {
    return await this.conn.connectionPool.runTx<List<DaerahBlokSensus>>((tx) async {
      List<DaerahBlokSensus> listObject = [];
      var result = await tx.execute(r"SELECT * FROM daerah_blok_sensus");
      for(var item in result){
        try{
          DaerahBlokSensus object = DaerahBlokSensus.fromJson(item.toColumnMap());
          listObject.add(object);
        } catch(e){
          print("Error : ${e}");
          continue;
        }
      }
      return listObject;
    });
  }

  //read starts_with
  Future<List<DaerahBlokSensus>> readByStartsWithId(dynamic like_id) async {
    return await this.conn.connectionPool.runTx<List<DaerahBlokSensus>>((tx) async {
      List<DaerahBlokSensus> listObject = [];
      var result = await tx.execute(r"SELECT * FROM daerah_blok_sensus WHERE id LIKE $1",parameters: [
        "${like_id as String}%"
      ]);
      for(var item in result){
        try{
          DaerahBlokSensus object = DaerahBlokSensus.fromJson(item.toColumnMap());
          listObject.add(object);
        } catch(e){
          print("Error : ${e}");
          continue;
        }
      }
      return listObject;
    });
  }

  Future<void> delete(dynamic id) async {
    return await this.conn.connectionPool.runTx<void>((tx) async {
      var result = await tx.execute(r"DELETE FROM daerah_blok_sensus WHERE id = $1",parameters: [id as String]);
      if(result.affectedRows < 1){
        throw Exception("Fail to Delete ${id as String}");
      }
    });
  }
}
