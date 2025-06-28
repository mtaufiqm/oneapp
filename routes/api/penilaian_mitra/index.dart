import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/ickm/kuesioner_penilaian_mitra.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/kuesioner_penilaian_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx) async {
  KuesionerPenilaianRepository kuesionerPenilaianRepo = ctx.read<KuesionerPenilaianRepository>();
  User authUser = ctx.read<User>();

  try {
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"]))){
      return RespHelper.forbidden();
    }
    //need implementations;
    List<KuesionerPenilaianMitra> listPenilaian = await kuesionerPenilaianRepo.readAll();
    
    return Response.json(body: listPenilaian);
  } catch(err){
    print("Error ${err}");
    return RespHelper.badRequest(message: "Error Occured when Read All Penilaian Mitra ${err}");
  }
}
