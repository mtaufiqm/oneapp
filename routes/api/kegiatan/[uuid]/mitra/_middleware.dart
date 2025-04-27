import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/mitra_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<MitraRepository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return MitraRepository(conn);
  })).use(provider<KegiatanMitraRepository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return KegiatanMitraRepository(conn);
  }));
}
