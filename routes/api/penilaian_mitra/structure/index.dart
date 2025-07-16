import 'dart:developer';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/request_helper.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/structure_penilaian_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  return switch(context.request.method){
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  };
}

Future<Response> onGet(RequestContext ctx) async {
  StructurePenilaianRepository structureRepo = ctx.read<StructurePenilaianRepository>();
  User authUser = ctx.read<User>();
  try {
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"]))){
      return RespHelper.forbidden();
    }

    Map<String,dynamic> cleanedParam = RequestHelper.parseAllQueryParam({"limit":50 as int}, ctx.request);
    int limit = cleanedParam["limit"]! as int;
    log("Limit is ${limit}");

    List<StructurePenilaianMitraDetails> listObject = [];
    if(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"])){
      listObject = await structureRepo.readAllDetailsLimit(limit);
    } else {
      listObject = await structureRepo.readAllDetailsByPenilai(authUser.username);
    }
    return Response.json(body: listObject);


  } catch(err){
    String message = "Error get All Structure Penilaian Mitra ${err}";
    log(message);
    return RespHelper.badRequest(message: message);
  }
}