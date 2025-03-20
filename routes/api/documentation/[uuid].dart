import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/documentation.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/documentation_repository.dart';
import 'package:my_first/repository/files_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    HttpMethod.post => onUpdate(context,uuid),
    HttpMethod.delete => onDelete(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext ctx,String uuid) async {
  DocumentationRepository documenRepo = ctx.read<DocumentationRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","PEGAWAI","GET_DOCUMENTATIONS"])){
    return Response.json(statusCode: HttpStatus.unauthorized,body: {"message":"You Have No Access For This"});
  }
  //AUTHORIZATION

  try{
    Documentation documentation = await documenRepo.getById(uuid);
    return Response.json(body: documentation);
  } catch(e){
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Error Get Data ${uuid}");
  }
}

Future<Response> onUpdate(RequestContext ctx,String uuid) async {
  DocumentationRepository documentationRepo = ctx.read<DocumentationRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","CREATE_DOCUMENTATIONS"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    var jsonBody = await ctx.request.json();
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }

    String now = DateTime.now().toLocal().toIso8601String();
    jsonBody["updated_at"] = now;

    var object = Documentation.fromJson(jsonBody as Map<String,dynamic>);

    var result = await documentationRepo.update(uuid,object);
    return Response.json(body: result);
    
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Update Data ${uuid}");
  }

}


Future<Response> onDelete(RequestContext ctx, String uuid) async{
  DocumentationRepository documentationRepo = ctx.read<DocumentationRepository>();
  FilesRepository filesRepo = ctx.read<FilesRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","DELETE_DOCUMENTATIONS"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    await documentationRepo.delete(uuid);
    return RespHelper.message(message: "Success Delete Documentations ${uuid}");
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Delete Data ${uuid}");
  }

}