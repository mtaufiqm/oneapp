import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/products_repository.dart';
import 'package:my_first/responses/products_available_stocks.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx,String uuid) async {
  ProductsRepository productRepo = ctx.read<ProductsRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","PEGAWAI","GET_PRODUCTS"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    ProductsAvailableStocks product = await productRepo.getProductsWithAvailableStock(uuid);
    return Response.json(body: product);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Get Data ${uuid}");
  }
}
