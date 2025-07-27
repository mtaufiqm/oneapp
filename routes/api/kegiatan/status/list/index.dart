import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan_status.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_status_repository.dart';


//this api for kegiatan_status table
Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx) async {
  KegiatanStatusRepository statusRepo = ctx.read<KegiatanStatusRepository>();
  User authUser = ctx.read<User>();
  try {
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI"]))){
      return RespHelper.forbidden();
    }

    List<KegiatanStatus> listObject = await statusRepo.readAll();
    return Response.json(body: listObject);
  } catch(err){
    return RespHelper.badRequest(message: "Error Occured ${err}");
  }
}
