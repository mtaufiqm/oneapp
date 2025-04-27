import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/mitra.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/mitra_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String mitraId,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context, mitraId),
    HttpMethod.post => onPost(context,mitraId),
    HttpMethod.delete => onDelete(context, mitraId),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext ctx, String mitraId) async {
  MitraRepository mitraRepo = ctx.read<MitraRepository>();
  User authUser = ctx.read<User>();


  try{
    MitraWithKegiatan mitraWithKegiatan = await mitraRepo.getByIdWithKegiatan(mitraId);

    //AUTHORIZATION
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"]) || authUser.username == mitraWithKegiatan.mitra.username)){
      return RespHelper.unauthorized();
    }
    //AUTHORIZATION

    return Response.json(body: mitraWithKegiatan);
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Get Mitra Details : ${mitraId}");
  }
}

Future<Response> onPost(RequestContext ctx, String mitraId) async {
  MitraRepository mitraRepo = ctx.read<MitraRepository>();
  User authUser = ctx.read<User>();

  try{
    Mitra mitra = await mitraRepo.getById(mitraId);

    //AUTHORIZATION
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]) || authUser.username == mitra.username)){
      return RespHelper.unauthorized();
    }
    //AUTHORIZATION

    var jsonInput = await ctx.request.json();
    if(!(jsonInput is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }

    Mitra inputMitra = Mitra.fromJson(jsonInput as Map<String,dynamic>);
    inputMitra.mitra_id = mitraId;

    Mitra mitraUpdated = await mitraRepo.update(mitraId, inputMitra);

    return Response.json(body: mitra);
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Update Mitra Details : ${mitraId}");
  }
}

Future<Response> onDelete(RequestContext ctx, String mitraId) async {
  MitraRepository mitraRepo = ctx.read<MitraRepository>();
  User authUser = ctx.read<User>();

  //AUTHORIZATION
  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]))){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{

    //check mitra id existence
    try{
      Mitra mitra = await mitraRepo.getById(mitraId);
    } catch(ee){
      return RespHelper.badRequest(message: "There is No Mitra with ID : ${mitraId}");
    }

    //delete mitra
    await mitraRepo.delete(mitraId);
    return Response.json(body: "success delete mitra with id ${mitraId}");
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Update Mitra Details : ${mitraId}");
  }
}
