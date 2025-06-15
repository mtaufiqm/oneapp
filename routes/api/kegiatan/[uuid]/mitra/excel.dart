import 'package:dart_frog/dart_frog.dart';
import 'package:excel/excel.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/mitra.dart';
import 'package:my_first/models/mitra_role.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/mitra_repository.dart';
import 'package:uuid/uuid.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    HttpMethod.post => onPost(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


//get all mitra from spesific kegiatan
Future<Response> onGet(RequestContext ctx, String uuid) async {
  KegiatanMitraRepository kegiatanMitraRepo = ctx.read<KegiatanMitraRepository>();
  MitraRepository mitraRepo = ctx.read<MitraRepository>();
  User authUser = ctx.read<User>();

  try{
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM","PEGAWAI"]))){
      return RespHelper.unauthorized();
    }

    List<KegiatanMitraBridge> listKegiatanMitra = await kegiatanMitraRepo.getByKegiatanId(uuid);

    //get excel of listKegiatanMitra
    Excel outputExcel = await convertToExcel(listKegiatanMitra);
    List<int> excelBytes =  outputExcel.save()!;

    //filename
    String fileName = "${Uuid().v1()}.xlsx";

    return Response.bytes(body: excelBytes,headers: {
      "Content-Disposition":'attachment;filename="${fileName}"'
    });
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Occured");
  }
}


//insert mitra for spesific kegiatan or append it (EXCEL FILE)
/***
 
SHEET 1


COLUMN HEADER : mitra_id, status

 ***/

Future<Response> onPost(RequestContext ctx, String uuid) async {
  KegiatanMitraRepository kegiatanMitraRepo =  ctx.read<KegiatanMitraRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();

  try{
    Kegiatan kegiatan = await kegiatanRepo.getById(uuid);

    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM"]) || authUser.username == kegiatan.created_by)){
      return RespHelper.unauthorized();
    }

    var formData = await ctx.request.formData();
    var uploadedFile = formData.files["file"];
    if(uploadedFile == null){
      return RespHelper.badRequest(message: "There is no Uploaded File 'file'");
    }


    //verify uploaded file content type
    if(uploadedFile.contentType.mimeType != "application/vnd.ms-excel"){
      return RespHelper.badRequest(message: "Invalid Uploaded File. Must be Excel File (application/vnd.ms-excel)");
    }

    List<int> fileBytes = await uploadedFile.readAsBytes();

    Excel excelFile = Excel.decodeBytes(fileBytes);

    Sheet firstSheet = excelFile.sheets[excelFile.sheets.keys.first]!;
    var rows = firstSheet.rows;

    //
    List<KegiatanMitraBridge> listOfMitra = [];
    
    bool isFirst = true;

    //convert from excel rows to List Of Kegiatan Mitra Bridge
    //iterate each rows
    for(var item in rows){

      //skip for headers
      if(isFirst){
        isFirst = false;
        continue;
      }

      try{
        //must be have two columns, (mitra_id and status and pengawas/pemeriksa)
        if(item.length < 2){
          continue;
        }

        var mitra_data = item[0]!.value;

        var status_data = item[1]!.value;

        var pengawas_data = item[2]!.value;

        //if not one if mitra_role (PPL,PML,KOSEKA), it will Error
        if(!MitraRole.values.contains(status_data!.toString().trim().toUpperCase())){
          continue;
        }

        //skip it if there is null cell, pengawas data no need to check because can be null
        if(mitra_data == null || status_data == null){
          continue;
        }

        String mitra_id = mitra_data!.toString().trim();
        String status = status_data!.toString().toUpperCase().trim();
        String? pengawas = pengawas_data!.toString().trim().isEmpty?null:pengawas_data!.toString().trim();
        String kegiatan_uuid = kegiatan.uuid!;

        listOfMitra.add(KegiatanMitraBridge(kegiatan_uuid: kegiatan_uuid, mitra_id: mitra_id, status: status,pengawas: pengawas));
      } catch(e){
        print("Error ${e}");
      }
    }

    List<KegiatanMitraBridge> kegiatanMitra = await kegiatanMitraRepo.create(listOfMitra);
    
    //get excel of successful inserted
    Excel outputExcel = await convertToExcel(kegiatanMitra);
    List<int> excelBytes =  outputExcel.save()!;

    String fileName = "${Uuid().v1()}.xlsx";

    return Response.bytes(body: excelBytes,headers: {
      "Content-Disposition":'attachment;filename="${fileName}"'
    });
    
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message: "Error Occured");
  }
}



Future<Excel> convertToExcel(List<KegiatanMitraBridge> list) async {
  Excel excel = Excel.createExcel();
  Sheet firstSheet = excel.sheets[excel.sheets.keys.first]!;

  //insert headers
  //mitra_id and status

  List<CellValue> header = [
    TextCellValue("mitra_id"),
    TextCellValue("status")
  ];
  firstSheet.insertRowIterables(header, 0);

  for(var item in list){
    List<CellValue?> row  = [
      TextCellValue("${item.mitra_id}"),
      TextCellValue("${item.status}")
    ];
    firstSheet.appendRow(row);
  }
  return excel;
}
