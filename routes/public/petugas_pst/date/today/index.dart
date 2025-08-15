import 'package:dart_frog/dart_frog.dart';
import 'package:intl/intl.dart';
import 'package:my_first/blocs/datetime_helper.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/petugas_pst/petugas_pst.dart';
import 'package:my_first/repository/petugas_pst/petugas_pst_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext ctx) async {
  PetugasPstRepository petugasRepo = ctx.read<PetugasPstRepository>();

  try {
    String today = DateFormat("yyyy-MM-dd").format(DatetimeHelper.parseMakassarTime(DatetimeHelper.getCurrentMakassarTime()));
    PetugasPst petugas = await petugasRepo.getByDate(today);
    return Response.json(body: petugas);
  } catch(err){
    return RespHelper.badRequest(message: "Error Occured");
  }
}
