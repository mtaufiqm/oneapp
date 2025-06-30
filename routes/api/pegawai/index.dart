import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/pegawai.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/pegawai_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    HttpMethod.post => onPost(context),
    _ => Future.value(RespHelper.methodNotAllowed()) 
  });
}


Future<Response> onGet(RequestContext ctx) async{
  PegawaiRepository pegawaiRepo = ctx.read<PegawaiRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","ADMIN_INVENTORIES","PEGAWAI"])){
    return RespHelper.forbidden();
  }
  //AUTHORIZATION


  try{
    List<Pegawai> list_object = await pegawaiRepo.readAll();
    return Response.json(body: list_object);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Fail To Get All Data");
  }
}

Future<Response> onPost(RequestContext ctx) async {
  PegawaiRepository pegawaiRepo = ctx.read<PegawaiRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    var jsonMap = await ctx.request.json();
    if(!(jsonMap is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }
    Pegawai pegawai = Pegawai.fromJson(jsonMap as Map<String,dynamic>);
    var result = await pegawaiRepo.create(pegawai);
    return Response.json(body: result.toJson());
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Occured");
  }
}
