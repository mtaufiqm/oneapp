import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/ickm/ickm_mitra_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<IckmMitraRepository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return IckmMitraRepository(conn);
  }));
}