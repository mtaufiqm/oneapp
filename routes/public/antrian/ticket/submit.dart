import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/request_helper.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/antrian/antrian_jadwal.dart';
import 'package:my_first/models/antrian/antrian_ticket.dart';
import 'package:my_first/repository/antrian/antrian_jadwal_repository.dart';
import 'package:my_first/repository/antrian/antrian_ticket_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return (switch(context.request.method) {
    HttpMethod.post => onPost(context),
    _ => Future.value(RespHelper.methodNotAllowed()) 
  });
}


//need more implementations
Future<Response> onPost(RequestContext ctx) async {
  AntrianTicketRepository ticketRepo = await ctx.read<AntrianTicketRepository>();
  try {
    Map<String,dynamic> queryParam = RequestHelper.parseAllQueryParam({"API_KEY":"default"}, ctx.request);
    String API_KEY = queryParam["API_KEY"] as String;
    
    var jsonBody = jsonDecode(await ctx.request.body());
    if(!(jsonBody is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }

    AntrianTicket inputTicket = AntrianTicket.fromJson(jsonBody);
    inputTicket.qr_code = null;

    AntrianTicket result = await ticketRepo.submit(inputTicket);
    return Response.json(body: result);
  } catch(err){
    return RespHelper.badRequest(message: "Error : ${err}");
  }
}
