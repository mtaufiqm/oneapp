import 'dart:async';
import 'dart:math';

import 'package:dart_frog/dart_frog.dart';
import 'package:excel/excel.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/models/penugasan_history.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/penugasan_history_repository.dart';
import 'package:my_first/responses/penugasan_history_stats.dart';
import 'package:uuid/uuid.dart';

import '../../mitra/[mitra_id]/penugasan/[id]/stats.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return (switch(context.request.method) {
    HttpMethod.get => onGet(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext ctx, String uuid) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  PenugasanHistoryRepository phRepo = ctx.read<PenugasanHistoryRepository>();
  User authUser = ctx.read<User>();
  
  try {
    Kegiatan kegiatan =  await kegiatanRepo.getById(uuid);
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]) || kegiatan.created_by == authUser.username)) {
      return RespHelper.forbidden();
    }
    List<KegiatanMitraPenugasanDetailsWithHistory> listObject = await kmpRepo.readDetailsWithHistoryByKegiatanUuid(kegiatan.uuid!);
    List<int> excelBytes = await exportPenugasanDetailsToExcel(listObject);

    return Response.bytes(body: excelBytes,headers: {
      "Content-Type":"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      "Content-Disposition":'attachment; filename="${kegiatan.uuid}.xlsx"'
    });
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Occured");
  }
}


Future<List<int>> exportPenugasanDetailsToExcel(List<KegiatanMitraPenugasanDetailsWithHistory> listObject) async {
  String fileName = Uuid().v1();
  Excel excel = Excel.createExcel();
  Sheet firstSheet = excel.sheets.values.first;
  //add header table
  firstSheet.appendRow([
    TextCellValue("ID"),
    TextCellValue("Kegiatan Name"),
    TextCellValue("ID Mitra"),
    TextCellValue("Mitra Name"),
    TextCellValue("Group Code"),
    TextCellValue("Group Description"),
    TextCellValue("Group Type"),
    TextCellValue("Assignment Description"),
    TextCellValue("Assignment Unit"),
    TextCellValue("Assignment Status Code"),
    TextCellValue("Assignment Status Description"),
    TextCellValue("Last Updated"),
    TextCellValue("Last Location"),
    TextCellValue("Kunjungan"),
    TextCellValue("Durasi (Menit)")
  ]);
  //add implementation, set column style (just first row/header)

  //add body
  for(var item in listObject){
    KegiatanMitraPenugasanDetails el = item.details;
    List<PenugasanHistory> history = item.history.map((i) {
      return PenugasanHistory(
        uuid: i.uuid!,
        penugasan_uuid: i.penugasan_uuid, 
        status: i.status, 
        created_at: i.created_at,
        location_latitude: i.location_latitude,
        location_longitude: i.location_longitude
      );
    }).toList();
    PenugasanHistoryStats stats = await calculateVisitsAndDuration(el.uuid!, history);
    String id = el.uuid!;
    String kegiatanName = el.kegiatan_name;
    String mitraId = el.mitra_id;
    String mitraName = el.mitra_name;
    String groupCode = el.group;
    String groupDesc = el.group_desc;
    String groupType = el.group_type_id.toString();
    String assignmentDesc = el.description;
    String assignmentUnit = el.unit;
    String assignmentStatusCode = el.status.toString();
    String assignmentStatusDesc = el.status_desc;
    String lastUpdated = el.last_updated;
    String lastLocation = (el.status==0?"":"https://maps.google.com/?q=[lat],[long]".replaceFirst("[lat]", el.location_latitude??"").replaceFirst("[long]", el.location_longitude??""));
    String jumlahKunjungan = "${stats.number_of_visit}";
    String durasiPencacahan = "${Duration(milliseconds: stats.duration).inMinutes}";

    //add to sheet
    firstSheet.appendRow([
    TextCellValue(id),
    TextCellValue(kegiatanName),
    TextCellValue(mitraId),
    TextCellValue(mitraName),
    TextCellValue(groupCode),
    TextCellValue(groupType),
    TextCellValue(groupDesc),
    TextCellValue(assignmentDesc),
    TextCellValue(assignmentUnit),
    TextCellValue(assignmentStatusCode),
    TextCellValue(assignmentStatusDesc),
    TextCellValue(lastUpdated),
    TextCellValue(lastLocation),
    TextCellValue(jumlahKunjungan),
    TextCellValue(durasiPencacahan)
    ]);
  }
  return excel.save()??[];
}

