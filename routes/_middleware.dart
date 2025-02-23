import "package:dart_frog/dart_frog.dart";
import "package:dart_frog_auth/dart_frog_auth.dart";
import 'package:my_first/repository/myconnection.dart';


final MyConnectionPool connection = MyConnectionPool();

Handler middleware(Handler handler){
  return handler.use(provider<MyConnectionPool>((context) => connection));
}