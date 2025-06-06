import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/inventories/products.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/products_repository.dart';
import 'package:my_first/responses/products_available_stocks.dart';

Future<Response> onRequest(RequestContext context) async {
  return(switch(context.request.method){
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.message(statusCode: HttpStatus.methodNotAllowed,message: "Method Not Allowed"))
  });
}


Future<Response> onGet(RequestContext ctx) async {
  ProductsRepository productRepo = ctx.read<ProductsRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","PEGAWAI","GET_PRODUCTS"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION


  try{
    List<ProductsAvailableStocks> list_object = await productRepo.getAllProductsWithAvailableStock();
    return Response.json(body: list_object);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Fail to Get All Data");
  }
}
