import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/request_helper.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/antrian/antrian_ticket.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/antrian/antrian_ticket_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return switch(context.request.method) {
    HttpMethod.post => onPost(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  };
}


Future<Response> onPost(RequestContext context,String uuid) async {
  AntrianTicketRepository ticketRepo = context.read<AntrianTicketRepository>();
  User authUser = context.read<User>();
  try {
    AntrianTicketDetails ticketDetails = await ticketRepo.getDetailsById(uuid);
    if(!authUser.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI"])){
      return RespHelper.forbidden();
    }
    var jsonBody = await context.request.json();
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }
    int inputStatus = (jsonBody as Map<String,dynamic>)["status"] as int;
    int currentStatus = ticketDetails.status_details!.antrian_status_id;
    await ticketRepo.updateStatusOnlyByUuid(ticketDetails.antrian_ticket_uuid!, inputStatus);
    return RespHelper.message(message:"success");
  } catch(err){
    return RespHelper.badRequest(message: "Error Occured ${err}");
  }
}
