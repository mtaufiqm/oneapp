import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/pegawai_repository.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<PegawaiRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    PegawaiRepository pegawaiRepository = PegawaiRepository(conn);
    return pegawaiRepository;
  }));
}
