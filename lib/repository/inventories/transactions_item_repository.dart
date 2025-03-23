import 'package:my_first/models/inventories/transactions_item.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';

class TransactionsItemRepository extends MyRepository<TransactionsItem> {
  MyConnectionPool conn;

  TransactionsItemRepository(this.conn);

  Future<TransactionsItem> getById(dynamic uuid) async {
  return this.conn.connectionPool.runTx((tx) async {
    var result = await tx.execute(r"SELECT * FROM transactions_item WHERE uuid = $1",parameters: [uuid as String]);
    if(result.isEmpty){
      throw Exception("There is No Data with uuid ${uuid}");
    }
    var resultMap = result.first.toColumnMap();
    TransactionsItem transactionsItem = TransactionsItem.fromJson(resultMap);
    return transactionsItem;
  });
}

  Future<TransactionsItem> update(dynamic uuid, TransactionsItem object) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"UPDATE transactions_item SET transactions_uuid = $1, products_uuid = $2, quantity = $3 WHERE uuid = $5",parameters: [
        object.transactions_uuid,
        object.products_uuid,
        object.quantity,
        uuid as String
      ]);
      if(result.affectedRows <= 0){
        throw Exception("Data not updated.");
      }
      object.uuid = uuid as String;
      return object;
    });
  }

  Future<TransactionsItem> create(TransactionsItem object) async {
    return this.conn.connectionPool.runTx((tx) async {
      String uuid =  Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO transactions_item VALUES($1,$2,$3,$4) RETURNING uuid", parameters: [
        object.uuid,
        object.transactions_uuid,
        object.products_uuid,
        object.quantity
      ]);
      if(result.isEmpty){
        throw Exception("Error Create Transactions Item ${object.uuid}");
      }
      return object;
    });
  }

  Future<List<TransactionsItem>> readAll() async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM transactions_item");
      List<TransactionsItem> listTransactionsItem = [];
      for(var item in result){
        var objectTransactionsItem = TransactionsItem.fromJson(item.toColumnMap());
        listTransactionsItem.add(objectTransactionsItem);
      }
      return listTransactionsItem;
    });
  }

    Future<List<TransactionsItem>> readByTransactionsUuid(dynamic transUuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM transactions_item WHERE transactions_uuid = $1",
      parameters: [transUuid as String]);
      List<TransactionsItem> listTransactionsItem = [];
      for(var item in result){
        var objectTransactionsItem = TransactionsItem.fromJson(item.toColumnMap());
        listTransactionsItem.add(objectTransactionsItem);
      }
      return listTransactionsItem;
    });
  }


  Future<List<TransactionsItemDetails>> readDetailsByTransactionsUuid(dynamic transUuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT ti.uuid, ti.transactions_uuid, ti.products_uuid, ti.quantity, p.name AS products_name, p.image_link AS products_image_link, p.unit AS products_unit FROM transactions_item ti LEFT JOIN products p ON ti.products_uuid = p.uuid WHERE transactions_uuid = $1",
      parameters: [transUuid as String]);
      List<TransactionsItemDetails> listTransactionsItemDetails = [];
      for(var item in result){
        var objectTransactionsItem = TransactionsItemDetails.fromJson(item.toColumnMap());
        listTransactionsItemDetails.add(objectTransactionsItem);
      }
      return listTransactionsItemDetails;
    });
  }

  Future<void> delete(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"DELETE FROM transactions_item WHERE uuid = $1",parameters: [uuid as String]);
      if(result.affectedRows <= 0){
        throw Exception("Fail to delete Transactions Item ${uuid}");
      }
      return;
    });
  }


  Future<List<TransactionsItem>> createList(List<TransactionsItem> listObject) async {
    return await this.conn.connectionPool.runTx<List<TransactionsItem>>((tx) async {
      List<TransactionsItem> returnValue = [];
      for(var item in listObject){
        var uuid = Uuid().v1();
        item.uuid = uuid;
        var result = await tx.execute(r"INSERT INTO transactions_item VALUES($1,$2,$3,$4) RETURNING uuid",
        parameters: [
          item.uuid,
          item.transactions_uuid,
          item.products_uuid,
          item.quantity
        ]
        );
      }
      return returnValue;
    });
  }
}