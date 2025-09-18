import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/pegawai_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  return switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  };
}

Future<Response> onGet(RequestContext ctx, String uuid) async {
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  KegiatanMitraRepository kmRepo = ctx.read<KegiatanMitraRepository>();
  PegawaiRepository pegawaiRepo = ctx.read<PegawaiRepository>();
  try {
    Kegiatan kegiatan = await kegiatanRepo.getById(uuid);
    List<KegiatanMitraRepository> list = [];
    return Response.json();
  } catch(err){
    print("Error ${err}");
    return RespHelper.badRequest(message: "Error Occured ${err}");
  }
}
