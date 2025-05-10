import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.post => onPost(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

//Delete List Mitra Of Kegiatan
Future<Response> onPost(RequestContext ctx, String uuid) async {
  KegiatanMitraRepository kegiatanMitraRepo =  ctx.read<KegiatanMitraRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();

  try{
    Kegiatan kegiatan = await kegiatanRepo.getById(uuid);

    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM"]) || authUser.username == kegiatan.created_by)){
      return RespHelper.unauthorized();
    }

    var jsonBody = jsonDecode(await ctx.request.body());

    //check type
    if(!(jsonBody is List<dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }

    List<KegiatanMitraBridge> kmbList = (jsonBody as List<dynamic>).map<KegiatanMitraBridge>((el){
      return KegiatanMitraBridge.fromJson(el as Map<String,dynamic>);
    }).toList();

    

    await kegiatanMitraRepo.deleteList(kmbList);

    return RespHelper.message(message: "Success");
  } catch(e){
    return RespHelper.badRequest(message: "Failed to Delete ${e}");
  }
}
