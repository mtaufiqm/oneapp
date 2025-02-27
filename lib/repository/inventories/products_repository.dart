import 'package:my_first/models/inventories/products.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:my_first/responses/products_available_stocks.dart';
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
      Products product = Products.fromJson(resultMap);
      return product;
    });
  }

  Future<Products> update(dynamic uuid, Products object) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"UPDATE products SET name = $1, image_link = $2, unit = $3, stock_quantity = $4, created_at = $5, created_by = $6, last_updated = $7  WHERE uuid = $8",parameters: [
        object.name,
        object.image_link,
        object.unit,
        object.stock_quantity,
        object.created_at,
        object.created_by,
        object.last_updated,
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
      var result = await tx.execute(r"INSERT INTO products VALUES($1,$2,$3,$4,$5,$6,$7,$8) RETURNING uuid", parameters: [
        object.uuid,
        object.name,
        object.image_link,
        object.unit,
        object.stock_quantity,
        object.created_at,
        object.created_by,
        object.last_updated
      ]);
      if(result.isEmpty){
        throw Exception("Error Create Products ${object.uuid}");
      }
      return object;
    });
  }

  Future<List<Products>> readAll() async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM products");
      List<Products> listProducts = [];
      for(var item in result){
        var itemProduct = Products.fromJson(item.toColumnMap());
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


  Future<List<ProductsAvailableStocks>> getAllProductsWithAvailableStock() async{
    return await this.conn.connectionPool.runTx<List<ProductsAvailableStocks>>((tx) async {
      List<ProductsAvailableStocks> listOfObject = [];
      var result = await tx.execute(r"""
          SELECT 
              p.uuid as uuid, 
              p.name as name, 
              p.image_link as image_link,
              p.unit as unit,
              p.stock_quantity  - COALESCE(SUM(o.quantity), 0) AS stock_quantity,
              p.created_at as created_at,
              p.created_by as created_by,
              p.last_updated as last_updated
          FROM products p
          LEFT JOIN stock_transactions o ON p.uuid = o.product_uuid AND o.status = 'PENDING'
          group by p."uuid"
      """
      );
      for(var item in result){
        ProductsAvailableStocks product = ProductsAvailableStocks.fromJson(item.toColumnMap());
        listOfObject.add(product);
      }
      return listOfObject;
    });
  }

  Future<ProductsAvailableStocks> getProductsWithAvailableStock(dynamic uuid) async {
    return await this.conn.connectionPool.runTx<ProductsAvailableStocks>((tx) async {
      List<ProductsAvailableStocks> listOfObject = [];
      var result = await tx.execute(r"""
        SELECT * FROM (
          SELECT 
              p.uuid as uuid, 
              p.name as name, 
              p.image_link as image_link,
              p.unit as unit,
              p.stock_quantity  - COALESCE(SUM(o.quantity), 0) AS stock_quantity,
              p.created_at as created_at,
              p.created_by as created_by,
              p.last_updated as last_updated
          FROM products p
          LEFT JOIN stock_transactions o ON p.uuid = o.product_uuid AND o.status = 'PENDING' AND p.uuid = $1
          group by p.uuid
        ) as query1 WHERE uuid = $1
      """,parameters: [uuid as String]
      );
      if(result.isEmpty){
        throw Exception("No Products With ${uuid as String}");
      }
      var product = ProductsAvailableStocks.fromJson(result.first.toColumnMap());
      return product;
    });
  }
}