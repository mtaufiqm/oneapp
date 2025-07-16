import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/repository/antrian/antrian_ticket_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx, String uuid) async {
  try {
    AntrianTicketRepository ticketRepo = ctx.read<AntrianTicketRepository>();
    var item = await ticketRepo.getDetailsById(uuid);
    return Response.json(body: item);
  } catch(err){
    return RespHelper.badRequest(message: "Error Occured : ${err}");
  }
}
