import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/models/penugasan_photo.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/penugasan_photo_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  return switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  };
}


Future<Response> onGet(RequestContext ctx, String uuid) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  KegiatanMitraRepository kmRepo = ctx.read<KegiatanMitraRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  PenugasanPhotoRepository photoRepo = ctx.read<PenugasanPhotoRepository>();
  User authUser = ctx.read<User>();
  try {
    KegiatanMitraPenugasanDetails objectDetails = await kmpRepo.getDetailsById(uuid);
    KegiatanMitraBridge bridge = await kmRepo.getByKegiatanAndMitra(objectDetails.kegiatan_uuid, objectDetails.mitra_id);
    Kegiatan kegiatan = await kegiatanRepo.getById(objectDetails.kegiatan_uuid);
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM"]) || (kegiatan.created_by == authUser.username) || (objectDetails.mitra_username == authUser.username) || (authUser.username == bridge.pengawas))){
      return RespHelper.forbidden();
    }
    PenugasanPhoto? photo = await photoRepo.getByKmpUuid(uuid);
    if(photo != null){
      photo.photo1_loc = (photo.photo1_loc!= null)?"":null;
      photo.photo2_loc = (photo.photo2_loc!= null)?"":null;
      photo.photo3_loc = (photo.photo3_loc!= null)?"":null;
    }
    print(photo?.toJson());
    return Response.json(
      body: photo
    );
  } catch(err){
    print("Error Occured ${err}");
    return RespHelper.badRequest(message: "Error Occured ${err}");
  }
}
