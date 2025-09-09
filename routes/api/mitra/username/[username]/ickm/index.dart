import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/ickm_mitra_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String username,
) async {
  return switch(context.request.method){
    HttpMethod.get => onGet(context,username),
    _ => Future.value(RespHelper.methodNotAllowed())
  };
}


Future<Response> onGet(RequestContext ctx, String username) async {
  IckmMitraRepository ickmRepo = ctx.read<IckmMitraRepository>();
  User authUser = ctx.read<User>();
  try {
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"]) || username == authUser.username)){
      return RespHelper.forbidden();
    }
    var average = await ickmRepo.getAverageIckmByMitraUsername(username);
    return Response.json(body: {
      "ickm":average
    });
  } catch(err){
    print(err);
    return RespHelper.badRequest(message: "Error Occurred ${err}");
  }
}
