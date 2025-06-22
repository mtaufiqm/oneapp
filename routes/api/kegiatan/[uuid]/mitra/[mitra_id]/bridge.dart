import 'dart:convert';
import 'dart:developer';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
  String mitraId,
) async {
  print("HTTP METHOD : ${context.request.method} \nBody ${await context.request.body()}");
  return switch(context.request.method){
    HttpMethod.put => onPut(context,uuid,mitraId),
    _ => Future.value(RespHelper.methodNotAllowed())
  };
}

//update kegiatan_mitra_bridge
Future<Response> onPut(RequestContext ctx, String kegiatan_uuid, String mitra_id) async {
  KegiatanMitraRepository kmbRepo = ctx.read<KegiatanMitraRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();

  try {
    Kegiatan kegiatan = await kegiatanRepo.getById(kegiatan_uuid);
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]) || (authUser.username == kegiatan.created_by) || authUser.username == (kegiatan.penanggung_jawab??""))){
      return RespHelper.forbidden();
    }

    var jsonBody = jsonDecode(await ctx.request.body());
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }
    KegiatanMitraBridge kmbInput = KegiatanMitraBridge.fromJson(jsonBody);

    KegiatanMitraBridge kmb = await kmbRepo.getByKegiatanAndMitra(kegiatan_uuid, mitra_id);

    var result = await kmbRepo.updateByUuid(kmb.uuid!,kmbInput);
    return Response.json(body: result);    
  } catch(err){
    log("Error ${err}");
    return RespHelper.badRequest(message: "Failed Update Kegiatan-Mitra ${err}");
  }

}
