import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/response_assignment_repository.dart';

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
  User authUser = ctx.read<User>();
  try {
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]))){
      return RespHelper.forbidden();
    }
    var result = await responseRepo.generateResponseStructure(uuid);
    var end = DateTime.now();
    print("Selisih Waktu : ${end.difference(start)}");
    return Response.json(body: result);
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Occured");
  }
}
