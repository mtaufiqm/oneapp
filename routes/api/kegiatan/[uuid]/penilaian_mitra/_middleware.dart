import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/repository/ickm/kuesioner_penilaian_repository.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/mitra_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<KuesionerPenilaianRepository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return KuesionerPenilaianRepository(conn);
  })).use(provider<KegiatanMitraRepository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return KegiatanMitraRepository(conn); 
  })).use(provider<MitraRepository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return MitraRepository(conn);
  }));
}
