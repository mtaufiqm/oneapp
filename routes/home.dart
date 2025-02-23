import 'package:dart_frog/dart_frog.dart';

int counter = 0;

Response onRequest(RequestContext reqContext){
  return Response(body: "Home Project");
}