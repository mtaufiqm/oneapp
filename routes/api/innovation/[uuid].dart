import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/innovation.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/innovation_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    HttpMethod.post => onPost(context,uuid),
    HttpMethod.delete => onDelete(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

//GET DATA
Future<Response> onGet(RequestContext ctx,String uuid) async {
  InnovationRepository innovationRepo = ctx.read<InnovationRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI","GET_INNOVATIONS"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    Innovation innovation = await innovationRepo.getById(uuid);
    return Response.json(body: innovation);
  } catch(e){
    return RespHelper.badRequest(message: "Error Get Data ${uuid}");
  }
}



//UPDATE DATA
Future<Response> onPost(RequestContext ctx,String uuid) async {
  InnovationRepository innovationRepo = ctx.read<InnovationRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","CREATE_INNOVATIONS"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    var jsonBody = await ctx.request.json();
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid Input Innovations ${uuid}");
    }

    String now = DateTime.now().toIso8601String();
    jsonBody["last_updated"] = now;

    var object = Innovation.fromJson(jsonBody);
    var result = await innovationRepo.update(uuid,object);
    return Response.json(body: result);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Failed to Update Innovations ${uuid}");
  }
}

Future<Response> onDelete(RequestContext ctx,String uuid) async{
  InnovationRepository innovationRepo = ctx.read<InnovationRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","DELETE_INNOVATIONS"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    await innovationRepo.delete(uuid);
    return RespHelper.message(message: "success delete innovation${uuid}");
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Failed to Delete innovations ${uuid}");
  }
}
