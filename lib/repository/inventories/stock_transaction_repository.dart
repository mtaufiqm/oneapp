import 'package:my_first/models/inventories/stock_transactions.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';

class StockTransactionRepository extends MyRepository<StockTransactions>{
  MyConnectionPool conn;
  StockTransactionRepository(this.conn);

  Future<StockTransactions> getById(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM stock_transactions WHERE uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is No Data with uuid ${uuid}");
      }
      var resultMap = result.first.toColumnMap();
      StockTransactions stock_transactions = StockTransactions.fromJson(resultMap);
      return stock_transactions;
    });
  }

  Future<StockTransactions> update(dynamic uuid, StockTransactions object) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"UPDATE stock_transactions SET product_uuid = $1, quantity = $2, status = $3, created_at = $4, last_updated = $5,created_by = $6 WHERE uuid = $7",parameters: [
        object.product_uuid,
        object.quantity,
        object.status,
        object.created_at,
        object.last_updated,
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

  Future<StockTransactions> create(StockTransactions object) async {
    return this.conn.connectionPool.runTx((tx) async {
      String uuid =  Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO stock_transactions VALUES($1,$2,$3,$4,$5,$6,$7) RETURNING uuid", parameters: [
        object.uuid,
        object.product_uuid,
        object.quantity,
        object.status,
        object.created_at,
        object.last_updated,
        object.created_by
      ]);
      if(result.isEmpty){
        throw Exception("Error Create Transactions ${object.uuid}");
      }
      return object;
    });
  }

  Future<List<StockTransactions>> readAll() async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM stock_transactions ORDER BY last_updated DESC");
      List<StockTransactions> listTransactions = [];
      for(var item in result){
        var itemTransactions = StockTransactions.fromJson(item.toColumnMap());
        listTransactions.add(itemTransactions);
      }
      return listTransactions;
    });
  }

  Future<List<StockTransactions>> readByUserCreator(dynamic username) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM stock_transactions WHERE created_by = $1 ORDER BY last_updated DESC",parameters: [username as String]);
      List<StockTransactions> listTransactions = [];
      for(var item in result){
        var itemTransactions = StockTransactions.fromJson(item.toColumnMap());
        listTransactions.add(itemTransactions);
      }
      return listTransactions;
    });
  }

  Future<void> delete(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"DELETE FROM stock_transactions WHERE uuid = $1",parameters: [uuid as String]);
      if(result.affectedRows <= 0){
        throw Exception("Fail to delete Stock Transactions ${uuid}");
      }
      return;
    });
  }
}