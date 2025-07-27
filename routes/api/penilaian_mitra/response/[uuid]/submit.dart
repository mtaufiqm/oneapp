import 'dart:convert';
import 'dart:developer';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/answer_assignment_repository.dart';
import 'package:my_first/repository/ickm/response_assignment_repository.dart';
import 'package:my_first/repository/ickm/structure_penilaian_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/responses/ickm/request_assignment_structure.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid
) async {
  return switch(context.request.method){
    HttpMethod.post => onPost(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  };
}

//this submit
//Insert / Update RequestAssignmentStructure and Calculate ICKM;
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
    var responseAssignment = await responseRepo.upsertResponseAnswersByUuidSubmit(uuid, object.response, object.answers);

    //failed in calculate ickm or insert it to ickm_mitra table, but answers is saved
    if(responseAssignment == null){
      throw Exception("Gagal Mendapatkan/Menyimpan Nilai Indeks Mitra");
    }
    return Response.json(body: responseAssignment);

  } catch(err){
    print("Error Upsert Answers Submit : ${err}");
    return RespHelper.badRequest(message: "Error Occured ${err}");
  }
}
