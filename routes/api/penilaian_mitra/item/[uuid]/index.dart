import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/kuesioner_penilaian_repository.dart';
import 'package:my_first/repository/ickm/structure_penilaian_repository.dart';

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
  User authUser = ctx.read<User>();
  try {
    return Response.json();
  } catch(e){
    print("Error Get Kuesioner ${e}");
    return RespHelper.badRequest(message: "Error Get Kuesioner ${e}");
  }
}