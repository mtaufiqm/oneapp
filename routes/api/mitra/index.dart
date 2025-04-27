import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/mitra.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/mitra_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.unauthorized())
  });
}


Future<Response> onGet(RequestContext ctx) async {
  MitraRepository mitraRepo = ctx.read<MitraRepository>();
  User authUser = ctx.read<User>();

  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI"]))){
    return RespHelper.unauthorized();
  }

  try{
    List<Mitra> listOfMitra = await mitraRepo.readAll();
    return Response.json(body: listOfMitra);
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Get All Mitra");
  }
}
