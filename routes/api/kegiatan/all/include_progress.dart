import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:postgres/postgres.dart';

Future<Response> onRequest(RequestContext context) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


//return all kegiatan with their progress
Future<Response> onGet(RequestContext ctx) async {
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  
  //AUTHORIZATION
  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"]))){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try { 
    List<KegiatanWithProgress> listOfKegiatanWithProgress = await kegiatanRepo.readAllWithProgress();
    return Response.json(body: listOfKegiatanWithProgress);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Occured");
  } 
}
