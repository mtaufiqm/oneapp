import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/repository/antrian/antrian_ticket_repository.dart';

Future<Response> onRequest(
  RequestContext context
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx) async {
  try {
    AntrianTicketRepository ticketRepo = ctx.read<AntrianTicketRepository>();
    var todayTicket = await ticketRepo.readAllTodayGroupBySesi();
    return Response.json(body: todayTicket);
  } catch(err){
    return RespHelper.badRequest(message: "Error Occured : ${err}");
  }
}
