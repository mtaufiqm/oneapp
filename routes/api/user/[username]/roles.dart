import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/roles.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/user_repository.dart';

Future<Response> onRequest(RequestContext context,String username) async {
  return switch(context.request.method){
    HttpMethod.get => onGet(context,username),
    HttpMethod.post => onPost(context, username),
    _ => Future.value(RespHelper.message(statusCode: HttpStatus.methodNotAllowed,message: "Method Not Allowed"))
  };
}

Future<Response> onGet(RequestContext context,String username) async {
  User user = context.read<User>();
  UserRepository userRepository = context.read<UserRepository>();
  if(!((user.username == username) || (user.isContainOne(["ADMIN","SUPERADMIN","GET_ROLES"])))){
    return RespHelper.message(statusCode: HttpStatus.unauthorized,message: "Your Are Not Allowed");
  } 
  List<Roles> roles = await userRepository.getRolesByUserId(username);
  return Response.json(body:{
    "roles":roles
  });
}

Future<Response> onPost(RequestContext context,String username) async {
  var jsonBody = context.request.json() as Map<String,dynamic>;
  List<String> rolesBody = (jsonBody["roles"] as List).cast<String>();
  User user = context.read<User>();
  UserRepository userRepository = context.read<UserRepository>();

  //If not contain one of this roles, or set own roles will be fails;
  if(!(user.isContainOne(["ADMIN","SUPERADMIN","POST_ROLES"])) || user.username == username){
    return RespHelper.message(statusCode: HttpStatus.unauthorized,message: "Your Are Not Allowed");
  } 

  //Target User
  User targetUser = User(username: username);

  //roles of authenticated user  
  List<Roles> roles = await userRepository.getRolesByUserId(username);

  //if user that want to set contains superadmin, you cant set it,
  if(roles.contains("SUPERADMIN")){
    return RespHelper.message(statusCode: HttpStatus.unauthorized,message: "You Are Not Allowed set Roles of SUPERADMIN");
  }

  //ACTION : DELETE OLD USER ROLES
  await userRepository.deleteOldUserRoles(targetUser);


  //ADD : INSERT NEW ROLES FROM INPUT
  List<Roles> targetUserNewRoles = await userRepository.createUserRoles(targetUser, rolesBody.map((item) => Roles(description: item)).toList());

  return Response.json(body:{
    "roles":targetUserNewRoles
  });
}
