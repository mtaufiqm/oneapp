import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/documentation.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/documentation_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    HttpMethod.post => onPost(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext con) async {
  DocumentationRepository documentationRepo = con.read<DocumentationRepository>();

  //AUTHORIZATION
  User user = con.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","PEGAWAI","GET_DOCUMENTATIONS"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION


  try{
    List<Documentation> list_object = await documentationRepo.readAll();
    return Response.json(body: list_object);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Fail to Get All Data");
  }
}

Future<Response> onPost(RequestContext ctx) async {
  DocumentationRepository documentationRepo = ctx.read<DocumentationRepository>();

  //AUTHORIZATION
  User user = ctx.read<User>();
  if(!user.isContainOne(["SUPERADMIN","ADMIN","CREATE_DOCUMENTATIONS"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    var jsonMap = await ctx.request.json();
    if(!(jsonMap is Map<String,dynamic>)){
      return RespHelper.badRequest(message: "Invalid JSON Body");
    }
    
    String now = DateTime.now().toIso8601String();
    jsonMap["created_at"] = now;
    jsonMap["updated_at"] = now;
    jsonMap["created_by"] = user.username;

    Documentation documentation = Documentation.fromJson(jsonMap as Map<String,dynamic>);
    var result = await documentationRepo.create(documentation);
    return Response.json(body: result);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Occured");
  }
}

