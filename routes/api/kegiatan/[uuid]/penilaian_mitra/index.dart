import 'package:dart_frog/dart_frog.dart';
import 'package:intl/intl.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/ickm/kuesioner_penilaian_mitra.dart';
import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/mitra.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/kuesioner_penilaian_repository.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/mitra_repository.dart';

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
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  KegiatanMitraRepository kegiatanMitraRepo = ctx.read<KegiatanMitraRepository>();
  KuesionerPenilaianRepository penilaianMitraRepo = ctx.read<KuesionerPenilaianRepository>();
  MitraRepository mitraRepo = ctx.read<MitraRepository>();
  User authUser = ctx.read<User>();

  try {
    Kegiatan kegiatan = await kegiatanRepo.getById(uuid);

    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA"]) || authUser.username == kegiatan.created_by)){
      return RespHelper.unauthorized();
    }

    //if penilaian_mitra has exists, return response error
    if(await penilaianMitraRepo.checkKuesionerPenilaianByKegiatan(uuid)){
      return RespHelper.badRequest(message: "Penilaian for this event has exists ${uuid}");
    }

    KuesionerPenilaianMitra object = KuesionerPenilaianMitra(
      kegiatan_uuid: kegiatan.uuid!, 
      title: "Penilaian Mitra Kegiatan ${kegiatan.name}", 
      description: "Penilaian Mitra Kegiatan ${kegiatan.description}",
      start_date: DateFormat("yyyy-MM-dd").format(DateTime.parse(kegiatan.start).add(Duration(days: 1))),
      end_date: DateFormat("yyyy-MM-dd").format(DateTime.parse(kegiatan.start).add(Duration(days: 10)))
    );

    List<KegiatanMitraBridge> mitra = await kegiatanMitraRepo.getByKegiatanId(kegiatan.uuid!);
    List<StructurePenilaianMitra> structurePenilaian = await Future.wait((mitra.map((el) async {
      Mitra mitra = await mitraRepo.getById(el.mitra_id);
      String status = el.status;    //PPL //PML   //KOSEKA
      return StructurePenilaianMitra(
        kuesioner_penilaian_mitra_uuid: "", 
        mitra_username: mitra.username, 
        survei_uuid: "",
      );
    }).toList()));

    object = await penilaianMitraRepo.create(object);
    return Response.json();
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Fail create Penilaian Mitra Kegiatan ${uuid}");
  }
}

Future<Response> onDelete(RequestContext context, String uuid) async {
  return Response.json();
}


Future<String> chooseSurvei(String role) async {
  return "Survei ID";
}