import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_repository.dart';

//api/kegiatan
Future<Response> onRequest(RequestContext context) async {
  return (switch(context.request.method){
    HttpMethod.post => onPost(context),
    _ => Future.value(RespHelper.message(statusCode: HttpStatus.methodNotAllowed,message: "Method Not Allowed"))
  });
}

//CREATE KEGIATAN
Future<Response> onPost(RequestContext context) async {
  try{
    User userAuth = context.read<User>();
    KegiatanRepository kegiatanRepo = context.read<KegiatanRepository>();
    if(!(userAuth.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI","CREATE_KEGIATAN"]))){
      return RespHelper.message(statusCode: HttpStatus.unauthorized,message: "You Are Not Authorized!");
    }
    var jsonBody = await context.request.json();
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Error Payload. Must be Map");
    }
    //create kegiatan from json
    var jsonMap = Kegiatan.from(jsonBody as Map<String,dynamic>);

    //insert to db
    Kegiatan kegiatanModel = await kegiatanRepo.create(jsonMap);

    //return_value
    return Response.json(body: kegiatanModel.toJson());
    
  } catch(e){
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Error Occured");
  }
}
