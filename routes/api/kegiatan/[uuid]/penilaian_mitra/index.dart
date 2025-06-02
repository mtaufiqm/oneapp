import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/ickm/kuesioner_penilaian_mitra.dart';
import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/kuesioner_penilaian_repository.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    HttpMethod.post => onPost(context,uuid),
    HttpMethod.delete => onDelete(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext context, String uuid) async {
  return Response.json();
}

//create penilaian_mitra
Future<Response> onPost(RequestContext ctx, String uuid) async {
  return Response.json();
}

Future<Response> onDelete(RequestContext context, String uuid) async {
  return Response.json();
}


Future<String> chooseSurvei(String role) async {
  return "Survei ID";
}