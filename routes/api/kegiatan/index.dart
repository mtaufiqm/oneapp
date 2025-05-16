import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:postgres/postgres.dart';

Future<Response> onRequest(RequestContext context) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    HttpMethod.post => onPost(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


//return all kegiatan
Future<Response> onGet(RequestContext ctx) async {
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  
  //AUTHORIZATION
  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"]))){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try { 
    List<Kegiatan> listOfKegiatan = await kegiatanRepo.readAll();
    return Response.json(body: listOfKegiatan);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Occured");
  }
}


//create kegiatan
Future<Response> onPost(RequestContext ctx) async {
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  
  //AUTHORIZATION
  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"]))){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    var jsonBody = await ctx.request.json();
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }

    jsonBody["created_by"] = authUser.username;
    Kegiatan kegiatan = Kegiatan.fromJson(jsonBody as Map<String,dynamic>);
    Kegiatan created = await kegiatanRepo.create(kegiatan);
    return Response.json(body: created);
  } catch(e){
    print("Error : ${e}");
    return RespHelper.badRequest(message: "Error Occured ${e}");
  }
}
