import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/models/pegawai.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/pegawai_repository.dart';
import 'package:my_first/repository/user_repository.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<PegawaiRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    PegawaiRepository pegawaiRepo = PegawaiRepository(conn);
    return pegawaiRepo;
  })).use(provider<UserRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    UserRepository userRepo = UserRepository(conn);
    return userRepo;
  }));
}
