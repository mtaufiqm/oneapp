import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/files_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<FilesRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    FilesRepository filesRepo = FilesRepository(conn);
    return filesRepo;
  }));
}
