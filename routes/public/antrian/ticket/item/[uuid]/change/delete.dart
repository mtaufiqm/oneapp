import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/antrian/antrian_ticket.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/antrian/antrian_ticket_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.delete => onDelete(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onDelete(RequestContext context, String uuid) async {
  AntrianTicketRepository ticketRepo = context.read<AntrianTicketRepository>();
  User authUser = context.read<User>();
  try {
    AntrianTicketDetails ticketDetails = await ticketRepo.getDetailsById(uuid);
    if(!authUser.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI"])){
      return RespHelper.forbidden();
    }
    await ticketRepo.delete(uuid);
    return RespHelper.message(message:"success");
  } catch(err){
    return RespHelper.badRequest(message: "Error Occured ${err}");
  }
}
