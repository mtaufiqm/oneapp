import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/models/mitra.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/repository/mitra_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String username,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,username),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx, String username) async {
  MitraRepository mitraRepo = ctx.read<MitraRepository>();
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  User authUser = ctx.read<User>();

  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"]) || username == authUser.username)){
    return RespHelper.unauthorized();
  }

  try{
    Mitra mitra = await mitraRepo.getByUsername(username);
    var listOfObject = await kmpRepo.readAllDetailsByMitraGroupedByKegiatan(mitra.mitra_id);
    
    return Response.json(body: listOfObject);

  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Failed Get Data ${username}");
  }
}