import 'dart:convert';
import 'dart:developer';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/ickm/response_assignment.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/answer_assignment_repository.dart';
import 'package:my_first/repository/ickm/response_assignment_repository.dart';
import 'package:my_first/repository/ickm/structure_penilaian_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/responses/ickm/request_assignment_structure.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    HttpMethod.post => onPost(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext ctx, String uuid) async {
  //need implementations
  //return all questions for this assignments
  return Response.json();

}


//this only save, not submit
//Insert / Update RequestAssignmentStructure;
Future<Response> onPost(RequestContext ctx, String uuid) async {
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  StructurePenilaianRepository structureRepo = ctx.read<StructurePenilaianRepository>();
  ResponseAssignmentRepository responseRepo = ctx.read<ResponseAssignmentRepository>();
  AnswerAssignmentRepository answerRepo = ctx.read<AnswerAssignmentRepository>();
  User authUser = ctx.read<User>();
  try {
    var response = await responseRepo.getById(uuid);
    var structure = await structureRepo.getDetailsByUuid(response.structure_uuid);
    Kegiatan kegiatan = await kegiatanRepo.getById(structure.kegiatan_uuid!);
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]) || (structure.penilai_username??"") == authUser.username || (kegiatan.penanggung_jawab??"") == authUser.username)){
      return RespHelper.methodNotAllowed();
    }
    var jsonBody = jsonDecode(await ctx.request.body());
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.forbidden();
    }
    RequestAssignmentStructure object = RequestAssignmentStructure.fromJson(jsonBody);
    await responseRepo.upsertResponseAnswersByUuidSave(uuid, object.response, object.answers);
    return RespHelper.message(message:"SUCCESS");

  } catch(err){
    log("Error Upsert Answers");
    return RespHelper.badRequest(message: "Error Occured ${err}");
  }
}
