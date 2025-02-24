import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/inventories/categories.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/categories_repository.dart';

//
Future<Response> onRequest(RequestContext context) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.message(statusCode: HttpStatus.methodNotAllowed,message: "Method Not Allowed"))
  });
}

Future<Response> onGet(RequestContext con) async {
  CategoriesRepository categoriesRepo = con.read<CategoriesRepository>();

  //AUTHORIZATION
  User user = con.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","PEGAWAI","GET_CATEGORIES"])){
    return Response.json(statusCode: HttpStatus.unauthorized,body: {"message":"You Have No Access For This"});
  }
  //AUTHORIZATION


  try{
    List<Categories> list_object = await categoriesRepo.readAll();
    return Response.json(body: list_object);
  } catch(e){
    print(e);
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Fail To Get All Data");
  }
}

Future<Response> onPost(RequestContext ctx) async {
  CategoriesRepository categoriesRepo = ctx.read<CategoriesRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","CREATE_CATEGORIES"])){
    return Response.json(statusCode: HttpStatus.unauthorized,body: {"message":"You Have No Access For This"});
  }
  //AUTHORIZATION

  try{
    var jsonMap = await ctx.request.json();
    if(!(jsonMap is Map<String,dynamic>)){
      return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Invalid JSON Body");
    }
    Categories categories = Categories.fromJson(jsonMap as Map<String,dynamic>);
    var result = await categoriesRepo.create(categories);
    return Response.json(body: result.toJson());
  } catch(e){
    print(e);
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Error Occured");
  }
}
