import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<KegiatanMitraPenugasanRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return KegiatanMitraPenugasanRepository(conn);
  }));
}
