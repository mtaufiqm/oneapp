import 'package:my_first/models/inventories/products.dart';
import 'package:my_first/models/inventories/transactions_item.dart';
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

  Future<List<Products>> updateList(List<Products> listItem) async {
    return await this.conn.connectionPool.runTx<List<Products>>((tx) async {
      for(var item in listItem){
        var result = await tx.execute(r"UPDATE products SET name = $1, image_link = $2, unit = $3, stock_quantity = $4, created_at = $5, created_by = $6, last_updated = $7  WHERE uuid = $8",parameters: [
          item.name,
          item.image_link,
          item.unit,
          item.stock_quantity,
          item.created_at,
          item.created_by,
          item.last_updated,
          item.uuid as String
        ]);
        if(result.affectedRows <= 0){
          throw Exception("Data not updated.");
        }        
      }
      return listItem;
    });
  }

  Future<Products> create(Products object) async {
    return this.conn.connectionPool.runTx<Products>((tx) async {
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
    return this.conn.connectionPool.runTx<List<Products>>((tx) async {
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

  Future<Map<String,dynamic>> getProductStockByStatus(dynamic uuid,dynamic status) async {
    return await this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"""
                      SELECT 
                          p.uuid as uuid, 
                          p.name as name, 
                          p.image_link as image_link,
                          p.unit as unit,
                          COALESCE(SUM(o.quantity), 0) AS status_quantity,
                          p.created_at as created_at,
                          p.created_by as created_by,
                          p.last_updated as last_updated
                      FROM products p
                      LEFT JOIN stock_transactions o ON p.uuid = o.product_uuid AND o.status = $1 WHERE p.uuid = $2
                      group by p.uuid
      """,parameters: [
        status as String,
        uuid as String
        ]);
        if(result.isEmpty){
          throw Exception("There is no Certain Data ${uuid}");
        }
        return result.first.toColumnMap();
    });
  }

//====================================================== THIS FOR NEW TRANSACTIONS =============================================//
//========================================== FOR COMPATIBILITY REASON, OLD TRANSACTIONS NOT DELETED ============================//

  //FOR NEW TRANSACTIONS
  Future<List<ProductsAvailableStocks>> getAllProductsWithAvailableStockNew() async{
    return await this.conn.connectionPool.runTx<List<ProductsAvailableStocks>>((tx) async {
      List<ProductsAvailableStocks> listOfObject = [];
      var result = await tx.execute(r"""
        SELECT      
              p.uuid AS uuid, 
              p.name AS name, 
              p.image_link AS image_link,
              p.unit AS unit,
              p.stock_quantity  - COALESCE(query1.quantity, 0) AS stock_quantity,
              p.created_at AS created_at,
              p.created_by AS created_by,
              p.last_updated AS last_updated
        FROM products p LEFT JOIN (SELECT transactions_item.products_uuid,SUM(transactions_item.quantity) AS quantity FROM transactions LEFT JOIN transactions_item ON transactions.uuid = transactions_item.transactions_uuid WHERE transactions.status = 'PENDING' GROUP BY transactions_item.products_uuid) AS query1 ON p.uuid = query1.products_uuid
      """
      );
      for(var item in result){
        ProductsAvailableStocks product = ProductsAvailableStocks.fromJson(item.toColumnMap());
        listOfObject.add(product);
      }
      return listOfObject;
    });
  }

  //FOR NEW TRANSACTIONS
  Future<ProductsAvailableStocks> getProductsWithAvailableStockNew(dynamic uuid) async {
    return await this.conn.connectionPool.runTx<ProductsAvailableStocks>((tx) async {
      List<ProductsAvailableStocks> listOfObject = [];
      var result = await tx.execute(r"""
        SELECT      
              p.uuid AS uuid, 
              p.name AS name, 
              p.image_link AS image_link,
              p.unit AS unit,
              p.stock_quantity  - COALESCE(query1.quantity, 0) AS stock_quantity,
              p.created_at AS created_at,
              p.created_by AS created_by,
              p.last_updated AS last_updated
        FROM products p LEFT JOIN (SELECT transactions_item.products_uuid,SUM(transactions_item.quantity) AS quantity FROM transactions LEFT JOIN transactions_item ON transactions.uuid = transactions_item.transactions_uuid WHERE transactions.status = 'PENDING' GROUP BY transactions_item.products_uuid) AS query1 ON p.uuid = query1.products_uuid WHERE p.uuid = $1
      """,parameters: [uuid as String]
      );
      if(result.isEmpty){
        throw Exception("No Products With ${uuid as String}");
      }
      var product = ProductsAvailableStocks.fromJson(result.first.toColumnMap());
      return product;
    });
  }

  Future<Map<String,dynamic>> getProductStockByStatusNew(dynamic uuid,dynamic status) async {
    return await this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"""
        SELECT      
              p.uuid AS uuid, 
              p.name AS name, 
              p.image_link AS image_link,
              p.unit AS unit,
              COALESCE(query1.quantity, 0) AS status_quantity,
              p.created_at AS created_at,
              p.created_by AS created_by,
              p.last_updated AS last_updated
        FROM products p LEFT JOIN (SELECT transactions_item.products_uuid,SUM(transactions_item.quantity) AS quantity FROM transactions LEFT JOIN transactions_item ON transactions.uuid = transactions_item.transactions_uuid WHERE transactions.status = $1 GROUP BY transactions_item.products_uuid) AS query1 ON p.uuid = query1.products_uuid WHERE p.uuid = $2
      """, parameters: [
        status as String,
        uuid as String
        ]
      );
        if(result.isEmpty){
          throw Exception("There is no Certain Data ${uuid}");
        }
        return result.first.toColumnMap();
    });
  }
}