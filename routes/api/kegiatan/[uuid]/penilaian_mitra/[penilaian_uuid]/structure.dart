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
  String penilaianUuid,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid,penilaianUuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext ctx, String kegiatan_uuid, String penilaian_uuid) async {
  StructurePenilaianRepository structureRepo = ctx.read<StructurePenilaianRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  try {
    Kegiatan kegiatan = await kegiatanRepo.getById(kegiatan_uuid);

    bool isReturnAll = false;

    if((authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]) || authUser.username == (kegiatan.penanggung_jawab??""))){
      isReturnAll = true;
    } else if(authUser.isContainOne(["PEGAWAI"])){
      isReturnAll = false;
    } else {
      return RespHelper.forbidden();
    }
    List<StructurePenilaianMitraDetails> listObject = [];
    if(isReturnAll){
      listObject = await structureRepo.readDetailsByPenilaian(penilaian_uuid);
    } else {
      listObject = await structureRepo.readDetailsByPenilaianAndPenilai(penilaian_uuid, authUser.username);
    }
    return Response.json(body: listObject);
  } catch(ee){
    log("Error ${ee}");
    return RespHelper.badRequest(message: "Error Get Structure Mitra Penilaian ${penilaian_uuid}");
  }
}
