import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/models/penugasan_photo.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/penugasan_photo_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  return switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    HttpMethod.post => onPost(context,uuid),
    HttpMethod.delete => onDelete(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  };
}

Future<Response> onGet(RequestContext ctx, String uuid) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  PenugasanPhotoRepository photoRepo = ctx.read<PenugasanPhotoRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  try{
    KegiatanMitraPenugasanDetails objectDetails = await kmpRepo.getDetailsById(uuid);
    Kegiatan kegiatan = await kegiatanRepo.getById(objectDetails.kegiatan_uuid);
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM","PEGAWAI"]) || (kegiatan.created_by == authUser.username) || (objectDetails.mitra_username == authUser.username))){
      return RespHelper.forbidden();
    }
    PenugasanPhoto? photo = await photoRepo.getByKmpUuid(uuid);
    if(photo == null){
      return RespHelper.badRequest(message: "There is no Data");
    } else {
      if(photo.photo2_loc == null || photo.photo2_loc!.trim().isEmpty) {
        return RespHelper.badRequest(message: "There is no Data");
      }
      File photoFile = File(photo.photo2_loc!.trim());
      bool existanceData = photoFile.existsSync();
      if(!existanceData){
        return RespHelper.badRequest(message: "There is no Data");
      }
      List<int> bytesPhoto = photoFile.readAsBytesSync();
      return Response.bytes(
        body: bytesPhoto,
        headers: {
          "Content-Disposition":"attachment;filename=\"${photo!.uuid!}_photo2${photo!.photo2_ext!}\""
        }
      );
    }

    return Response.json(body: objectDetails);
  } catch(e){
    print("Error ${e}");
    return RespHelper.badRequest(message:"Error Occured");
  }
}

//upload or update foto
Future<Response> onPost(RequestContext ctx, String uuid) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  PenugasanPhotoRepository photoRepo = ctx.read<PenugasanPhotoRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  print(uuid);
  try {
    KegiatanMitraPenugasanDetails kmp = await kmpRepo.getDetailsById(uuid);
    Kegiatan kegiatan = await kegiatanRepo.getById(kmp.kegiatan_uuid);
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM"]) || (kegiatan.created_by == authUser.username) || (kmp.mitra_username == authUser.username))){
      print("FORBIDDEN ${authUser.username}");
      return RespHelper.forbidden();
    }

    //check if kmp (status : 1 - BELUM MULAI OR 3 - SELESAI), cannot upload photo
    if(kmp.status <= 0 ){
      return RespHelper.badRequest(message: "Assignment Belum Dimulai");
    }
    if(kmp.status >= 3){
      return RespHelper.badRequest(message: "Assignment Telah Selesai");
    }

    //check if penugasan_photo data exist;
    PenugasanPhoto? photo = await photoRepo.getByKmpUuid(uuid);

    //DIRECTORY FOR Windows is in app folder files/images
    //DIRECTORY FOR Linus is in /opt/files/images
    String windows_dir = "assignment\\images\\${kmp.kegiatan_uuid!}";
    String linux_dir = "/opt/files/assignment/${kmp.kegiatan_uuid!}";


    var formData = await ctx.request.formData();
    var files = await formData.files["files"];
    if(files == null){
      return RespHelper.badRequest(message: "There is no Image File in Request Body");
    }
    String photo_uuid = kmp.uuid!;
    String file_name = files.name;
    String extension = p.extension(file_name);
    String location = "";
    List<int> file_bytes = await files.readAsBytes();
    if(file_bytes.length >= 1024 * 1024 * 3){
      return RespHelper.badRequest(message: "Image Size Exceeded 3 Mb!");
    }

    //check if photo2 exists, delete old photo2 if there
    if((photo != null) && !(photo.photo2_loc == null || photo.photo2_loc!.trim().isEmpty)){
      File related_file = File("${photo.photo2_loc}");
      if(related_file.existsSync()){
        try {
          await related_file.delete();
        } catch(err){
          print("Error Delete File ${err}");
        } 
    }}

    if(Platform.isWindows){
      Directory dirFile = Directory(windows_dir);
      if(!dirFile.existsSync()){
        await dirFile.create(recursive: true);
      }
      File file  = File("${windows_dir}\\${photo_uuid}_photo2${extension}");
      await file.writeAsBytes(file_bytes);
      location = file.absolute.path;
    } else if(Platform.isLinux){
      Directory dirFile = Directory(linux_dir);
      if(!dirFile.existsSync()){
        await dirFile.create(recursive: true);
      }
      File file  = File("${linux_dir}/${photo_uuid}_photo2${extension}");
      await file.writeAsBytes(file_bytes);
      location = file.absolute.path;
    } else{
      return RespHelper.badRequest(message: "Platform Not Supported");
    }

    //if there is no photo, insert new data
    if(photo == null) {
      var result = await photoRepo.create(
        PenugasanPhoto(
            kmp_uuid: uuid,
            photo2_loc: location,
            photo2_ext: extension,
            last_updated: ""
          )
      );
      return Response.json(body: result);
    } else {
      photo.photo2_loc = location;
      photo.photo2_ext = extension;
      var result = await photoRepo.upsertByKmpUuid(photo_uuid,photo!);
      return Response.json(body: result);
    }
  } catch(err){
    return RespHelper.badRequest(message: "Error Occured ${err}");
  }
}


Future<Response> onDelete(RequestContext ctx, String uuid) async {
  KegiatanMitraPenugasanRepository kmpRepo = ctx.read<KegiatanMitraPenugasanRepository>();
  PenugasanPhotoRepository photoRepo = ctx.read<PenugasanPhotoRepository>();
  KegiatanRepository kegiatanRepo = ctx.read<KegiatanRepository>();
  User authUser = ctx.read<User>();
  print(uuid);
  try {
    KegiatanMitraPenugasanDetails kmp = await kmpRepo.getDetailsById(uuid);
    Kegiatan kegiatan = await kegiatanRepo.getById(kmp.kegiatan_uuid);
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_MITRA","KETUA_TIM"]) || (kegiatan.created_by == authUser.username) || (kmp.mitra_username == authUser.username))){
      return RespHelper.forbidden();
    }

    PenugasanPhoto? photo = await photoRepo.getByKmpUuid(kmp.uuid!);

    //check if photo1 exists, delete old photo1 if there
    if((photo != null) && !(photo.photo2_loc == null || photo.photo2_loc!.trim().isEmpty)){
      File related_file = File("${photo.photo2_loc}");
      if(related_file.existsSync()){
        try {
          await related_file.delete();
        } catch(err){
          return RespHelper.badRequest(message: "Failed Delete Photo 2");
        } 
    }}
    return RespHelper.message(message: "Success Delete Photo 2");
    
  } catch(err){
    return RespHelper.badRequest(message:"Error ${err}");
  }
}
