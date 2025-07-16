import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/models/ickm/kuesioner_penilaian_mitra.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/repository/ickm/answer_assignment_repository.dart';
import 'package:my_first/repository/ickm/kuesioner_penilaian_repository.dart';
import 'package:my_first/repository/ickm/response_assignment_repository.dart';
import 'package:my_first/repository/ickm/structure_penilaian_repository.dart';
import 'package:my_first/repository/kegiatan_mitra_repository.dart';
import 'package:my_first/repository/kegiatan_repository.dart';
import 'package:my_first/repository/mitra_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<MitraRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return MitraRepository(conn);
  })).use(provider<KegiatanRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return KegiatanRepository(conn);
  })).use(provider<KegiatanMitraRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return KegiatanMitraRepository(conn);
  })).use(provider<KuesionerPenilaianRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return KuesionerPenilaianRepository(conn);
  })).use(provider<StructurePenilaianRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return StructurePenilaianRepository(conn);
  })).use(provider<ResponseAssignmentRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return ResponseAssignmentRepository(conn);
  })).use(provider<AnswerAssignmentRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return AnswerAssignmentRepository(conn);
  }));
}
