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
    HttpMethod.delete => onDelete(context,uuid),
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
    return Response.json(body: product);
  } catch(e){
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Error Get Data ${uuid}");
  }
}



//UPDATE DATA
Future<Response> onPost(RequestContext ctx,String uuid) async {
  ProductsRepository productRepo = ctx.read<ProductsRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES"])){
    return Response.json(statusCode: HttpStatus.unauthorized,body: {"message":"You Have No Access For This"});
  }
  //AUTHORIZATION

  try{
    var jsonBody = await ctx.request.json();
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Invalid Input Products ${uuid}");
    }
    
    jsonBody["last_updated"] = DateTime.now().toIso8601String();
    var object = Products.fromJson(jsonBody);

    //validate if updated quantity stock less than available stock, it will fail. ensure to cancel pending transaction.
    var pendingStockProduct = await productRepo.getProductStockByStatus(uuid, "PENDING");
    int pending_quantity = pendingStockProduct["status_quantity"] as int;
    if(pending_quantity > object.stock_quantity){
      return RespHelper.badRequest(message: "Input Quantity Less Than Pending Quantity. Ensure to Cancel All Pending Before");
    }
    var result = await productRepo.update(uuid,object);
    return Response.json(body: result);
  } catch(e){
    print(e);
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Failed to Update Products ${uuid}");
  }
}

Future<Response> onDelete(RequestContext ctx,String uuid) async{
  ProductsRepository productRepo = ctx.read<ProductsRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES"])){
    return Response.json(statusCode: HttpStatus.unauthorized,body: {"message":"You Have No Access For This"});
  }
  //AUTHORIZATION

  try{
    await productRepo.delete(uuid);
    return RespHelper.message(message: "success delete ${uuid}");
  } catch(e){
    print(e);
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Failed to Delete Products ${uuid}");
  }
}
