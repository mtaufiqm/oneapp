import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  return handler.use(provider<KegiatanMitraPenugasanRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return KegiatanMitraPenugasanRepository(conn);
  }));
}
