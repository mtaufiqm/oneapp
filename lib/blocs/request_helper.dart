import 'package:dart_frog/dart_frog.dart';

class RequestHelper {
  static Map<String,dynamic> parseAllQueryParam(Map<String,dynamic> masterParam, Request request) {
    Map<String,dynamic> queryParam = request.uri.queryParameters;
    Map<String,dynamic> returnMap = {};
    for(var key in masterParam.keys){
      //currently only string, int, double allowed in masterParam
      try {

        //check if string
        if(masterParam[key] is String){
          String keyValue = (queryParam[key] as String?)??"";
          if(keyValue.isEmpty){
            returnMap[key] = masterParam[key];
            continue;
          }
          returnMap[key] = keyValue;
          continue;
        }

        //check if int
        if(masterParam[key] is int){
          String keyValue = (queryParam[key] as String?)??"";
          if(keyValue.isEmpty){
            returnMap[key] = masterParam[key];
            continue;
          }
          returnMap[key] = int.tryParse(keyValue)??masterParam[key];
          continue;
        }

        //check if double
        if(masterParam[key] is double){
          String keyValue = (queryParam[key] as String?)??"";
          if(keyValue.isEmpty){
            returnMap[key] = masterParam[key];
            continue;
          }
          returnMap[key] = double.tryParse(keyValue)??masterParam[key];
          continue;
        }
      } catch(err){
        continue;
      }
    }
    return returnMap;
  }
}