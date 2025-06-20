import 'dart:developer';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/ickm/kuesioner_penilaian_mitra.dart';
import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/kuesioner_penilaian_repository.dart';
import 'package:my_first/repository/ickm/structure_penilaian_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx, String uuid) async {
  KuesionerPenilaianRepository kuesionerRepo = ctx.read<KuesionerPenilaianRepository>();
  StructurePenilaianRepository structureRepo = ctx.read<StructurePenilaianRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();

  try {
    KuesionerPenilaianMitra penilaian = await kuesionerRepo.getById(uuid); 
    Kegiatan kegiatan = await kegiatanRepo.getById(penilaian.kegiatan_uuid);

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
      listObject = await structureRepo.readDetailsByPenilaian(uuid);
    } else {
      listObject = await structureRepo.readDetailsByPenilaianAndPenilai(uuid, authUser.username);
    }
    return Response.json(body: listObject);
  } catch(e){
    log("Error Get Structure ${e}");
    return RespHelper.badRequest(message: "Error Get Structure");
  }
}

Future<Response> onPost(RequestContext ctx, String uuid) async {
  KuesionerPenilaianRepository penilaianRepo = ctx.read<KuesionerPenilaianRepository>();
  StructurePenilaianRepository structureRepo = ctx.read<StructurePenilaianRepository>();
  User authUser = ctx.read<User>();

  try {
    return Response.json();
  } catch(err){
    log("Error Update Structure ${err}");
    return RespHelper.badRequest(message: "Error Update Structure ${uuid}");
  }
}
