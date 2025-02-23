import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/mitra_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String mitraId,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,mitraId),
    HttpMethod.post => onPost(context, mitraId),
    _ => Future.value(RespHelper.message(statusCode: HttpStatus.methodNotAllowed))
  });
}


Future<Response> onGet(RequestContext context,String mitraId) async {
  User userAuth = context.read<User>();
  MitraRepository mitraRepo = context.read<MitraRepository>();

  //authorization
  //For Now, Mitra cannot view his details
  if(!userAuth.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI","VIEW_MITRA"])){
    return RespHelper.message(statusCode: HttpStatus.unauthorized,message:"You are Not Allowed");
  }
  //=============================

  try{
    var result = await mitraRepo.getById(mitraId);
    return Response.json(body: result.toJson());
  } catch(e){
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "There is no Certain Data For Mitra Id ${mitraId}");
  }
}


//CONTINUE THIS
//UPDATE DATA
Future<Response> onPost(RequestContext context,String mitraId) async {
  User userAuth = context.read<User>();
  MitraRepository mitraRepo = context.read<MitraRepository>();
  //authorization
  //For Now, Mitra cannot view his details
  if(!userAuth.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI","UPDATE_MITRA"])){
    return RespHelper.message(statusCode: HttpStatus.unauthorized,message:"You are Not Allowed");
  }
  //=============================

  return Response.json();


}
