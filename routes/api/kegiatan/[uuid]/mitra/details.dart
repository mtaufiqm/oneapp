import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
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

Future<Response> onGet(RequestContext ctx, String uuid) async {
  KegiatanMitraRepository kmbRepo = ctx.read<KegiatanMitraRepository>();

  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();

  try {
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"]))){
      return RespHelper.forbidden();
    }
    var result = await kmbRepo.getMoreDetailsByKegiatanId(uuid);
    return Response.json(body: result);
  } catch(err){
    print("Error Occured ${err}");
    return RespHelper.badRequest(message: "Error Occured get Kegiatan Mitra List ${err}");
  }
}
