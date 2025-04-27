import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/mitra.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/mitra_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String username,
) {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,username),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx, String username) async {
  MitraRepository mitraRepo = ctx.read<MitraRepository>();
  KegiatanMitraRepository kmRepo = ctx.read<KegiatanMitraRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();


  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM","PEGAWAI"]) || username == authUser.username)){
    return RespHelper.unauthorized();
  }

  try{
    Mitra mitra = await mitraRepo.getByUsername(username); 
    List<Kegiatan> listObject = await kegiatanRepo.readAllByMitra(mitra.mitra_id);
    return Response.json(body: listObject); 
  } catch(e){
    print("Error : ${e}");
    return RespHelper.badRequest(message: "Error Occured ${e}");
  }
}
