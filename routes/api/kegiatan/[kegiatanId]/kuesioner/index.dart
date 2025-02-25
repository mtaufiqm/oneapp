import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kuesioner_mitra.dart';
import 'package:my_first/repository/kuesioner_mitra_repository.dart';


//CONTINUE THIS
Future<Response> onRequest(
  RequestContext context,
  String kegiatanId,
) async {
    return (switch(context.request.method){
      HttpMethod.get => onGet(context,kegiatanId),
      HttpMethod.post => onPost(context,kegiatanId),
      _ => Future<Response>.value(RespHelper.message(statusCode: HttpStatus.methodNotAllowed,message: "Method Not Allowed"))
    });  
}


//GET IF THERE IS KUESIONER KEGIATAN
Future<Response> onGet(RequestContext context,String kegiatanId) async{
  KuesionerMitraRepository kuesionerRepo = context.read<KuesionerMitraRepository>();
  var kuesionerKegiatan = await kuesionerRepo.getByKegiatanUuid(kegiatanId);
  if(kuesionerKegiatan == null){
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Kuesioner Kegiatan Not Exists!");
  }
  return Response.json(body: kuesionerKegiatan.toJson());
}


//CREATE KUESIONER KEGIATAN
Future<Response> onPost(RequestContext context,String kegiatanId) async {
  KuesionerMitraRepository kuesionerRepo = context.read<KuesionerMitraRepository>();
  var kuesionerKegiatan = await kuesionerRepo.getByKegiatanUuid(kegiatanId);
  if(kuesionerKegiatan != null){
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Kuesioner Already Exists!");
  }
  try{
    var jsonBody = await context.request.json();
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Error Template");
    }
    KuesionerMitra kuesionerModel = KuesionerMitra.from((await context.request.json()) as Map<String,dynamic>);
    var result = await kuesionerRepo.create(kuesionerModel);
    return Response.json(body: result.toJson());
  } catch(e){
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Error Creating Kuesioner ${kegiatanId}");
  }
}
