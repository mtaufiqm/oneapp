import 'dart:developer';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:intl/intl.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String date,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,date),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext ctx, String date) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  User authUser = ctx.read<User>();
  try {
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"]))){
      return RespHelper.forbidden();
    }
    String groupBy = ctx.request.url.queryParameters["groupby"]??"kegiatan";
    String formattedDate = DateFormat("yyyyMMdd").format(DateTime.parse(date));
    // print("Group By : ${groupBy}");
    // print("Formatted Date : ${formattedDate}");
    List<KegiatanMitraPenugasanGroup> listObject = [];
    if(groupBy == "kegiatan") {
      listObject = await kmpRepo.readAllDetailsByHistoryStatusAndHistoryUpdateGroupedByKegiatan(date);
    }
    if(groupBy == "mitra") {
      listObject = await kmpRepo.readAllDetailsByHistoryStatusAndHistoryUpdateGroupedByMitra(date);
    }

    return Response.json(body: listObject);

  } catch(err){
    log("Error ${err}");
    return RespHelper.badRequest(message: "Error ${err}");
  }
}
