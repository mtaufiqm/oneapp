import 'package:dart_frog/dart_frog.dart';
import 'package:intl/intl.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/ickm/kuesioner_penilaian_mitra.dart';
import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';
import 'package:my_first/models/ickm/survei.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/mitra.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/ickm/kuesioner_penilaian_repository.dart';
import 'package:my_first/repository/ickm/structure_penilaian_repository.dart';
import 'package:my_first/repository/ickm/survei_repository.dart';
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

//CONTINUE THIS
//create penilaian_mitra
Future<Response> onPost(RequestContext ctx, String uuid) async {
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  KegiatanMitraRepository kegiatanMitraRepo = ctx.read<KegiatanMitraRepository>();
  KuesionerPenilaianRepository penilaianMitraRepo = ctx.read<KuesionerPenilaianRepository>();
  StructurePenilaianRepository structurePenilaianRepo = ctx.read<StructurePenilaianRepository>();
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

    //create kuesioner_penilaian_mitra here.
    KuesionerPenilaianMitra createdKpm = await penilaianMitraRepo.create(object);


    //if there is no kegiatan.mode / null, just return success
    if(kegiatan.mode == null){
      return RespHelper.message(message:"SUCCESS CREATE Penilaian Only");
    }

    //get mitra from that spesific kegiatan
    List<KegiatanMitraBridgeMoreDetails> mitra = await kegiatanMitraRepo.getMoreDetailsByKegiatanId(kegiatan.uuid!);
    Map<String,Survei> surveiMap = {};

    //iterate over mitra to get Survei object
    for(var item in mitra){
      try {
        String roleMitra = item.status;
        String surveiType = "${roleMitra}_${kegiatan.mode}";

        //if surveiMap already contain surveyType, just continue it;
        if(surveiMap.containsKey(surveiType)){
          continue;
        }

        //if not try to get from db;
        Survei survei = await chooseSurvei(ctx, roleMitra, kegiatan.mode!);

        //fill surveiMap;
        surveiMap[surveiType] = survei;
      } catch(e) {
        print("Error get${e}");
      }
    }

    List<StructurePenilaianMitra> structurePenilaian = [];
    mitra.forEach((el) {
      String status = el.status;    //PPL //PML //KOSEKA
      String surveiType = "${el.status}_${kegiatan.mode}";
      Survei? selectedSurvei = surveiMap[surveiType];
      StructurePenilaianMitra structure = StructurePenilaianMitra(
        kuesioner_penilaian_mitra_uuid: createdKpm.uuid!, 
        mitra_username: el.mitra_username, 
        survei_uuid: (selectedSurvei?.uuid),
        penilai_username: el.pengawas_username
      );
      structurePenilaian.add(structure);
    });

    //if structure penilaian that want to insert isEmpty, just return KuesionerPenilaianMitraWithStructure object
    if(structurePenilaian.isEmpty){
      KuesionerPenilaianMitraWithStructure kpmWithStructure = KuesionerPenilaianMitraWithStructure(penilaian: object, structure: []);
      return Response.json(body: kpmWithStructure);
    }
    List<StructurePenilaianMitra> listCreatedStructure = await structurePenilaianRepo.insertList(structurePenilaian);

    KuesionerPenilaianMitraWithStructure kpmWithStructure = KuesionerPenilaianMitraWithStructure(penilaian: object, structure: listCreatedStructure);
    
    return Response.json(body: kpmWithStructure);
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Fail create Penilaian Mitra Kegiatan ${uuid}");
  }
}

Future<Response> onDelete(RequestContext context, String uuid) async {
  return Response.json();
}


Future<Survei> chooseSurvei(RequestContext ctx,String role,String mode,{int? version}) async {
  try {
    SurveiRepository surveiRepo = ctx.read<SurveiRepository>();
    //TYPE IS IN FORM "ROLE_MODE"   ex: PPL_PAPI/PPL_CAPI/PML_PAPI/PML_CAPI
    String type = "${role}_${mode}";
    return await surveiRepo.getByTypeAndVersion(type);
  } catch(err){
    throw Exception("Error Choose Survei By Role, Mode, and Version");
  }
}