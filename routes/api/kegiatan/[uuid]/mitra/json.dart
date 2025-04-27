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
  String uuid,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    HttpMethod.post => onPost(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


//get all mitra from spesific kegiatan
Future<Response> onGet(RequestContext ctx, String uuid) async {
  KegiatanMitraRepository kegiatanMitraRepo = ctx.read<KegiatanMitraRepository>();
  MitraRepository mitraRepo = ctx.read<MitraRepository>();
  User authUser = ctx.read<User>();

  try{
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM","PEGAWAI"]))){
      return RespHelper.unauthorized();
    }

    List<KegiatanMitraBridge> listKegiatanMitra = await kegiatanMitraRepo.getByKegiatanId(uuid);

    return Response.json(body: listKegiatanMitra);
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Occured");
  }
}


//insert mitra for spesific kegiatan or append it
/***
 
[
  {
    "mitra_id":"<mitra_id>",
    "status":"<status: PCL / PML / or another>"
  }
]

 ***/

Future<Response> onPost(RequestContext ctx, String uuid) async {
  KegiatanMitraRepository kegiatanMitraRepo =  ctx.read<KegiatanMitraRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();

  try{
    Kegiatan kegiatan = await kegiatanRepo.getById(uuid);

    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM"]) || authUser.username == kegiatan.created_by)){
      return RespHelper.unauthorized();
    }

    var jsonObject = await ctx.request.json();
    if(!(jsonObject is List<dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }

    List<KegiatanMitraBridge> listOfMitra = [];
    //convert from jsonObject to List Of KegiatanMitraBridge
    (jsonObject as List<dynamic>).forEach((el){
      try{
        var mapObj = el as Map<String,dynamic>;

        //clean mitra_id and status from left space or right space
        mapObj["status"] = (mapObj["status"] as String?)?.trim().toUpperCase();
        mapObj["mitra_id"] = (mapObj["mitra_id"] as String?)?.trim();

        //add kegiatan_uuid for each element;
        mapObj["kegiatan_uuid"] = "${kegiatan.uuid}";
        listOfMitra.add(KegiatanMitraBridge.fromJson(mapObj));
      } catch(e){
        print("Error ${e}");
      }
    });

    List<KegiatanMitraBridge> kegiatanMitra = await kegiatanMitraRepo.create(listOfMitra);

    return Response.json(body: kegiatanMitra);
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Occured");
  }
}



