import "package:dart_frog/dart_frog.dart";
import "package:dart_frog_auth/dart_frog_auth.dart";
import 'package:my_first/repository/myconnection.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;


final MyConnectionPool connection = MyConnectionPool();

Handler middleware(Handler handler){
  return handler.
  use(provider<MyConnectionPool>((context) => connection)).
  use(fromShelfMiddleware(shelf.corsHeaders(headers: {
    shelf.ACCESS_CONTROL_ALLOW_ORIGIN:"*",
    shelf.ACCESS_CONTROL_EXPOSE_HEADERS:"*"
  })));
}