import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/inventories/products.dart';
import 'package:my_first/models/inventories/stock_transactions.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/products_repository.dart';
import 'package:my_first/repository/inventories/stock_transaction_repository.dart';
import 'package:my_first/responses/products_available_stocks.dart';

//CONTINUE THIS

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    HttpMethod.post => onPost(context,uuid),
    _ => Future.value(RespHelper.message(statusCode: HttpStatus.methodNotAllowed,message: "Method Not Allowed"))
  });
}

Future<Response> onGet(RequestContext ctx,String uuid) async {
  StockTransactionRepository transactionRepo = ctx.read<StockTransactionRepository>();
  ProductsRepository productRepo = ctx.read<ProductsRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","PEGAWAI","GET_TRANSACTIONS"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    List<StockTransactions> list_object = await transactionRepo.readAll();
    return Response.json(body: list_object);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Fail to Get All Data");
  }

}


//CONTINUE THIS
//UPDATED/APPROVE TRANSACTION
Future<Response> onPost(RequestContext ctx,String uuid) async {
  StockTransactionRepository transactionRepo = ctx.read<StockTransactionRepository>();
  ProductsRepository productRepo = ctx.read<ProductsRepository>();
  try{
    StockTransactions transactions = await transactionRepo.getById(uuid);

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
    StockTransactions inputTransactions = StockTransactions.fromJson(jsonBody);


    if(transactions.status == "COMPLETED" || transactions.status == "CANCELLED"){
      return RespHelper.badRequest(message: "You Cant Update This Transaction ${uuid}. Already Completed");
    }

    //AFTER THIS, ONLY TRANSACTIONS THAT "PENDING"
    //To Complete a Transaction, Only Administrators can do it
    if(inputTransactions == "COMPLETED"){
      if(!(user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES"]))){
        return RespHelper.unauthorized();
      }
    }


    //To Cancel a Transaction, Administrators and User Creator can Cancel it, this already filtered since first filter above this method; 
    StockTransactions result = await transactionRepo.update(uuid,inputTransactions);
    return Response.json(body: result.toJson());
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Fail to Update Transaction Data ${uuid}");
  }
}

//DELETE TRANSACTIONS (ONLY ADMIN OR CREATORS CAN DELETE THIS)
//CANNOT DELETE "COMPLETED" TRANSACTIONS
Future<Response> onDelete(RequestContext ctx, String uuid) async {
  StockTransactionRepository transactionRepo = ctx.read<StockTransactionRepository>();
  ProductsRepository productRepo = ctx.read<ProductsRepository>();

  try{
    StockTransactions transactions = await transactionRepo.getById(uuid);

    //AUTHORIZATION
    User user = ctx.read<User>();
    if(!(user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES"]) || transactions.created_by == user.username)){
      return RespHelper.unauthorized();
    }
    //AUTHORIZATION
    
    if(transactions.status == "COMPLETED" || transactions.status == "PENDING"){
      return RespHelper.badRequest(message: "You Cant Delete This Data ${uuid}");
    }
    await transactionRepo.delete(uuid);

    return Response.json(body: "success");

  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Fail to Delete Transaction Data ${uuid}");
  }
}

var map_status = {
  "PENDING":1,
  "COMPLETED":2
};



