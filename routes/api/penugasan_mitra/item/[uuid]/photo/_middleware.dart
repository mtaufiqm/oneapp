import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/penugasan_photo_repository.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<PenugasanPhotoRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    return PenugasanPhotoRepository(conn);
  }));
}
