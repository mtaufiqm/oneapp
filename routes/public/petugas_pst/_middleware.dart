import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/petugas_pst/petugas_pst_repository.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<PetugasPstRepository>((ctx) {
    var conn = ctx.read<MyConnectionPool>();
    return PetugasPstRepository(conn);
  }));
}
