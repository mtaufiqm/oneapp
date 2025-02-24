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
//UPDATED BY
Future<Response> onPost(RequestContext ctx,String uuid) async {
  StockTransactionRepository transactionRepo = ctx.read<StockTransactionRepository>();
  ProductsRepository productRepo = ctx.read<ProductsRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","PEGAWAI","POST_TRANSACTIONS"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION
  return Response.json();

}

//DELETE TRANSACTIONS (ONLY ADMIN OR CREATORS CAN DELETE THIS)
Future<Response> onDelete(RequestContext ctx, String uuid) async {
  StockTransactionRepository transactionRepo = ctx.read<StockTransactionRepository>();
  ProductsRepository productRepo = ctx.read<ProductsRepository>();

  try{
    StockTransactions transactions = await transactionRepo.getById(uuid);

    //AUTHORIZATION
    User user = ctx.read<User>();
    if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES"]) || transactions.created_by != user.username){
      return RespHelper.unauthorized();
    }
    //AUTHORIZATION
    
    if(transactions.status == "COMPLETED"){
      return RespHelper.badRequest(message: "You Cant Delete This Data ${uuid}");
    }
    await transactionRepo.delete(uuid);
    return Response.json(body: "success");
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Fail to Delete Transaction Data ${uuid}");
  }



}



