import 'dart:developer';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/structure_penilaian_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx, String structure_uuid) async {
  StructurePenilaianRepository structureRepo = ctx.read<StructurePenilaianRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  try {
    StructurePenilaianMitraDetails spmDetails = await structureRepo.getDetailsByUuid(structure_uuid);
    Kegiatan kegiatan = await kegiatanRepo.getById(spmDetails.kegiatan_uuid!);
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]) || authUser.username == (spmDetails.penilai_username??"") || authUser.username == (kegiatan.penanggung_jawab??""))){
      return RespHelper.forbidden();
    }


    return Response.json(body: spmDetails);
  } catch(err){
    String message = "Error get Structure Details ${structure_uuid} : ${err}";
    log(message);
    return RespHelper.badRequest(message: message);
  }
}
