import 'package:my_first/models/inventories/products.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

class ProductsRepository extends MyRepository<Products>{
  MyConnectionPool conn;

  ProductsRepository(this.conn);

  Future<Products> getById(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM products WHERE uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is No Data wit uuid ${uuid}");
      }
      var resultMap = result.first.toColumnMap();
      Products product = Products.fromMap(resultMap);
      return product;
    });
  }

  Future<Products> update(dynamic uuid, Products object) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"UPDATE products SET name = $1, image_link = $2, unit = $3, stock_quantity = $4, created_at = $5, created_by = $6 WHERE uuid = $7",parameters: [
        object.name,
        object.image_link,
        object.unit,
        object.stock_quantity,
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

  Future<Products> create(Products object) async {
    return this.conn.connectionPool.runTx((tx) async {
      String uuid =  Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO products VALUES($1,$2,$3,$4,$5,$6,$7)", parameters: [
        object.uuid,
        object.name,
        object.image_link,
        object.unit,
        object.stock_quantity,
        object.created_at,
        object.created_by
      ]);
      var result2 = await this.getById(object.uuid);
      return result2;
    });
  }

  Future<List<Products>> readAll() async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM products");
      List<Products> listProducts = [];
      for(var item in result){
        var itemProduct = Products.fromMap(item.toColumnMap());
        listProducts.add(itemProduct);
      }
      return listProducts;
    });
  }

  Future<void> delete(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"DELETE FROM products WHERE uuid = $1",parameters: [uuid as String]);
      if(result.affectedRows <= 0){
        throw Exception("Fail to delete Product ${uuid}");
      }
      return;
    });
  }
}