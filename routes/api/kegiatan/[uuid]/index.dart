import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    HttpMethod.post => onPost(context,uuid),
    HttpMethod.delete => onDelete(context, uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


//GET Kegiatan With All Mitra Involved
Future<Response> onGet(RequestContext ctx, String uuid) async {
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  
  //AUTHORIZATION
  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI","MITRA"]))){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    KegiatanWithMitra kegiatanWithMitra = await kegiatanRepo.getByIdWithMitra(uuid);
    return Response.json(body: kegiatanWithMitra);
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Occured");
  }
}


//Update
Future<Response> onPost(RequestContext ctx, String uuid) async {
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  
  try{
    Kegiatan kegiatan = await kegiatanRepo.getById(uuid);

    //AUTHORIZATION
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]) || kegiatan.created_by == authUser.username)){
      return RespHelper.unauthorized();
    }
    //AUTHORIZATION

    var jsonBody = await ctx.request.json();
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }

    Kegiatan updatedKegiatan = Kegiatan.fromJson(jsonBody);
    updatedKegiatan.uuid = kegiatan.uuid;
    updatedKegiatan.created_by = kegiatan.created_by;
    Kegiatan result = await kegiatanRepo.update(uuid, updatedKegiatan);
    return Response.json(body: result);    

  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Occured");
  }
}


//Delete
Future<Response> onDelete(RequestContext ctx, String uuid) async {
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  
  try{
    Kegiatan kegiatan = await kegiatanRepo.getById(uuid);

    //AUTHORIZATION
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]) || kegiatan.created_by == authUser.username)){
      return RespHelper.unauthorized();
    }
    //AUTHORIZATION

    await kegiatanRepo.delete(uuid);
    return Response.json(body:"success delete");

  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Occured");
  }
}


