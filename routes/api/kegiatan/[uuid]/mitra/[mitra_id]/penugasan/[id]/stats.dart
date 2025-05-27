import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/datetime_helper.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/penugasan_history.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/repository/penugasan_history_repository.dart';
import 'package:my_first/responses/penugasan_history_stats.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
  String mitraId,
  String id,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,id),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx,String uuid) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  PenugasanHistoryRepository penugasanHistoryRepo = ctx.read<PenugasanHistoryRepository>();
  User authUser = ctx.read<User>();

  if(!authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"])) {
    return RespHelper.unauthorized();
  }

  try {
    List<PenugasanHistory> listObject = await penugasanHistoryRepo.readAllByPenugasanUuid(uuid);

    PenugasanHistoryStats stats = await calculateVisitsAndDuration(uuid, listObject);
    print("Stats : ${stats}");
    return Response.json(body: stats.toJson());
  } catch(e){
    print("Error get Penugasan Details Stats ${e}");
    return RespHelper.badRequest(message: "Error Occured ${e}");
  }
}

//Duration in milliseconds
Future<PenugasanHistoryStats> calculateVisitsAndDuration(String uuid,List<PenugasanHistory> listObject) async {
  PenugasanHistoryStats stats = PenugasanHistoryStats(
    penugasan_uuid: uuid,
    number_of_visit: 0,
    duration: 0
  );

  //calculate number_of_visit
  listObject.forEach((el){
    //status 1:DALAM_PROSES
    if(el.status == 1){
      stats.number_of_visit++;
    }
  });

  //calculate duration
  //this assume that first element (index:0) must be "DALAM_PROSES"
  //so in 0,2,4,.. even index must be "DALAM_PROSES"
  //1,3,5,.. odd index must be "DIJEDA / SELESAI"

  try {
    for(int i = 0;i < stats.number_of_visit;i++){
      if(2*(i+1) > listObject.length){
        break;
      }
      String started_time_str = listObject.elementAt(2*i)!.created_at;
      DateTime started_time = DatetimeHelper.parseMakassarTime(started_time_str);
      String ended_time_str = listObject.elementAt(2*i+1)!.created_at;
      DateTime ended_time = DatetimeHelper.parseMakassarTime(ended_time_str);
      Duration itemDuration  = ended_time.difference(started_time);
      stats.duration += itemDuration.inMilliseconds;
    }
  } catch(e){
    print("Error ${e}");
  }

  return stats;
}