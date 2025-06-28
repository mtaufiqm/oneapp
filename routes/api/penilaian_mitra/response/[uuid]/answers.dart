import 'dart:developer';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/ickm/response_assignment.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/answer_assignment_repository.dart';
import 'package:my_first/repository/ickm/response_assignment_repository.dart';
import 'package:my_first/repository/ickm/structure_penilaian_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    HttpMethod.post => onPost(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext ctx, String uuid) async {
  //need implementations
  //return all questions for this assignments
  return Response.json();

}

Future<Response> onPost(RequestContext ctx, String uuid) async {
  return Response.json();
}
