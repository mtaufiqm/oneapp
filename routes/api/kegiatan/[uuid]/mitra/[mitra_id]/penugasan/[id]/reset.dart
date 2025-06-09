import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
  String mitraId,
  String id,
) async {
  return (switch(context.request.method){
    HttpMethod.post => onPost(context,uuid,mitraId,id),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onPost(RequestContext ctx, String kegiatan_uuid, String mitra_id, String uuid) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  try {
    Kegiatan kegiatan = await kegiatanRepo.getById(kegiatan_uuid);
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]) || authUser.username == kegiatan.created_by)){
      return RespHelper.unauthorized();
    }

    await kmpRepo.resetStatusAndLocation(uuid);

    return RespHelper.message(message: "SUCCESS RESET ${uuid}");
  } catch(ee){
    print("Error Reset Penugasan ${uuid}");
    return RespHelper.badRequest(message: "Fail to Reset Status");
  }
}
