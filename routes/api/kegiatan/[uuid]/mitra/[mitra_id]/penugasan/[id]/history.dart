import 'dart:developer';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
  String mitraId,
  String id,
) {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid,mitraId,id),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx, String kegiatan_uuid, String mitra_id, String uuid) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  User authUser = ctx.read<User>();

  try {
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"]))){
      return RespHelper.forbidden();
    }
    KegiatanMitraPenugasanDetailsWithHistory kmpDetailsWithHistory = await kmpRepo.getDetailsWithHistoryByUuid(uuid);
    return Response.json(body: kmpDetailsWithHistory);
  } catch(err){
    log("Error Get History Penugasan ${uuid as String} : ${err}");
    return RespHelper.badRequest(message: "Error Get History Penugasan ${uuid as String} : ${err}");
  }
}
