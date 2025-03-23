import 'package:my_first/models/inventories/transactions.dart';
import 'package:my_first/models/inventories/transactions_item.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:my_first/responses/transactions_with_item.dart';
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



  //Class TransactionsItemDetails (Transactions With Products)
  // String? uuid;
  // String transactions_uuid;
  // String products_uuid;
  // int quantity;

  // //details_products
  // String products_name;
  // String products_image_link;
  // String products_unit;

  Future<List<TransactionsWithItem>> readAllWithItemDetails([int limit = 100,int page = 0]) async {
    return this.conn.connectionPool.runTx<List<TransactionsWithItem>>((tx) async {
      var result = await tx.execute(r"SELECT * FROM transactions ORDER BY last_updated DESC LIMIT $1 OFFSET $2",parameters: [
        limit,
        page*limit
      ]);

      var itemsResult = await tx.execute(r"SELECT ti.uuid, ti.transactions_uuid, ti.products_uuid, ti.quantity, p.name AS products_name, p.image_link AS products_image_link, p.unit AS products_unit FROM transactions_item ti LEFT JOIN products p ON ti.products_uuid = p.uuid WHERE transactions_uuid in (SELECT uuid FROM transactions LIMIT $1 OFFSET $2) ",parameters: [limit,page*limit]);
      List<TransactionsWithItem> listTransactionsWithItem = [];
      Map<String,TransactionsWithItem> mapResult = {};

      //this will iterate transactions result and add transactions to mapResult
      for(var item in result){
        try{
          var objItem = Transactions.fromJson(item.toColumnMap());
          mapResult[objItem.uuid!] = TransactionsWithItem(transactions: objItem, items: []);
        } catch(e){
          print(e);
        }
      }

      //this will fill item in each TransactionsWithItem
      for(var item in itemsResult){
        try{
          var objItem = TransactionsItemDetails.fromJson(item.toColumnMap());
          if(!mapResult.containsKey(objItem.transactions_uuid)){
            continue;
          }
          mapResult[objItem.transactions_uuid]!.items.add(objItem);
        } catch(e){
          print(e);
        }
      }
      return mapResult.values.toList();

    });
  }

  Future<List<TransactionsWithItem>> readWithItemDetailsByUserCreator(dynamic username, [int limit = 100,int page = 0]) async {
    return this.conn.connectionPool.runTx<List<TransactionsWithItem>>((tx) async {
      var result = await tx.execute(r"SELECT * FROM transactions WHERE created_by = $1 ORDER BY last_updated DESC LIMIT $2 OFFSET $3",parameters: [
        username as String,
        limit,
        page*limit
      ]);
      var itemsResult = await tx.execute(r"SELECT ti.uuid, ti.transactions_uuid, ti.products_uuid, ti.quantity, p.name AS products_name, p.image_link AS products_image_link, p.unit AS products_unit FROM transactions t left join transactions_item ti on t.uuid = ti.transactions_uuid LEFT JOIN products p ON ti.products_uuid = p.uuid WHERE t.created_by = $1 LIMIT $2 OFFSET $3",parameters: [username as String,limit,page*limit]);
      List<TransactionsWithItem> listTransactionsWithItem = [];
      Map<String,TransactionsWithItem> mapResult = {};

      //this will iterate transactions result and add transactions to mapResult
      for(var item in result){
        try{
          var objItem = Transactions.fromJson(item.toColumnMap());
          mapResult[objItem.uuid!] = TransactionsWithItem(transactions: objItem, items: []);
        } catch(e){
          print(e);
        }
      }

      //this will fill item in each TransactionsWithItem
      for(var item in itemsResult){
        try{
          var objItem = TransactionsItemDetails.fromJson(item.toColumnMap());
          if(!mapResult.containsKey(objItem.transactions_uuid)){
            continue;
          }
          mapResult[objItem.transactions_uuid]!.items.add(objItem);
        } catch(e){
          print(e);
        }
      }
      return mapResult.values.toList();
    });
  }


  //this will delete related transactions_item first, after that delete the transactions
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


  Future<List<Map<String,dynamic>>> getSummaryTransactionsByStatusYearMonth(dynamic status, dynamic year,dynamic month) async {
    List<Map<String,dynamic>> returnValue = [];
    await this.conn.connectionPool.runTx<void>((tx) async {

      //month in String format (2 characters like '03' or '12')
      //year in String format (4 characters like '2025' or '2020')
      var summary = await tx.execute(r"select products.uuid,products.name,count(query1.transactions_uuid) as transactions_q,coalesce(sum(query1.quantity),0) as quantity_q from products left join (SELECT * from (SELECT transactions_uuid,status,products_uuid,quantity, substring(last_updated,6,2) as month, substring(last_updated,1,4) as year FROM transactions left join transactions_item on transactions.uuid = transactions_item.transactions_uuid) as query2 where status = $1 and month = $2 and year = $3) as query1 on products.uuid = query1.products_uuid group by (products.name,products.uuid) order by transactions_q desc,quantity_q desc",parameters: [
        status as String,
        month as String,
        year as String
      ]); 
      if(summary.isEmpty){
      }
      for(var item in summary){
        returnValue.add(item.toColumnMap());
      }
    });
    return returnValue;
  }

}