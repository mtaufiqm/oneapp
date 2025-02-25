import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/files.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/files_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    HttpMethod.post => onPost(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

//Current Implementation is Get All File, NEXT Filter it By Extension
Future<Response> onGet(RequestContext con) async {
  FilesRepository filesRepo = con.read<FilesRepository>();

  //AUTHORIZATION
  User user = con.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI","GET_IMAGES"])){
    return RespHelper.methodNotAllowed();
  }
  //AUTHORIZATION


  try{
    List<Files> list_object = await filesRepo.readAll();
    return Response.json(body: list_object);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Fail to Get All Data");
  }
}

Future<Response> onPost(RequestContext ctx) async {
  FilesRepository filesRepo = ctx.read<FilesRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI","CREATE_FILES"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    var jsonMap = await ctx.request.json();
    if(!(jsonMap is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body!");
    }
    Files files = Files.fromJson(jsonMap as Map<String,dynamic>);
    var result = await filesRepo.create(files);
    return Response.json(body: result.toJson());
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Occured!");
  }
}
