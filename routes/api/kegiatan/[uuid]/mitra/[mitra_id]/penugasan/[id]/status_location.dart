import 'package:dart_frog/dart_frog.dart';
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
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.post => onPost(context,uuid,mitraId,id),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

//update location, status and notes

//0 : Belum Mulai
//1 : Dalam Proses
//2 : Dijeda
//3 : Selesai
Future<Response> onPost(RequestContext ctx,String uuid, String mitra_id,String id) async {
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
    } else{}

    
    //int status, string started_time, string ended_time
    int status = jsonObject["status"] as int;
    String started_time = (jsonObject["started_time"] as  String?)??"";
    String ended_time = (jsonObject["ended_time"] as String?)??"";
    String notes = (jsonObject["notes"] as String?)??"";
    String location_latitude = (jsonObject["location_latitude"] as String);
    String location_longitude = (jsonObject["location_longitude"] as String);


    //this is for verification data

    //BELUM MULAI INPUT NOT ALLOWED FOR ANY CURRENT STATUS
    if(status == 0){
      return RespHelper.badRequest(message: "Cannot Update Status to Belum Mulai");
    }

    //if not have started, input only can be started(1)
    if(objectDetails.status == 0){
      if(status == 1){
        var result = await kmpRepo.updateLocationAndStatusAndNotes(status, DatetimeHelper.getCurrentMakassarTime(), "", location_latitude, location_longitude, notes, id);
        return RespHelper.message(message: "Success");
      } else {
        return RespHelper.badRequest(message: "Task Not have Started. Only can be Started");
      }
    }

    //If have started, input cannot started again (0 & 1)    
    if(objectDetails.status == 1){
      if(status == 1){
        return RespHelper.badRequest(message: "Cannot Started again");
      } else if(status == 2){
        //Jika status sedang dimulai dan ingin dijeda
        var result = await kmpRepo.updateLocationAndStatusAndNotes(status, objectDetails.started_time??"", DatetimeHelper.getCurrentMakassarTime(), location_latitude, location_longitude, notes, id);
        return RespHelper.message(message: "Success");
      } else if(status == 3){
        //Jika status sedang dimulai dan ingin diakhir
        var result = kmpRepo.updateLocationAndStatusAndNotes(status, objectDetails.started_time??"",DatetimeHelper.getCurrentMakassarTime(), location_latitude, location_longitude, notes, id);
        return RespHelper.message(message: "Success");
      }
    }


    //if have paused, input cannot paused again (0 & 2)
    if(objectDetails.status == 2){
      if(status == 1){
        //if have paused, and want to start again
        var result = await kmpRepo.updateLocationAndStatusAndNotes(status, objectDetails.started_time??"", objectDetails.ended_time??"", location_latitude, location_longitude, notes, id);
        return RespHelper.message(message: "Success");
      } else if(status == 2){
        //if have paused, and want to pause again
        return RespHelper.badRequest(message: "Task have paused, cannot paused again");
      } else if(status == 3){
        //if have paused, and want to end it.
        var result = await kmpRepo.updateLocationAndStatusAndNotes(status, objectDetails.started_time??"",objectDetails.ended_time??"", location_latitude, location_longitude, notes, id);
        return RespHelper.message(message: "Success");
      }
    }

    //if have ended, any input not allowed (0,1,2)
    if(objectDetails.status == 3){
      return RespHelper.badRequest(message: "Task have ended, cannot edited");
    }

    return RespHelper.message(message: "Success Update Status ${id}");
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message:"Error Occured");
  }
}
