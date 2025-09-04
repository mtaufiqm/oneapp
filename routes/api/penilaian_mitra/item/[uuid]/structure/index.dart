import 'dart:developer';

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
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx, String uuid) async {
  KuesionerPenilaianRepository penilaianRepo = ctx.read<KuesionerPenilaianRepository>();
  StructurePenilaianRepository structureRepo = ctx.read<StructurePenilaianRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();

  try {
    KuesionerPenilaianMitraDetails penilaian = await penilaianRepo.getDetailsById(uuid); 

    bool isReturnAll = false;

    if((authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]) || authUser.username == (penilaian.kegiatan!.penanggung_jawab??""))){
      isReturnAll = true;
    } else if(authUser.isContainOne(["PEGAWAI"])){
      isReturnAll = false;
    } else {
      return RespHelper.forbidden();
    }
    List<StructurePenilaianMitraDetails> listObject = [];
    if(isReturnAll){
      listObject = await structureRepo.readDetailsByPenilaian(uuid);
    } else {
      listObject = await structureRepo.readDetailsByPenilaianAndPenilai(uuid, authUser.username);
    }
    return Response.json(body: listObject);
  } catch(e){
    log("Error Get Structure ${e}");
    return RespHelper.badRequest(message: "Error Get Structure");
  }
}

//this for insert new structure
//input is List<StructurePenilaianMitra>
Future<Response> onPost(RequestContext ctx, String uuid) async {
  KuesionerPenilaianRepository penilaianRepo = ctx.read<KuesionerPenilaianRepository>();
  StructurePenilaianRepository structureRepo = ctx.read<StructurePenilaianRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  try {
    KuesionerPenilaianMitraDetails penilaian = await penilaianRepo.getDetailsById(uuid);

    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KEPALA"]) || authUser.username == (penilaian.kegiatan!.penanggung_jawab??""))) {
      return RespHelper.forbidden();
    }
    var jsonMap = await ctx.request.json();
    if(!(jsonMap is List<dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }
    List<StructurePenilaianMitra> inputList = (jsonMap as List<dynamic>).map((el) {
      StructurePenilaianMitra structure = StructurePenilaianMitra.fromJson(el as Map<String,dynamic>);
      return structure;
    }).toList();
    List<StructurePenilaianMitra> successInput = await structureRepo.insertList(inputList);
    
    return Response.json(body: successInput);
  } catch(err){
    log("Error Update Structure ${err}");
    return RespHelper.badRequest(message: "Error Update Structure ${uuid}");
  }
}
