import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/repository/antrian/antrian_jadwal_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx) async {
  try {
    AntrianJadwalRepository jadwalRepo = ctx.read<AntrianJadwalRepository>();
    var mapObject = await jadwalRepo.readAllAvailableJadwalGroupByDate();
    return Response.json(body: mapObject);
  } catch(err){
    return RespHelper.badRequest(message: "Error Occured : ${err}");
  }
}
