  // String id;
  // String name;
  // String code;
  // String type;  //PROVINSI OR EQUALS LEVEL

import 'package:my_first/models/daerah_tingkat_3.dart';
import 'package:my_first/models/daerah_tingkat_4.dart';
import 'package:my_first/models/daerah_tingkat_5.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:postgres/postgres.dart';

class DaerahTingkat5Repository extends MyRepository<DaerahTingkat5>{
  MyConnectionPool conn;

  DaerahTingkat5Repository(this.conn);

  Future<DaerahTingkat5> getById(dynamic id) async {
    return await this.conn.connectionPool.runTx<DaerahTingkat5>((tx) async {
      var result = await tx.execute(r"SELECT * FROM daerah_tingkat_5 WHERE id = $1",parameters: [
        id as String
      ]);
      if(result.isEmpty){
        throw Exception("There is no Data ${id}");
      }
      return DaerahTingkat5.fromJson(result.first.toColumnMap());
    });
  }

  //currently not support to update the id or code
  Future<DaerahTingkat5> update(dynamic id, DaerahTingkat5 object) async {
    return await this.conn.connectionPool.runTx<DaerahTingkat5>((tx) async {
      object.id = id as String;
      var result = await tx.execute(r"UPDATE daerah_tingkat_5 SET name = $1, type = $2 WHERE id = $3",parameters: [
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
  Future<DaerahTingkat5> create(DaerahTingkat5 object) async {
    return await this.conn.connectionPool.runTx<DaerahTingkat5>((tx) async {
      var result = await tx.execute(r"INSERT INTO daerah_tingkat_5 VALUES($1,$2,$3,$4,$5) RETURNING id",parameters: [
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
  

  Future<List<DaerahTingkat5>> readAll() async {
    return await this.conn.connectionPool.runTx<List<DaerahTingkat5>>((tx) async {
      List<DaerahTingkat5> listObject = [];
      var result = await tx.execute(r"SELECT * FROM daerah_tingkat_5");
      for(var item in result){
        try{
          DaerahTingkat5 object = DaerahTingkat5.fromJson(item.toColumnMap());
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
  Future<List<DaerahTingkat5>> readByStartsWithId(dynamic like_id) async {
    return await this.conn.connectionPool.runTx<List<DaerahTingkat5>>((tx) async {
      List<DaerahTingkat5> listObject = [];
      var result = await tx.execute(r"SELECT * FROM daerah_tingkat_5 WHERE id LIKE $1",parameters: [
        "${like_id as String}%"
      ]);
      for(var item in result){
        try{
          DaerahTingkat5 object = DaerahTingkat5.fromJson(item.toColumnMap());
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
      var result = await tx.execute(r"DELETE FROM daerah_tingkat_5 WHERE id = $1",parameters: [id as String]);
      if(result.affectedRows < 1){
        throw Exception("Fail to Delete ${id as String}");
      }
    });
  }
}
