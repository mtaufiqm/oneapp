import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/pegawai.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/pegawai_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String username,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,username),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx, String username) async {
  PegawaiRepository pegawaiRepo = ctx.read<PegawaiRepository>();


  try{
    Pegawai pegawaiRequested = await pegawaiRepo.getByUsername(username);

    //AUTHORIZATION
    User user = ctx.read<User>();
    if(!(user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES"]) || user.username == pegawaiRequested.username)){
      return Response.json(statusCode: HttpStatus.unauthorized,body: {"message":"You Have No Access For This"});
    }
    //AUTHORIZATION
    
    return Response.json(body:pegawaiRequested.toJson());
  } catch(e){
    print(e);
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Error Get Data Pegawai with Username ${username}");
  }
}
