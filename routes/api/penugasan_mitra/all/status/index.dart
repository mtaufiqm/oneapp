import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext ctx) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","PEGAWAI"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{

    var queryParams = ctx.request.uri.queryParametersAll["status"]??[];
    List<int> statusList = [];
    queryParams.forEach((value){
      try {
        int status_item_int = int.parse(value);
        statusList.add(status_item_int);
      } catch(err){
        print("Error ${err}");
      }
    });

    //if there is no valid status query param return response error
    if(queryParams.length == 0){
      return RespHelper.badRequest(message: "Invalid Query Param, Ensure add 'status' param!");
    }

    var listObject = await kmpRepo.readAllDetailsByStatusGroupedByKegiatan(statusList);
    return Response.json(body: listObject);
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Occured ${e}");
  }
}
