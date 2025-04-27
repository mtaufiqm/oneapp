import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/models/mitra.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/mitra_repository.dart';


Future<Response> onRequest(
  RequestContext context,
  String uuid,
  String mitraId,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid,mitraId),
    HttpMethod.post => onPost(context,uuid,mitraId),
    HttpMethod.delete => onDelete(context,uuid,mitraId),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

//read all penugasan for spesific kegiatan and mitra with grouped
Future<Response> onGet(RequestContext ctx, String uuid, String mitra_id) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  MitraRepository mitraRepo = ctx.read<MitraRepository>();
  User authUser = ctx.read<User>();

  try{

    Mitra mitra = await mitraRepo.getById(mitra_id);

    print("Mitra : ${mitra.username}");
    print("Auth User : ${authUser.username}");
    
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM","PEGAWAI"]) || authUser.username == mitra.username)){
      return RespHelper.unauthorized();
    }

    List<KegiatanMitraPenugasanGroup> listObject = await kmpRepo.readAllDetailsByKegiatanAndMitraGrouped(uuid, mitra_id);
    return Response.json(body:listObject);

  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message:"Error Occured");
  }
}


//CONTINUE THIS
//insert list penugasan
Future<Response> onPost(RequestContext ctx, String uuid, String mitra_id) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();

  try{
    Kegiatan kegiatan = await kegiatanRepo.getById(uuid);
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]) || authUser.username == kegiatan.created_by)){
      return RespHelper.unauthorized();
    }
    List<KegiatanMitraPenugasanDetails> listObject = await kmpRepo.readAllDetailsByKegiatanAndMitra(uuid, mitra_id);
    return Response.json(body:listObject);

  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message:"Error Occured");
  }
}


//delete all penugasan for spesific kegiatan and mitra
Future<Response> onDelete(RequestContext ctx, String uuid, String mitra_id) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>(); 
  try{
    Kegiatan kegiatan = await kegiatanRepo.getById(uuid);
    //AUTHORIZATION
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM"]) || authUser.username == kegiatan.created_by)){
      return RespHelper.unauthorized();
    }
    //AUTHORIZATION

    //delete kegiatan mitra penugasan by kegiatan and mitra
    await kmpRepo.deleteByKegiatanMitra(uuid, mitra_id);
    return RespHelper.message(message: "Success Delete Penugasan For Kegiatan ${uuid} and Mitra ${mitra_id}");
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Occured");
  }
}