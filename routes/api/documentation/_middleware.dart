import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/documentation_repository.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:postgres/postgres.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<DocumentationRepository>((ctx){
    var conn = ctx.read<MyConnectionPool>();
    DocumentationRepository documentationRepo = DocumentationRepository(conn);
    return documentationRepo;
  }));
}
