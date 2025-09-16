import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/mitra.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/mitra_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String username,
  String status
) {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,username,status),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx, String username, String status) async {
  MitraRepository mitraRepo = ctx.read<MitraRepository>();
  KegiatanMitraRepository kmRepo = ctx.read<KegiatanMitraRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();


  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM","PEGAWAI"]) || username == authUser.username)){
    return RespHelper.unauthorized();
  }

  try{
    int parsedStatus = (int.tryParse(status))??0;

    Mitra mitra = await mitraRepo.getByUsername(username); 
    List<KegiatanMitraBridgeDetails> listObject = await kmRepo.getDetailsByMitraIdFilterByKegiatanStatus(mitra.mitra_id,parsedStatus);

    return Response.json(body: listObject); 
  } catch(e){
    print("Error : ${e}");
    return RespHelper.badRequest(message: "Error Occured ${e}");
  }
}
