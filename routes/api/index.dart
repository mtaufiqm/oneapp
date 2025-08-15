import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/user_repository.dart';
import "package:my_first/repository/myconnection.dart";

Future<Response> onRequest(RequestContext context) async {
  return Response.json(body:{
    "message":"Welcome To BPS Kabupaten Luwu Site."
  });
}
