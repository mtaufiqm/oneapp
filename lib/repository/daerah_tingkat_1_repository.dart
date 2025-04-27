  // String id;
  // String name;
  // String code;
  // String type;  //PROVINSI OR EQUALS LEVEL


import 'package:my_first/models/daerah_tingkat_1.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:postgres/postgres.dart';

class DaerahTingkat1Repository extends MyRepository<DaerahTingkat1>{
  MyConnectionPool conn;

  DaerahTingkat1Repository(this.conn);

  Future<DaerahTingkat1> getById(dynamic id) async {
    return await this.conn.connectionPool.runTx<DaerahTingkat1>((tx) async {
      var result = await tx.execute(r"SELECT * FROM daerah_tingkat_1 WHERE id = $1",parameters: [
        id as String
      ]);
      if(result.isEmpty){
        throw Exception("There is no Data ${id}");
      }
      return DaerahTingkat1.fromJson(result.first.toColumnMap());
    });
  }

  //currently not support to update the id or code
  Future<DaerahTingkat1> update(dynamic id, DaerahTingkat1 object) async {
    return await this.conn.connectionPool.runTx<DaerahTingkat1>((tx) async {
      object.id = id as String;
      var result = await tx.execute(r"UPDATE daerah_tingkat_1 SET name = $1, type = $2 WHERE id = $3",parameters: [
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
  Future<DaerahTingkat1> create(DaerahTingkat1 object) async {
    return await this.conn.connectionPool.runTx<DaerahTingkat1>((tx) async {
      var result = await tx.execute(r"INSERT INTO daerah_tingkat_1 VALUES($1,$2,$3,$4) RETURNING id",parameters: [
        object.id,
        object.name,
        object.code,
        object.type
      ]);
      if(result.isEmpty){
        throw Exception("Failed to Insert Data ${object.id as String}");
      }
      return object;
    });
  }
  
  Future<List<DaerahTingkat1>> readAll() async {
    return await this.conn.connectionPool.runTx<List<DaerahTingkat1>>((tx) async {
      List<DaerahTingkat1> listObject = [];
      var result = await tx.execute(r"SELECT * FROM daerah_tingkat_1");
      for(var item in result){
        try{
          DaerahTingkat1 object = DaerahTingkat1.fromJson(item.toColumnMap());
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
      var result = await tx.execute(r"DELETE FROM daerah_tingkat_1 WHERE id = $1",parameters: [id as String]);
      if(result.affectedRows < 1){
        throw Exception("Fail to Delete ${id as String}");
      }
    });
  }
}
