  // String id;
  // String name;
  // String code;
  // String type;  //PROVINSI OR EQUALS LEVEL


import 'package:my_first/models/daerah_tingkat_1.dart';
import 'package:my_first/models/daerah_tingkat_2.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:postgres/postgres.dart';

class DaerahTingkat2Repository extends MyRepository<DaerahTingkat2>{
  MyConnectionPool conn;

  DaerahTingkat2Repository(this.conn);

  Future<DaerahTingkat2> getById(dynamic id) async {
    return await this.conn.connectionPool.runTx<DaerahTingkat2>((tx) async {
      var result = await tx.execute(r"SELECT * FROM daerah_tingkat_2 WHERE id = $1",parameters: [
        id as String
      ]);
      if(result.isEmpty){
        throw Exception("There is no Data ${id}");
      }
      return DaerahTingkat2.fromJson(result.first.toColumnMap());
    });
  }

  //currently not support to update the id or code
  Future<DaerahTingkat2> update(dynamic id, DaerahTingkat2 object) async {
    return await this.conn.connectionPool.runTx<DaerahTingkat2>((tx) async {
      object.id = id as String;
      var result = await tx.execute(r"UPDATE daerah_tingkat_2 SET name = $1, type = $2 WHERE id = $3",parameters: [
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
  Future<DaerahTingkat2> create(DaerahTingkat2 object) async {
    return await this.conn.connectionPool.runTx<DaerahTingkat2>((tx) async {
      var result = await tx.execute(r"INSERT INTO daerah_tingkat_2 VALUES($1,$2,$3,$4,$5) RETURNING id",parameters: [
        object.id,
        object.name,
        object.code,
        object.type,
        object.dt1_id
      ]);
      if(result.isEmpty){
        throw Exception("Failed to Insert Data ${object.id as String}");
      }
      return object;
    });
  }

  Future<List<DaerahTingkat2>> readAll() async {
    return await this.conn.connectionPool.runTx<List<DaerahTingkat2>>((tx) async {
      List<DaerahTingkat2> listObject = [];
      var result = await tx.execute(r"SELECT * FROM daerah_tingkat_2");
      for(var item in result){
        try{
          DaerahTingkat2 object = DaerahTingkat2.fromJson(item.toColumnMap());
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
  Future<List<DaerahTingkat2>> readByStartsWithId(dynamic like_id) async {
    return await this.conn.connectionPool.runTx<List<DaerahTingkat2>>((tx) async {
      List<DaerahTingkat2> listObject = [];
      var result = await tx.execute(r"SELECT * FROM daerah_tingkat_2 WHERE id LIKE $1",parameters: [
        "${like_id as String}%"
      ]);
      for(var item in result){
        try{
          DaerahTingkat2 object = DaerahTingkat2.fromJson(item.toColumnMap());
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
      var result = await tx.execute(r"DELETE FROM daerah_tingkat_2 WHERE id = $1",parameters: [id as String]);
      if(result.affectedRows < 1){
        throw Exception("Fail to Delete ${id as String}");
      }
    });
  }
}
