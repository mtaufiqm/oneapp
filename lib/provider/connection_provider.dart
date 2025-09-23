import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/myconnection.dart';

MyConnectionPool? _conn = null;
Middleware connectionProvider() {
  return provider<MyConnectionPool>((ctx) {
    if(_conn == null){
      _conn = MyConnectionPool();
      return _conn!;
    } else {
      return _conn!;
    }
  });
}
