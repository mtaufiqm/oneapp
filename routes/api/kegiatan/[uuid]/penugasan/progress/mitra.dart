import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/responses/kegiatan_mitra_penugasan_progress.dart';

Future<Response> onRequest(RequestContext ctx, String uuid) async {
  return (switch(ctx.request.method){
    HttpMethod.get => onGet(ctx,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext ctx, String uuid) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  User authUser = ctx.read<User>();
  try{
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM"]))){
      return RespHelper.unauthorized();
    }
    List<KegiatanMitraPenugasanByMitraProgress> listObject = await kmpRepo.getProgressKegiatan(uuid as String);
    return Response.json(body: listObject);
  } catch(e){
    return RespHelper.badRequest(message: "Error ${e}");
  }
}