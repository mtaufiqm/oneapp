import 'package:dart_frog/dart_frog.dart';
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
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid,mitraId,id),
    HttpMethod.post => onPost(context,uuid,mitraId,id),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

//get location
Future<Response> onGet(RequestContext ctx,String uuuid, String mitra_id,String id) async {
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



//update location
Future<Response> onPost(RequestContext ctx,String uuuid, String mitra_id,String id) async {
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

    //update 'location only' only for status 1 : DALAM PROSES
    if(objectDetails.status != 1) {
      return RespHelper.badRequest(message:"Assignment not in process");
    }

    
    //string location_latitude, string location_longitude
    String latitude = (jsonObject["location_latitude"] as  String?)??"";
    String longitude = (jsonObject["location_longitude"] as String?)??"";

    //update location only
    await kmpRepo.updateLocationOnly(latitude, longitude, id);
    
    return RespHelper.message(message: "Success Update Location ${id}");

  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message:"Error Occured");
  }
}
