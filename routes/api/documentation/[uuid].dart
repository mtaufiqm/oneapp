import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/documentation.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/documentation_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
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