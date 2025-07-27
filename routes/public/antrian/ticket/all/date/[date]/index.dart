import 'package:dart_frog/dart_frog.dart';
import 'package:intl/intl.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/antrian/antrian_ticket_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String date,
) async {
  // TODO: implement route handler
  return (switch(context.request.method) {
    HttpMethod.get => onGet(context,date),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext context,String date) async {
  AntrianTicketRepository ticketRepo = context.read<AntrianTicketRepository>();
  User authUser = context.read<User>();
  try {
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI"]))) {
      return RespHelper.forbidden();
    }
    DateTime selectedDate = DateTime.tryParse(date)??DateTime.now();
    var object = await ticketRepo.readAllByDateGroupBySesi(selectedDate);
    return Response.json(body: object);
  } catch(err) {
    return RespHelper.badRequest(message: "Error Occured ${err}");
  }
}
