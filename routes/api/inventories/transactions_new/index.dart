import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/inventories/transactions.dart';
import 'package:my_first/models/inventories/transactions_item.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/products_repository.dart';
import 'package:my_first/repository/inventories/transactions_item_repository.dart';
import 'package:my_first/repository/inventories/transactions_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    HttpMethod.post => onPost(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx) async {
  TransactionsRepository transactionsRepo = ctx.read<TransactionsRepository>();
  User authUser = ctx.read<User>();

  // AUTHORIZATION
  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","GET_TRANSACTIONS"]))){
    return RespHelper.unauthorized();
  }
  // AUTHORIZATION

  try{
    var listObject = await transactionsRepo.readAllWithItemDetails();
    return Response.json(body: listObject);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Occured");
  } 
}


//this will create transactions with at least one transactions_item
//so the request body is List of transactions_item, with default transactions status is PENDING
Future<Response> onPost(RequestContext ctx) async {
  TransactionsRepository transactionsRepo = ctx.read<TransactionsRepository>();
  TransactionsItemRepository transactionsItemRepo = ctx.read<TransactionsItemRepository>();
  ProductsRepository productsRepo = ctx.read<ProductsRepository>();
  User authUser = ctx.read<User>();

  //AUTHORIZATIONS
  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI","POST_TRANSACTIONS"]))){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATIONS

  try{
    var jsonBody = await ctx.request.json();
    if(!(jsonBody is List<dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }
    var jsonObject = (jsonBody as List);

    //ensure at least there is minimal one transactions_item
    if(jsonObject.isEmpty){
      return RespHelper.badRequest(message: "List Body Cannot be Empty");
    }
    List<TransactionsItem> listTx = [];

    //check each item valid or not, if not throw Exceptions
    for(var item in jsonObject){
      if(!(item is Map<String,dynamic>)){
        return RespHelper.badRequest(message: "Invalid JSON Body");
      }
      item["transactions_uuid"] = "";
      TransactionsItem trItem = TransactionsItem.fromJson(item as Map<String,dynamic>);

      //Validate if there is duplicate products in same transactions
      var result = listTx.where((el) => el.products_uuid == trItem.products_uuid).toList();
      if(!result.isEmpty){
        //if there, sum it;
        result.first.quantity = result.first.quantity + trItem.quantity;
        continue;
      }
      listTx.add(trItem);
    }

    //check availability stock (quantity) each products
    for(var item in listTx){
      if(item.quantity <= 0){
        return RespHelper.badRequest(message: "Quantity Cannot Less Than or Equals to 0!");
      }
      var products = await productsRepo.getProductsWithAvailableStockNew(item.products_uuid);
      if(products.stock_quantity < item.quantity){
        return RespHelper.badRequest(message: "Requested Quantity Less Than Available Quantity ${products.uuid}");
      }
    }
    
    var now = DateTime.now().toLocal().toIso8601String();

    //if all validation has passed, insert it
    Transactions transactions = Transactions(
      status: "PENDING", 
      created_at: now, 
      created_by: authUser.username, 
      last_updated: now
    );
    var result = await transactionsRepo.createWithItem(transactions, listTx);
    return Response.json(
      body: listTx
    );
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Occured ${e}");
  }

}
