import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

class RespHelper{
  static Response message({int statusCode = HttpStatus.ok,String? message, Map<String,Object> headers = const <String,Object>{}}){
    return Response.json(
      statusCode: statusCode,
      body: {
        "message":message
      },
      headers: headers
    );
  }
}