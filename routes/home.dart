import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/datetime_helper.dart';

int counter = 0;

Response onRequest(RequestContext reqContext){
  return Response.json(body: {
    "message":"${DatetimeHelper.getCurrentMakassarTime()}"
  });
}