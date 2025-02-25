import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:excel/excel.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/mitra.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/mitra_repository.dart';
import 'package:my_first/repository/user_repository.dart';


// POST api/mitra
// create account mitra
Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.post => onPost(context),
    _ => Future.value(RespHelper.message(statusCode: HttpStatus.methodNotAllowed,message: "Method Not Allowed"))
  });
}


//CREATE MITRA
Future<Response> onPost(RequestContext context) async{
  
  User userAuth = context.read<User>();
  MitraRepository mitraRepo = context.read<MitraRepository>();

  //authorization
  if(!userAuth.isContainOne(["SUPERADMIN","ADMIN","CREATE_MITRA"])){
    return RespHelper.message(statusCode: HttpStatus.unauthorized,message:"You are Not Allowed");
  }


  var body = await context.request.json();
  if(!(body is Map<String,dynamic> || body is List)){
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Bad Request");
  }

  List<String> listSuccessId = [];

  if(body is Map<String,dynamic>){
    try{
        Mitra mitra = await mitraRepo.create(Mitra.from(body));
        listSuccessId.add(mitra.mitraId!);
    } catch(e){
      return RespHelper.message(statusCode: HttpStatus.badRequest);
    }
  }
  if(body is List){
    for(var item in body){
      try{
        Mitra mitra = await mitraRepo.create(Mitra.from(item as Map<String,dynamic>));
        listSuccessId.add(mitra.mitraId!);
      } catch(e){
        continue;
      }
    }
  }
  return Response.json(body: listSuccessId);
}


Future<Response> handleXlsxFile(RequestContext context) async{
  var formData = await context.request.formData();
  var uploadedExcel = formData.files["excel"];
  if(uploadedExcel == null){
    return Future.value(RespHelper.message(statusCode: HttpStatus.badRequest,message: "There is no Excel Data you Upload!"));
  }
  if(uploadedExcel.contentType.mimeType != "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"){
    return Future.value(RespHelper.message(statusCode: HttpStatus.badRequest,message: "Your Excel Extension is not Xlsx"));
  }
  var listBytes = await uploadedExcel.readAsBytes();
  
  //Excel Parse
  try{
    Excel excelFile = Excel.decodeBytes(listBytes);
    var sheet = excelFile.tables["Mitra"];
    if(sheet == null){
      return Future.value(RespHelper.message(statusCode: HttpStatus.badRequest,message: "There is no 'mitra' sheet. First Column must be email of 'pemeriksa', Second Column must be email of 'mitra', Third column must be Role of Mitra (PPL/PML)"));
    }
    var rows = sheet.rows;
    var rowIndex = 0;
    for(var row in rows){
      if(rowIndex == 0){
        continue;
      }

      //continue thiss
      String pemeriksa_username = "";
    }
    return Future.value(Response.json());
  } catch (e){
    return Future.value(RespHelper.message(statusCode: HttpStatus.badRequest,message: "ERROR EXCEL FILE!"));
  }
}
