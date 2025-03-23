import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/inventories/products.dart';
import 'package:my_first/models/inventories/transactions.dart';
import 'package:my_first/models/inventories/transactions_item.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/products_repository.dart';
import 'package:my_first/repository/inventories/transactions_item_repository.dart';
import 'package:my_first/repository/inventories/transactions_repository.dart';
import 'package:my_first/responses/transactions_with_item.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    HttpMethod.post => onPost(context,uuid),
    HttpMethod.delete => onDelete(context, uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx, String uuid) async {
  TransactionsRepository transactionsRepo = ctx.read<TransactionsRepository>();
  TransactionsItemRepository transactionsItemRepo = ctx.read<TransactionsItemRepository>();
  User authUser = ctx.read<User>();

  try{
    Transactions tx = await transactionsRepo.getById(uuid);
    
    //AUTHORIZATIONS
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES"]) || tx.created_by == authUser.username)){
      return RespHelper.unauthorized();
    }
    //AUTHORIZATIONS

    var txItems = await transactionsItemRepo.readDetailsByTransactionsUuid(tx.uuid);


    //create response
    // {
    //   "transactions":{},
    //   "items":[{transactions_item_1},{transactions_item_2},..]
    // }
    var response = TransactionsWithItem(transactions: tx, items: txItems);

    return Response.json(body: response);

  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Occured");
  }
}

//UPDATE POST
Future<Response> onPost(RequestContext ctx, String uuid) async {
  TransactionsRepository transactionRepo = ctx.read<TransactionsRepository>();
  TransactionsItemRepository transactionsItemRepo = ctx.read<TransactionsItemRepository>();
  ProductsRepository productRepo = ctx.read<ProductsRepository>();
  try{
    Transactions transactions = await transactionRepo.getById(uuid);

    //AUTHORIZATION
    User user = ctx.read<User>();
    if(!(user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES"])  || transactions.created_by == user.username)){
      return RespHelper.unauthorized();
    }
    //AUTHORIZATION


    var jsonBody = await ctx.request.json();
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }

    //CONTINUE VERIFIY STATUS ALLOWED TO APPROVE
    Transactions inputTransactions = Transactions.fromJson(jsonBody);

    if(transactions.status == "COMPLETED" || transactions.status == "CANCELLED"){
      return RespHelper.badRequest(message: "You Cant Update This Transaction ${uuid}. Already Completed");
    }

    //AFTER THIS, ONLY TRANSACTIONS THAT "PENDING"
    //To Complete a Transaction, Only Administrators can do it
    if(inputTransactions.status == "COMPLETED"){
      if(!(user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES"]))){
        return RespHelper.unauthorized();
      }


      //IMPLEMENTATION
      List<TransactionsItem> listItem = await transactionsItemRepo.readByTransactionsUuid(uuid);
      List<Products> needUpdateProducts = [];


      for(var item in listItem){
        Products currentConditionProducts = await productRepo.getById(item.products_uuid);
        if(currentConditionProducts.stock_quantity < item.quantity){
          return RespHelper.badRequest(message: "Products ${item.products_uuid} out of stock");
        }

        //change product quantity;
        currentConditionProducts.stock_quantity = currentConditionProducts.stock_quantity - item.quantity;
        needUpdateProducts.add(currentConditionProducts);
      }

      String now = DateTime.now().toLocal().toIso8601String();
      transactions.last_updated = now;
      transactions.status = "COMPLETED";


      //update transaction, dont forget to update products stock! after update transactions
      var result = await transactionRepo.update(uuid, transactions);

      //update list products
      var result2 = await productRepo.updateList(needUpdateProducts);

      //return completed transactions
      return Response.json(body: transactions);
    }

    //this for cancel transactions
    //all can do it (superadmin,admin,admin_inventories, transactions creator)
    //after this update will execute in db, ensure update the updated_at time
    DateTime currentTime = DateTime.now();
    transactions.last_updated = currentTime.toIso8601String();
    transactions.status = "CANCELLED";

    Transactions result = await transactionRepo.update(uuid,transactions);
    return Response.json(body: result);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Fail to Update Transaction Data ${uuid}");
  }
}


Future<Response> onDelete(RequestContext ctx, String uuid) async {
  TransactionsRepository transactionsRepo = ctx.read<TransactionsRepository>();
  User authUser = ctx.read<User>();

  //AUTHORIZATION
  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES"]))){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    Transactions tx = await transactionsRepo.getById(uuid);
    await transactionsRepo.delete(uuid);
    return Response.json(body: "Success");
  } catch (e){
    print(e);
    return RespHelper.badRequest(message: "Fail To Delete Transactions ${uuid}. Message ${e}");
  }
}
