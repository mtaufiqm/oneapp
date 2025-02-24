import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/inventories/products.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/products_repository.dart';


//GET ALL PRODUCTS
//OR
//CREATE PRODUCTS
Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    HttpMethod.post => onPost(context),
    _ => Future.value(RespHelper.message(statusCode: HttpStatus.methodNotAllowed,message: "Method Not Allowed"))
  });
}

Future<Response> onGet(RequestContext con) async {
  ProductsRepository productRepo = con.read<ProductsRepository>();

  //AUTHORIZATION
  User user = con.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","PEGAWAI","GET_PRODUCTS"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION


  try{
    List<Products> list_object = await productRepo.readAll();
    return Response.json(body: list_object);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Fail to Get All Data");
  }
}

Future<Response> onPost(RequestContext ctx) async {
  ProductsRepository productsRepo = ctx.read<ProductsRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","CREATE_PRODUCTS"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    var jsonMap = await ctx.request.json();
    if(!(jsonMap is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }
    
    jsonMap["created_at"] = DateTime.now().toIso8601String();
    jsonMap["created_by"] = user.username;

    Products products = Products.fromJson(jsonMap as Map<String,dynamic>);
    var result = await productsRepo.create(products);
    return Response.json(body: result);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Occured");
  }
}
