import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_repository.dart';



//api/kegiatan/[kegiatanId]
Future<Response> onRequest(
  RequestContext context,
  String kegiatanId,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,kegiatanId),
    HttpMethod.post => onPost(context,kegiatanId),
    _ => Future.value(RespHelper.message(statusCode: HttpStatus.methodNotAllowed,message: "Method Not Allowed"))
  });
  
}

//VIEW KEGIATAN
Future<Response> onGet(RequestContext context,String kegiatanId) async {
  User userAuth = context.read<User>();
  KegiatanRepository kegiatanRepository = context.read<KegiatanRepository>();

  if(!userAuth.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI","VIEW_KEGIATAN"])){
    return RespHelper.message(statusCode: HttpStatus.unauthorized,message: "You Are Not Authorized");
  }
  try{
    Kegiatan kegiatan = await kegiatanRepository.getById(kegiatanId);
    return Response.json(body: kegiatan.toJson());
  } catch(e){
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "There is no certain data");
  }
}

//UPDATE KEGIATAN
Future<Response> onPost(RequestContext context,String kegiatanId) async {
  User userAuth = context.read<User>();
  KegiatanRepository kegiatanRepository = context.read<KegiatanRepository>();
  try{
    //check existence and authoriztion
    Kegiatan kegiatan = await kegiatanRepository.getById(kegiatanId);
    if(!userAuth.isContainOne(["SUPERADMIN","ADMIN","EDIT_KEGIATAN"]) || (userAuth.username != kegiatan.createdby)){
      return RespHelper.message(statusCode: HttpStatus.unauthorized,message: "You Are Not Authorized");
    }

    //get json body, can be map or list of map
    var jsonBody = await context.request.json();
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Error Payload. Must be Map");
    }

    //update db, if error will caught in catch
    kegiatan = await kegiatanRepository.update(kegiatanId, kegiatan);
    return Response.json(body: kegiatan.toJson());
  } catch(e){
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Error Occured");
  }
}