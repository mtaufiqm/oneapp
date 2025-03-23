import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/inventories/stock_transactions.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/stock_transaction_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String username,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,username),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext con,String username) async {
  StockTransactionRepository transactionsRepo = con.read<StockTransactionRepository>();

  //This API for get All Transactions, only Admin can do it. 
  //try access specific username transaction at "api/inventories/transactions/user/[username]"

  //AUTHORIZATION
  User user = con.read<User>();
  if(!(user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES"]) || username == user.username)){
    return Response.json(statusCode: HttpStatus.unauthorized,body: {"message":"You Have No Access For This"});
  }
  //AUTHORIZATION


  try{
    List<StockTransactions> list_object = await transactionsRepo.readByUserCreator(username);
    return Response.json(body: list_object);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Fail to Get All Transactions Data!");
  }
}
