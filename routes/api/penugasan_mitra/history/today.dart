import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';

Future<Response> onRequest(RequestContext context) {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try {
    List<KegiatanMitraPenugasanDetailsWithHistory> listObject = await kmpRepo.readAllDetailsByStatusActiveLastUpdatedToday();
    return Response.json(body: listObject);
    
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Occured ${e}");
  }
}
