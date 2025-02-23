import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/inventories/products.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/products_repository.dart';


//GET PRODUCTS
Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    HttpMethod.post => onPost(context,uuid),
    _ => Future.value(RespHelper.message(statusCode: HttpStatus.methodNotAllowed,message: "Method Not Allowed"))
  });
}

//GET DATA
Future<Response> onGet(RequestContext ctx,String uuid) async {
  ProductsRepository productRepo = ctx.read<ProductsRepository>();
    //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","PEGAWAI","GET_PRODUCTS"])){
    return Response.json(statusCode: HttpStatus.unauthorized,body: {"message":"You Have No Access For This"});
  }
  //AUTHORIZATION

  try{
    Products product = await productRepo.getById(uuid);
    return Response.json(body: product.toJson());
  } catch(e){
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Error Get Data ${uuid}");
  }
}


//UPDATE DATA
Future<Response> onPost(RequestContext ctx,String uuid) async {
  return Response.json();
}
