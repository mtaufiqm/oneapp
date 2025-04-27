import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<KegiatanRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return KegiatanRepository(conn);
  })).use(provider<KegiatanMitraRepository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return KegiatanMitraRepository(conn);
  })).use(provider<KegiatanMitraPenugasanRepository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return KegiatanMitraPenugasanRepository(conn);
  }));
}
