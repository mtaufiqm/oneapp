import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/repository/daerah_blok_sensus_repository.dart.dart';
import 'package:my_first/repository/daerah_tingkat_1_repository.dart';
import 'package:my_first/repository/daerah_tingkat_2_repository.dart';
import 'package:my_first/repository/daerah_tingkat_3_repository.dart';
import 'package:my_first/repository/daerah_tingkat_4_repository.dart';
import 'package:my_first/repository/daerah_tingkat_5_repository.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<KegiatanMitraPenugasanRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return KegiatanMitraPenugasanRepository(conn);
  })).use(provider<KegiatanMitraRepository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return KegiatanMitraRepository(conn);
  })).use(provider<DaerahTingkat1Repository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return DaerahTingkat1Repository(conn);
  })).use(provider<DaerahTingkat2Repository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return DaerahTingkat2Repository(conn);
  })).use(provider<DaerahTingkat3Repository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return DaerahTingkat3Repository(conn);
  })).use(provider<DaerahTingkat4Repository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return DaerahTingkat4Repository(conn);
  })).use(provider<DaerahTingkat5Repository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return DaerahTingkat5Repository(conn);
  })).use(provider<DaerahBlokSensusRepository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return DaerahBlokSensusRepository(conn);
  }));
}