import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';

Response onRequest(RequestContext context) {
  return RespHelper.message(message: "PONG");
}
