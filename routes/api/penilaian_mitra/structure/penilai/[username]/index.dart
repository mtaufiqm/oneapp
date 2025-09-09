import 'dart:developer';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/structure_penilaian_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String username,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,username),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}



//get Structure Penilaian Based on Penilai
Future<Response> onGet(RequestContext ctx, String username) async {
  StructurePenilaianRepository structureRepo = ctx.read<StructurePenilaianRepository>();
  User authUser = ctx.read<User>();
  try {
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]) || authUser.username == username)){
      return RespHelper.forbidden();
    }
    List<StructurePenilaianMitraDetails> listObject = await structureRepo.readAllDetailsByPenilai(username);
    return Response.json(body: listObject);
  } catch(err){
    var message = "Error get Structure Penilaian Mitra ${username} : ${err}";
    log(message);
    return RespHelper.badRequest(message: message);
  }
} 
