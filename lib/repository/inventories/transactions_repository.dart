import 'package:my_first/models/inventories/transactions.dart';
import 'package:my_first/models/inventories/transactions_item.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';

class TransactionsRepository extends MyRepository<Transactions>{
  MyConnectionPool conn;

  TransactionsRepository(this.conn);

  Future<Transactions> getById(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM transactions WHERE uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is No Data with uuid ${uuid}");
      }
      var resultMap = result.first.toColumnMap();
      Transactions transactions = Transactions.fromJson(resultMap);
      return transactions;
    });
  }

  Future<Transactions> update(dynamic uuid, Transactions object) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"UPDATE transactions SET status = $1, created_at = $2, created_by = $3, last_updated = $4 WHERE uuid = $5",parameters: [
        object.status,
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

  Future<Transactions> create(Transactions object) async {
    return this.conn.connectionPool.runTx((tx) async {
      String uuid =  Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO transactions VALUES($1,$2,$3,$4,$5) RETURNING uuid", parameters: [
        object.uuid,
        object.status,
        object.created_at,
        object.created_by,
        object.last_updated
      ]);
      if(result.isEmpty){
        throw Exception("Error Create Transactions ${object.uuid}");
      }
      return object;
    });
  }

  Future<Transactions> createWithItem(Transactions object,List<TransactionsItem> listObjectItem) async {
    return this.conn.connectionPool.runTx<Transactions>((tx) async {
      var objUUID = Uuid().v1();
      object.uuid = objUUID;
      var result = await tx.execute(r"INSERT INTO transactions VALUES($1,$2,$3,$4,$5) RETURNING uuid", parameters: [
        object.uuid,
        object.status,
        object.created_at,
        object.created_by,
        object.last_updated
      ]);
      if(result.isEmpty){
        throw Exception("Error Create Transactions ${object.uuid}");
      }
      for(var item in listObjectItem){
        String itemUUID = Uuid().v1();
        item.uuid = itemUUID;
        item.transactions_uuid = object.uuid!;
        var resultItem = await tx.execute(r"INSERT INTO transactions_item VALUES($1,$2,$3,$4) RETURNING uuid",parameters: [
          item.uuid,
          item.transactions_uuid,
          item.products_uuid,
          item.quantity
        ]);
      }
      return object;
    });
  }

  Future<List<Transactions>> readAll() async {
    return this.conn.connectionPool.runTx<List<Transactions>>((tx) async {
      var result = await tx.execute(r"SELECT * FROM transactions ORDER BY last_updated DESC");
      List<Transactions> listTransactions = [];
      for(var item in result){
        var objectTransactions = Transactions.fromJson(item.toColumnMap());
        listTransactions.add(objectTransactions);
      }
      return listTransactions;
    });
  }

  Future<List<Transactions>> readByUserCreator(dynamic username) async {
    return this.conn.connectionPool.runTx<List<Transactions>>((tx) async {
      var result = await tx.execute(r"SELECT * FROM transactions WHERE created_by = $1 ORDER BY last_updated DESC",parameters: [username as String]);
      List<Transactions> listTransactions = [];
      for(var item in result){
        var objectTransactions = Transactions.fromJson(item.toColumnMap());
        listTransactions.add(objectTransactions);
      }
      return listTransactions;
    });
  }

  Future<void> delete(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result1 = await tx.execute(r"DELETE FROM transactions_item where transactions_uuid = $1",parameters: [uuid as String]);
      var result = await tx.execute(r"DELETE FROM transactions WHERE uuid = $1",parameters: [uuid as String]);
      if(result.affectedRows <= 0){
        throw Exception("Fail to delete Transactions ${uuid}");
      }
      return;
    });
  }
}