import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/datetime_helper.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/daerah_tingkat_3.dart';
import 'package:my_first/models/daerah_tingkat_4.dart';
import 'package:my_first/models/daerah_tingkat_5.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/models/mitra.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/daerah_tingkat_3_repository.dart';
import 'package:my_first/repository/daerah_tingkat_4_repository.dart';
import 'package:my_first/repository/daerah_tingkat_5_repository.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/myconnection.dart';

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

Future<Response> onGet(RequestContext ctx, String uuid) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  try{
    Kegiatan kegiatan = await kegiatanRepo.getById(uuid);
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM"]) || authUser.username == kegiatan.created_by)){
      return RespHelper.unauthorized();
    }
    List<KegiatanMitraPenugasanDetails> listObject = await kmpRepo.readAllDetailsByKegiatan(uuid);
    return Response.json(body: listObject);
  } catch(e){
    return RespHelper.badRequest(message: "Error ${e}");
  }
}


//CREATE PENUGASAN LIST
Future<Response> onPost(RequestContext ctx, String uuid) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  KegiatanMitraRepository kmRepo = ctx.read<KegiatanMitraRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  try{
    Kegiatan kegiatan = await kegiatanRepo.getById(uuid);
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM"]) || authUser.username == kegiatan.created_by)){
      return RespHelper.unauthorized();
    }

    var jsonList = await ctx.request.json();
    if(!(jsonList is List<dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }

    List<KegiatanMitraPenugasan> kmpList = [];

    //group_code,group_type,code,mitra_id,mitra_name,desc,unit;
    for(var item in jsonList){
      try{
        if(!(item is Map<String,dynamic>)){
          continue;
        }
        var mapItem = item as Map<String,dynamic>;
        
        String mitra_id = mapItem["mitra_id"] as String;

        KegiatanMitraBridge kmItem = await kmRepo.getByKegiatanAndMitra(uuid, mitra_id);
        
        String bridge_uuid = kmItem.uuid!;
        String group_code = mapItem["group_code"] as String;
        int group_type = mapItem["group_type"] as int;
        String code = mapItem["code"] as String;
        String desc = mapItem["desc"] as String;
        String unit = mapItem["unit"] as String;

        //generate group description
        String group_desc = await generateGroupDesc(ctx, group_type, group_code);

        KegiatanMitraPenugasan kmpItem = KegiatanMitraPenugasan(
          bridge_uuid: bridge_uuid, 
          code: code, 
          group: group_code, 
          group_type_id: group_type, 
          group_desc: group_desc, 
          description: desc, 
          unit: unit, 
          status: 0,    //default for 0: Belum Mulai
          started_time: "",
          ended_time: "",
          location_latitude: "",
          location_longitude: "",
          notes: "",
          created_at: DatetimeHelper.getCurrentMakassarTime(), 
          last_updated: DatetimeHelper.getCurrentMakassarTime()
        );
        
        //add to list if success
        kmpList.add(kmpItem);
      } catch(ee){
        print("Error ${ee}");
        continue;
      }
    }

    List<KegiatanMitraPenugasan> successList = await kmpRepo.createList(kmpList);
    return Response.json(body: successList);
  } catch(e){
    return RespHelper.badRequest(message: "Error ${e}");
  }
}


//FUTURE CONTINUE THIS FOR BS
Future<String> generateGroupDesc(RequestContext ctx, int group_type_id, String group_code) async {
  try{
    switch(group_type_id){
      //for provinsi
      case 0:
        return "73 - Sulawesi Selatan";
      //kabupaten/kota
      case 1:
        return "7317 - Luwu";
      //kecamatan
      case 2:
        return await generateDesc2(ctx, group_code);
      //desa/kelurahan
      case 3:
        return await generateDesc3(ctx, group_code);
      //sls
      case 4:
        return await generateDesc4(ctx, group_code);
      //blok_sensus
      case 5:
        return "${group_code}";
      //nks
      case 6:
        return "${group_code}";
      //default
      default: 
        return "${group_code}";
    }
  } catch(e){
    print("Error ${e}");
    throw Exception("Error Generate Description type : ${group_type_id}, code : ${group_code}");
  }
}

//Kecamatan : 7 Digit
Future<String> generateDesc2(RequestContext ctx, String group_code) async {
  DaerahTingkat3Repository dt3_repo = ctx.read<DaerahTingkat3Repository>();
  String cleanedString = group_code.trim();
  if(cleanedString.length != 7){
    throw Exception("Invalid Code Length");
  }
  DaerahTingkat3 daerah = await dt3_repo.getById("${cleanedString}");
  String desc = "${daerah.id} - ${daerah.name}";
  return desc;    
}


//Desa : 10 Digit
Future<String> generateDesc3(RequestContext ctx, String group_code) async {
  DaerahTingkat4Repository dt4_repo = ctx.read<DaerahTingkat4Repository>();
  String cleanedString = group_code.trim();
  if(cleanedString.length != 10){
    throw Exception("Invalid Code Length");
  }
  DaerahTingkat4 daerah = await dt4_repo.getById("${cleanedString}");
  String desc = "${daerah.id} - ${daerah.name}";
  return desc;    
}

//SLS : 14 Digit
Future<String> generateDesc4(RequestContext ctx, String group_code) async {
  DaerahTingkat5Repository dt5_repo = ctx.read<DaerahTingkat5Repository>();
  String cleanedString = group_code.trim();
  if(cleanedString.length != 14){
    throw Exception("Invalid Code Length");
  }
  DaerahTingkat5 daerah = await dt5_repo.getById("${cleanedString}");
  String desc = "${daerah.id} - ${daerah.name}";
  return desc;    
}