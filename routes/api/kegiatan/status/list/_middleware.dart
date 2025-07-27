import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/kegiatan_status_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<KegiatanStatusRepository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return KegiatanStatusRepository(conn);
  }));
}
