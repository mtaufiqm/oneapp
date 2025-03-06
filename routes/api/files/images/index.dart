import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/files.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/files_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

Future<Response> onRequest(RequestContext context) async {
  
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    HttpMethod.post => onPost(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

//Current Implementation is Get All File, NEXT Filter it By Extension
Future<Response> onGet(RequestContext con) async {
  FilesRepository filesRepo = con.read<FilesRepository>();

  //AUTHORIZATION
  User user = con.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI","GET_IMAGES"])){
    return RespHelper.methodNotAllowed();
  }
  //AUTHORIZATION


  try{
    List<Files> list_object = await filesRepo.readAll();
    return Response.json(body: list_object);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Fail to Get All Data");
  }
}


//CONTINUE THISS
//CREATE FILES IMAGE
Future<Response> onPost(RequestContext ctx) async {
  print("ON POST EXECUTED");

  FilesRepository filesRepo = ctx.read<FilesRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","PEGAWAI","CREATE_FILES"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION



  try{
    var formData = await ctx.request.formData(); 
    var files = await formData.files["files"];
    if(files == null){
      return RespHelper.badRequest(message: "There is no Image File in Request Body");
    }
    String uuid = Uuid().v1();
    String file_name = files.name;
    String extension = p.extension(file_name);
    String location = "";
    List<int> file_bytes = await files.readAsBytes();
    if(file_bytes.length >= 1024 * 1024 * 2){
      return RespHelper.badRequest(message: "Image Size Exceeded 2 Mb!");
    }

    //DIRECTORY FOR Windows is in app folder files/images
    //DIRECTORY FOR Linus is in /opt/files/images
    String windows_dir = "files\\images";
    String linux_dir = "/opt/files/images";
    if(Platform.isWindows){
      Directory dirFile = Directory(windows_dir);
      if(!dirFile.existsSync()){
        await dirFile.create(recursive: true);
      }
      File file  = File("${windows_dir}\\${uuid}${extension}");
      await file.writeAsBytes(file_bytes);
      location = file.absolute.path;
    } else if(Platform.isLinux){
      Directory dirFile = Directory(linux_dir);
      if(!dirFile.existsSync()){
        await dirFile.create(recursive: true);
      }
      File file  = File("${linux_dir}/${uuid}${extension}");
      await file.writeAsBytes(file_bytes);
      location = file.absolute.path;
    } else{
      return RespHelper.badRequest(message: "Platform Not Supported");
    }
    // uuid,name,extension,location,created_at,created_by
    Files files_object = Files.fromJson({
      "uuid":uuid,
      "name":file_name,
      "extension":extension,
      "location":location,
      "created_at":DateTime.now().toIso8601String(),
      "created_by":user.username
    });
    var result = await filesRepo.create(files_object);
    return Response.json(body: result.toJson());
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Occured!");
  }
}
