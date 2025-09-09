import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/ickm_mitra_repository.dart';
import 'package:my_first/repository/mitra_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch(context.request.method){
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  };
}


Future<Response> onGet(RequestContext ctx) async {
  IckmMitraRepository ickmRepo = ctx.read<IckmMitraRepository>();
  MitraRepository mitraRepo = ctx.read<MitraRepository>();
  User authUser = ctx.read<User>();
  try {
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"]))){
      return RespHelper.forbidden();
    }
    var listMitra = await mitraRepo.readAllWithIckm();
    return Response.json(body: listMitra);
  } catch(err){
    print(err);
    return RespHelper.badRequest(message: "Error Occurred ${err}");
  }
}