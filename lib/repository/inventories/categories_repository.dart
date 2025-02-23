import 'package:my_first/models/inventories/categories.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';

class CategoriesRepository extends MyRepository<Categories>{
  MyConnectionPool conn;
  CategoriesRepository(this.conn);

  Future<Categories> getById(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM categories WHERE uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is No Data with uuid ${uuid}");
      }
      var resultMap = result.first.toColumnMap();
      Categories categories = Categories.fromMap(resultMap);
      return categories;
    });
  }

  Future<Categories> update(dynamic uuid, Categories object) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"UPDATE categories SET name = $1 WHERE uuid = $2",parameters: [
        object.name,
        uuid as String
      ]);
      if(result.affectedRows <= 0){
        throw Exception("Data not updated.");
      }
      object.uuid = uuid as String;
      return object;
    });
  }

  Future<Categories> create(Categories object) async {
    return this.conn.connectionPool.runTx((tx) async {
      String uuid =  Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO categories VALUES($1,$2)", parameters: [
        object.uuid,
        object.name,
      ]);
      var result2 = await this.getById(object.uuid);
      return result2;
    });
  }

  Future<List<Categories>> readAll() async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM categories");
      List<Categories> listCategories = [];
      for(var item in result){
        var itemCategories = Categories.fromMap(item.toColumnMap());
        listCategories.add(itemCategories);
      }
      return listCategories;
    });
  }

  Future<void> delete(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"DELETE FROM categories WHERE uuid = $1",parameters: [uuid as String]);
      if(result.affectedRows <= 0){
        throw Exception("Fail to delete Categories ${uuid}");
      }
      return;
    });
  }
}