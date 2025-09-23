import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/provider/penugasanphoto_repo_provider.dart';
import 'package:my_first/repository/kegiatan_mitra_penugasan_repository.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/penugasan_history_repository.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<KegiatanMitraPenugasanRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return KegiatanMitraPenugasanRepository(conn);
  })).use(provider<PenugasanHistoryRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return PenugasanHistoryRepository(conn);
  })).use(penugasanPhotoProvider());
}
