import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/antrian/antrian_ticket.dart';
import 'package:my_first/repository/antrian/antrian_jadwal_repository.dart';
import 'package:my_first/repository/antrian/antrian_ticket_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx) async {
  AntrianTicketRepository ticketRepo = ctx.read<AntrianTicketRepository>();
  try {
    var object = await ticketRepo.readAllTicketCurrentSesi();
    return Response.json(body: object);
  } catch(err){
    return RespHelper.badRequest(message: "Error ${err}");
  }

}
