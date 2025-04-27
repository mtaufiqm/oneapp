import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/mitra.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/mitra_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String username,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,username),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext ctx, String username) async {
  MitraRepository mitraRepo = ctx.read<MitraRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  KegiatanMitraRepository kmRepo = ctx.read<KegiatanMitraRepository>();
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  User authUser = ctx.read<User>();

  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"]) || username == authUser.username)){
    return RespHelper.unauthorized();
  }

  try{
    Mitra mitra = await mitraRepo.getByUsername(username);

    //fetch number of kegiatan
    int number_of_kegiatan = (await kmRepo.getByMitraId(mitra.mitra_id)).length;

    //fetch number of assignment
    int number_of_penugasan = (await kmpRepo.readAllDetailsByMitra(mitra.mitra_id)).length;

    return Response.json(body: {
      "number_of_kegiatan":number_of_kegiatan,
      "number_of_penugasan":number_of_penugasan
    });

  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Occured ${e}");
  }

}


