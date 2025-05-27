import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:my_first/blocs/datetime_helper.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
  String mitraId,
  String id,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid,mitraId,id),
    HttpMethod.post => onPost(context,uuid,mitraId,id),
    HttpMethod.delete => onDelete(context, uuid, mitraId,id),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


//get record details
Future<Response> onGet(RequestContext ctx, String uuid, String mitraId, String id) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  User authUser = ctx.read<User>();

  try{
    KegiatanMitraPenugasanDetails objectDetails = await kmpRepo.getDetailsById(id);

    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM","PEGAWAI"]) || authUser.username == objectDetails.mitra_username)){
      return RespHelper.unauthorized();
    }
    return Response.json(body: objectDetails);

  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message:"Error Occured");
  }
}

//update records
Future<Response> onPost(RequestContext ctx, String uuid, String mitra_id,String id) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  User authUser = ctx.read<User>();

  try{

    KegiatanMitraPenugasanDetails objectDetails = await kmpRepo.getDetailsById(id);

    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM"]) || authUser.username == objectDetails.mitra_username)){
      return RespHelper.unauthorized();
    }

    var jsonObject = await ctx.request.json();

    if(!(jsonObject is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }

    KegiatanMitraPenugasan inputtedObject = KegiatanMitraPenugasan.fromJson(jsonObject as Map<String,dynamic>);

    //check if penugasan_status changed, its not allowed for now, because it can affect penugasan_history
    if(objectDetails.status != inputtedObject.status){
      return RespHelper.unauthorized();
    }

    inputtedObject.last_updated = DatetimeHelper.getCurrentMakassarTime();

    KegiatanMitraPenugasan object = await kmpRepo.update(id, inputtedObject);
    
    return Response.json(body: objectDetails);

  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message:"Error Occured");
  }
}


Future<Response> onDelete(RequestContext ctx, String kegiatan_uuid, String mitra_id, String uuid) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  User authUser = ctx.read<User>();

  try{
    KegiatanMitraPenugasanDetails objectDetails = await kmpRepo.getDetailsById(uuid);

    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM"]))){
      return RespHelper.unauthorized();
    }

    //delete kegiatan_mitra_penugasan
    await kmpRepo.delete(uuid);

    return Response.json(body: objectDetails);
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message:"Error Occured");
  }
}