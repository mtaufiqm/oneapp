import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/ickm/kuesioner_penilaian_mitra.dart';
import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/kuesioner_penilaian_repository.dart';
import 'package:my_first/repository/ickm/structure_penilaian_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
  String structure,
) async {
  return (switch(context.request.method) {
    HttpMethod.get => onGet(context,uuid,structure),
    HttpMethod.post => onPost(context,uuid,structure),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext ctx, String uuid, String structure) async {
  KuesionerPenilaianRepository penilaianRepo = ctx.read<KuesionerPenilaianRepository>();
  StructurePenilaianRepository structureRepo = ctx.read<StructurePenilaianRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  try {
    KuesionerPenilaianMitra kpm = await penilaianRepo.getById(uuid);
    StructurePenilaianMitraDetails structureItem = await structureRepo.getDetailsByUuid(structure);
    Kegiatan kegiatan = await kegiatanRepo.getById(kpm.kegiatan_uuid);

    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI"]))){
      return RespHelper.forbidden();
    } 
    return Response.json();
  } catch(e){
    print("Error Get Kuesioner ${e}");
    return RespHelper.badRequest(message: "Error Get Kuesioner ${e}");
  }
}


//update structure
Future<Response> onPost(RequestContext ctx, String uuid, String structure) async {
  KuesionerPenilaianRepository penilaianRepo = ctx.read<KuesionerPenilaianRepository>();
  StructurePenilaianRepository structureRepo = ctx.read<StructurePenilaianRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  try {
    KuesionerPenilaianMitra kpm = await penilaianRepo.getById(uuid);
    StructurePenilaianMitraDetails structureItem = await structureRepo.getDetailsByUuid(structure);
    Kegiatan kegiatan = await kegiatanRepo.getById(kpm.kegiatan_uuid);

    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]) || (authUser.username == kegiatan.penanggung_jawab))){
      return RespHelper.forbidden();
    } 
    var jsonBody = await ctx.request.json();
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }

    StructurePenilaianMitra updateStructure = StructurePenilaianMitra.fromJson(jsonBody);
    updateStructure = await structureRepo.update(structure, updateStructure);
    return Response.json(
      body: updateStructure
    );
  } catch(e){
    print("Error Get Kuesioner ${e}");
    return RespHelper.badRequest(message: "Error Get Kuesioner ${e}");
  }
}
