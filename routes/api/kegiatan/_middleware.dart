import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/mitra_repository.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/user_repository.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<KegiatanRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    KegiatanRepository kegiatanRepo = KegiatanRepository(conn);
    return kegiatanRepo;
  })).use(provider<UserRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    UserRepository userRepo = UserRepository(conn);
    return userRepo;
  }));
}
