import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/repository/antrian/antrian_service_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  return (switch(context.request.method) {
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx) async {
  AntrianServiceRepository serviceRepo = ctx.read<AntrianServiceRepository>();
  try {
    var result = await serviceRepo.readAll();
    return Response.json(body: result);
  } catch(err){
    return RespHelper.badRequest(message: "${err}");
  }
}
