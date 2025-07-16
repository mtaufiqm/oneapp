import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/antrian/antrian_jadwal_repository.dart';
import 'package:my_first/repository/antrian/antrian_service_repository.dart';
import 'package:my_first/repository/antrian/antrian_ticket_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<AntrianTicketRepository>((ctx) {
    var conn = ctx.read<MyConnectionPool>();
    return AntrianTicketRepository(conn);
  })).use(provider<AntrianJadwalRepository>((ctx) {
    var conn = ctx.read<MyConnectionPool>();
    return AntrianJadwalRepository(conn);
  })).use(provider<AntrianServiceRepository>((ctx) {
    var conn = ctx.read<MyConnectionPool>();
    return AntrianServiceRepository(conn);
  }));
}
