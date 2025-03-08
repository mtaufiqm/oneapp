import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/innovation_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<InnovationRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    InnovationRepository innovationRepo = InnovationRepository(conn);
    return innovationRepo;
  }));
}
