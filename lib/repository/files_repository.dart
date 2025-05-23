import 'package:my_first/models/files.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';

// uuid,name,extension,location,created_at,created_by
class FilesRepository extends MyRepository<Files>{
  final MyConnectionPool conn;

  FilesRepository(this.conn);

  Future<Files> getById(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM files WHERE uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is No Data with uuid ${uuid}");
      }
      var resultMap = result.first.toColumnMap();
      Files files = Files.fromJson(resultMap);
      return files;
    });
  }

  Future<Files> update(dynamic uuid, Files object) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"UPDATE files SET name = $1, extension = $2, location = $3, created_at = $4, created_by = $5 WHERE uuid = $6",parameters: [
        object.name,
        object.extension,
        object.location,
        object.created_at,
        object.created_by,
        uuid as String
      ]);
      if(result.affectedRows <= 0){
        throw Exception("Data not updated.");
      }
      object.uuid = uuid as String;
      return object;
    });
  }

  //current implementation is not create physics file, only record in database
  //still considering best practice
  //currently add physical file manually, see add image implementation post /api/files/images for reference
  Future<Files> create(Files object) async {
    return this.conn.connectionPool.runTx((tx) async {
      String uuid =  Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO files VALUES($1,$2,$3,$4,$5,$6) RETURNING uuid", parameters: [
        object.uuid,
        object.name,
        object.extension,
        object.location,
        object.created_at,
        object.created_by
      ]);
      if(result.isEmpty){
        throw Exception("Error Create Files ${uuid}");
      }
      return object;
    });
  }

  Future<List<Files>> readAll() async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM files");
      List<Files> listFiles = [];
      for(var item in result){
        var itemFiles = Files.fromJson(item.toColumnMap());
        listFiles.add(itemFiles);
      }
      return listFiles;
    });
  }

  Future<void> delete(dynamic uuid) async {
    //current implementation is not delete Physical File, only record in Database
    //still considering for best practice, if u want delete physics file implements it manually
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"DELETE FROM files WHERE uuid = $1",parameters: [uuid as String]);
      if(result.affectedRows <= 0){
        throw Exception("Fail to delete Files ${uuid}");
      }
      return;
    });
  }
}