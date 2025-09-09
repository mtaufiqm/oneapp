import 'dart:developer';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/structure_penilaian_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String username,
  String status,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,username,status),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx, String username, String status) async {
  StructurePenilaianRepository structureRepo = ctx.read<StructurePenilaianRepository>();
  User authUser = ctx.read<User>();
  try {
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"]))){
      return RespHelper.forbidden();
    }
    //0 : BELUM SELESAI, 1 : SELESAI
    int intStatus = int.tryParse(status)??1;
    bool isDone = true;
    if(intStatus == 0) {
      isDone = false;
    }
    if(intStatus == 1) {
      isDone = true;
    }
    List<StructurePenilaianMitraDetailsWithNotes> listObject = await structureRepo.readAllDetailsByMitraUsernameAndStatusWithNotes(username, isDone);
    listObject = listObject.map((el) {
      el.penilai_fullname = null;
      el.penilai_username = null;
      el.kegiatan_name = null;
      return el;
    }).toList();
    return Response.json(body: listObject);
  } catch(err){
    var message = "Error get Structure Penilaian Mitra ${username} : ${err}";
    log(message);
    return RespHelper.badRequest(message: "Error : ${message}");
  }
}
