import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/inventories/categories.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/categories_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    HttpMethod.post => onPost(context,uuid),
    HttpMethod.delete => onDelete(context, uuid),
    _ => Future.value(RespHelper.message(statusCode: HttpStatus.methodNotAllowed,message: "Method Not Allowed"))
  });
}

//GET DATA
Future<Response> onGet(RequestContext ctx,String uuid) async {
  CategoriesRepository categoriesRepo = ctx.read<CategoriesRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","PEGAWAI","GET_CATEGORIES"])){
    return Response.json(statusCode: HttpStatus.unauthorized,body: {"message":"You Have No Access For This"});
  }
  //AUTHORIZATION

  try{
    Categories categories = await categoriesRepo.getById(uuid);
    return Response.json(body: categories);
  } catch(e){
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Error Get Data ${uuid}");
  }
}



//UPDATE DATA
Future<Response> onPost(RequestContext ctx,String uuid) async {
  CategoriesRepository categoriesRepo = ctx.read<CategoriesRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","POST_REPOSITORIES"])){
    return Response.json(statusCode: HttpStatus.unauthorized,body: {"message":"You Have No Access For This"});
  }
  //AUTHORIZATION

  try{
    var jsonBody = await ctx.request.json();
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Invalid Input Categories ${uuid}");
    }
    var object = Categories.fromJson(jsonBody);
    var result = await categoriesRepo.update(uuid,object);
    return Response.json(body: result);
  } catch(e){
    print(e);
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Failed to Update Products ${uuid}");
  }
}

Future<Response> onDelete(RequestContext ctx,String uuid) async{
  CategoriesRepository categoriesRepo = ctx.read<CategoriesRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES"])){
    return Response.json(statusCode: HttpStatus.unauthorized,body: {"message":"You Have No Access For This"});
  }
  //AUTHORIZATION

  try{
    await categoriesRepo.delete(uuid);
    return RespHelper.message(message: "success delete ${uuid}");
  } catch(e){
    print(e);
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Failed to Delete Categories ${uuid}");
  }
}

