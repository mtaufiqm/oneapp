import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/ickm/response_assignment.dart';
import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/response_assignment_repository.dart';
import 'package:my_first/repository/ickm/structure_penilaian_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  };
}

Future<Response> onGet(RequestContext ctx, String uuid) async {
  var start = DateTime.now();
  ResponseAssignmentRepository responseRepo = ctx.read<ResponseAssignmentRepository>();
  StructurePenilaianRepository spRepo = ctx.read<StructurePenilaianRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  try {  
    StructurePenilaianMitraDetails structureDetails = await spRepo.getDetailsByResponseUuid(uuid);
    Kegiatan kegiatan = await kegiatanRepo.getById(structureDetails.kegiatan_uuid);
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]) || authUser.username == structureDetails.penilai_username || authUser.username == (kegiatan.penanggung_jawab??""))){
      return RespHelper.forbidden();
    }
    var result = await responseRepo.generateResponseStructureWithAnswers(uuid);
    var end = DateTime.now();
    print("Selisih Waktu : ${end.difference(start)}");
    return Response.json(body: result);
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Occurred");
  }
}
