import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/kuesioner_mitra_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<KuesionerMitraRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    KuesionerMitraRepository kuesionerRepo = KuesionerMitraRepository(conn);
    return kuesionerRepo;
  })).use(provider<KegiatanRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    KegiatanRepository kegiatanRepo = KegiatanRepository(conn);
    return kegiatanRepo;
  }));
}
