import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/files.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/files_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return(switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    HttpMethod.post => onPost(context,uuid),
    HttpMethod.delete => onDelete(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

//GET DATA
Future<Response> onGet(RequestContext ctx,String uuid) async {
  FilesRepository filesRepo = ctx.read<FilesRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!(user.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI","GET_IMAGES"]))){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    Files files = await filesRepo.getById(uuid);
    var locationFile = File(files.location);
    if(!locationFile.existsSync()){
      return RespHelper.badRequest(message: "There is no images with uuid ${uuid}");
    }
    List<int> bytesOfFile = await locationFile.readAsBytes();
    return Response.bytes(body: bytesOfFile,headers: {"Content-Type": "application/octet-stream",'Content-Disposition':'attachment; filename="${files.name}"'});
  } catch(e){
    return RespHelper.badRequest(message: "Error Get Data ${uuid}");
  }
}



//UPDATE DATA
Future<Response> onPost(RequestContext ctx,String uuid) async {
  FilesRepository filesRepo = ctx.read<FilesRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","POST_FILES"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION
  try{
    var jsonBody = await ctx.request.json();
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid Input Files ${uuid}");
    }
    var object = Files.fromJson(jsonBody);
    var result = await filesRepo.update(uuid,object);
    return Response.json(body: result);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Failed to Update Files ${uuid}");
  }
}

Future<Response> onDelete(RequestContext ctx,String uuid) async{
  FilesRepository categoriesRepo = ctx.read<FilesRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    await categoriesRepo.delete(uuid);
    return RespHelper.message(message: "success delete ${uuid}");
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Delete Files ${uuid}");
  }
}

