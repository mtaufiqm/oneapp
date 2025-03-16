import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/inventories/products.dart';
import 'package:my_first/models/inventories/stock_transactions.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/products_repository.dart';
import 'package:my_first/repository/inventories/stock_transaction_repository.dart';
import 'package:my_first/responses/products_available_stocks.dart';
import 'package:timezone/standalone.dart' as tz;

Future<Response> onRequest(RequestContext context) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    HttpMethod.post => onPost(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext con) async {
  StockTransactionRepository transactionsRepo = con.read<StockTransactionRepository>();

  //This API for get All Transactions, only Admin can do it. 
  //try access specific username transaction at "api/inventories/transactions/user/[username]"

  //AUTHORIZATION
  User user = con.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES"])){
    return Response.json(statusCode: HttpStatus.unauthorized,body: {"message":"You Have No Access For This"});
  }
  //AUTHORIZATION


  try{
    List<StockTransactions> list_object = await transactionsRepo.readAll();
    return Response.json(body: list_object);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Fail to Get All Transactions Data!");
  }
}

Future<Response> onPost(RequestContext ctx) async {
  StockTransactionRepository transactionRepo = ctx.read<StockTransactionRepository>();
  ProductsRepository productRepo = ctx.read<ProductsRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","PEGAWAI","POST_TRANSACTIONS"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    var jsonMap = await ctx.request.json();
    if(!(jsonMap is Map<String,dynamic>)){
      return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Invalid JSON Body");
    }
    DateTime currentTime = DateTime.now();
    String now = currentTime.toIso8601String();

    //at first, transactions status must be "PENDING"
    jsonMap["status"] = "PENDING";
    
    jsonMap["created_at"] = now;
    jsonMap["last_updated"] = now;
    jsonMap["created_by"] = user.username;
    StockTransactions transactions = StockTransactions.fromJson(jsonMap as Map<String,dynamic>);

    String product_uuid = transactions.product_uuid;
    int product_stock_requested = transactions.quantity;

    //db products state;
    Products products = await productRepo.getById(product_uuid);

    //get db product with quantity is available product (stoc - pending)
    ProductsAvailableStocks productAvailable = await productRepo.getProductsWithAvailableStock(product_uuid);

    //validate
    if(transactions.quantity <= 0){
      return RespHelper.badRequest(message: "Anda tidak bisa melakukan Order dengan jumlah 0!");
    }

    if(products.stock_quantity <= 0){
      return RespHelper.badRequest(message: "Stock Habis!");
    }

    if((productAvailable.stock_quantity - transactions.quantity) < 0){
      return RespHelper.badRequest(message: "Stock Tidak Cukup!");
    }

    var result = await transactionRepo.create(transactions);
    return Response.json(body: result);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Occured");
  }
}
