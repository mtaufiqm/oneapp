import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/hash_crypt_helper.dart';
import 'package:my_first/blocs/jwt_helper.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/roles.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return
    switch(context.request.method){
      HttpMethod.post => onPost(context),
      _ => Future.value(Response.json(statusCode: HttpStatus.methodNotAllowed))
    };
}


Future<Response> onPost(RequestContext context) async {
  var jsonCredentials = (await context.request.json() as Map).cast<String,String>();
  String? username = jsonCredentials["username"];
  String? password = jsonCredentials["password"];
  if(username == null || password == null){
    return Response.json(statusCode: HttpStatus.unauthorized,body: {
      "message":"Username/Password cannot be blank!"
    });
  } 
  MyConnectionPool myConnection = context.read<MyConnectionPool>();
  UserRepository userRepository = UserRepository(myConnection);
  User user;
  try{
    user = await userRepository.getById(username!);
  } catch(e){
    return Response.json(statusCode: HttpStatus.unauthorized,body: {
      "message":"Username Tidak Ditemukan"
    });
  }
  if(!HashCryptHelper.isEqual(hasedPass: user.pwd!, passInput:password!)){
    return RespHelper.message(statusCode: HttpStatus.badRequest,message: "Password Wrong!");
  }

  List<Roles> roles = await userRepository.getRolesByUserId(username);
  List<String> rolesString = roles.map((role){return role.description;}).toList();

  // THIS IS THE PAYLOAD
  // var payloadMap = {
  //   "username":username,
  //   "roles":rolesString    
  // };

  String token = JwtHelper.generator(username,rolesString);

  return Response.json(body: {
    "token":token
  });
  
}
