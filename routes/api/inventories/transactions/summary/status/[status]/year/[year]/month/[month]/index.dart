import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/stock_transaction_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String status,
  String year,
  String month,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,status,year,month),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext ctx,String status,String year,String month) async {
  StockTransactionRepository transactionsRepo = ctx.read<StockTransactionRepository>();

  //This API for get All Transactions, only Admin can do it. 
  //try access specific username transaction at "api/inventories/transactions/user/[username]"

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!(user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES"]))){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION


  try{
    List<Map<String,dynamic>> list_object = await transactionsRepo.getSummaryTransactionsByStatusYearMonth(status, year, month);
    return Response.json(body: list_object);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Fail to Get All Transactions Data!");
  }
}
