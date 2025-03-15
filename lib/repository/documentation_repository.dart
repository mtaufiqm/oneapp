import 'package:my_first/models/documentation.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

  // "uuid" text PRIMARY KEY,
  // "name" text,
  // "details" text,
  // "documentation_time" text,
  // "files_uuid" text,
  // "created_at" text,
  // "created_by" text,
  // "updated_at" text
class DocumentationRepository extends MyRepository<Documentation>{
  final MyConnectionPool conn;
  DocumentationRepository(this.conn);

  Future<Documentation> getById(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM documentation WHERE uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is No Data with uuid ${uuid}");
      }
      var resultMap = result.first.toColumnMap();
      Documentation documentation = Documentation.fromJson(resultMap);
      return documentation;
    });
  }

  // "uuid" text PRIMARY KEY,
  // "name" text,
  // "details" text,
  // "documentation_time" text,
  // "files_uuid" text,
  // "created_at" text,
  // "created_by" text,
  // "updated_at" text
  Future<Documentation> update(dynamic uuid, Documentation object) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"UPDATE documentation SET name = $1, details = $2, documentation_time = $3, files_uuid = $4, created_at = $5, created_by = $6, updated_at = $7 WHERE uuid = $8",parameters: [
        object.name,
        object.details,
        object.documentation_time,
        object.files_uuid,
        object.created_at,
        object.created_by,
        object.updated_at,
        uuid as String
      ]);
      if(result.affectedRows <= 0){
        throw Exception("Data not updated.");
      }
      object.uuid = uuid as String;
      return object;
    });
  }

  Future<Documentation> create(Documentation object) async {
    return this.conn.connectionPool.runTx((tx) async {
      String uuid =  Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO documentation VALUES($1,$2,$3,$4,$5,$6,$7,$8) RETURNING uuid", parameters: [
        object.uuid,
        object.name,
        object.details,
        object.documentation_time,
        object.files_uuid,
        object.created_at,
        object.created_by,
        object.updated_at,
      ]);
      if(result.isEmpty){
        throw Exception("Error Create documentation ${uuid}");
      }
      return object;
    });
  }

  Future<List<Documentation>> readAll() async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM documentation ORDER BY documentation_time DESC");
      List<Documentation> listDocumentation = [];
      for(var item in result){
        var itemDocumentation = Documentation.fromJson(item.toColumnMap());
        listDocumentation.add(itemDocumentation);
      }
      return listDocumentation;
    });
  }

  Future<void> delete(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"DELETE FROM documentation WHERE uuid = $1",parameters: [uuid as String]);
      if(result.affectedRows <= 0){
        throw Exception("Fail to delete documentation ${uuid}");
      }
      return;
    });
  }
}