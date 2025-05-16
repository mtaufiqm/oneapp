import 'package:dart_frog/dart_frog.dart';
import 'package:excel/excel.dart';
import 'package:my_first/blocs/datetime_helper.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';

import '../../../../../../lib/blocs/web/penugasan_helper.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  return (switch(context.request.method){
    HttpMethod.post => onPost(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}



//1-st Column : MitraID
//2-nd Column : Mitra Name
//3-rd Column : GroupCode, ex: kode bs, kode sls, kode desa, kode kec.
//4-th Column : GroupType
//5-th Column : Code for Sample, Like No.1, No.2, this distuingish sample inside same group
//6-th Column : Sample Description, ex: household name, direktori name, corporate name
//7-th Column : Sample Unit, ex: household, directory, corporate, etc

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

    var formData = await ctx.request.formData();
    var uploadedFile = formData.files["files"];
    if(uploadedFile == null){
      return RespHelper.badRequest(message: "There is no Uploaded File 'file'");
    }


    // //verify uploaded file content type
    // if(uploadedFile.contentType.mimeType != "application/vnd.ms-excel"){
    //   return RespHelper.badRequest(message: "Invalid Uploaded File. Must be Excel File (application/vnd.ms-excel)");
    // }

    List<int> fileBytes = await uploadedFile.readAsBytes();

    Excel excelFile = Excel.decodeBytes(fileBytes);

    Sheet firstSheet = excelFile.sheets[excelFile.sheets.keys.first]!;
    var rows = firstSheet.rows;

    bool isFirstRow = true;
    
    List<KegiatanMitraPenugasan> kmpList = [];
    for(var item in rows){
      try {
        if(isFirstRow == true){
          isFirstRow = false;
          continue;
        }
        String mitra_id = item[0]!.value.toString();

        KegiatanMitraBridge kmItem = await kmRepo.getByKegiatanAndMitra(uuid, mitra_id);

        String bridge_uuid = kmItem.uuid!;
        String group_code = item[2]!.value.toString();
        int group_type = int.parse(item[3]!.value.toString());
        String code = item[4]!.value.toString();
        String desc = item[5]!.value.toString();
        String unit = item[6]!.value.toString();

        //generate group desc
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
      } catch(err) {
        print(err);
        continue;
      }
    }
    List<KegiatanMitraPenugasan> successList = await kmpRepo.createList(kmpList);
    return Response.json(body: successList);
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message:"Error Occured ${e}");
  }
}
