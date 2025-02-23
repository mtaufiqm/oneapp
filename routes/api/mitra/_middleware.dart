import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/mitra_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {

  // TODO: implement middleware
  return handler.use(provider<MitraRepository>((ctx){ 
    MyConnectionPool connection = ctx.read<MyConnectionPool>();
    return MitraRepository(connection);})
  );
}
