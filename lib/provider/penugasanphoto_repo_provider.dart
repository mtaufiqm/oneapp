

import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/models/penugasan_photo.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/penugasan_photo_repository.dart';

PenugasanPhotoRepository? _photoRepo = null;

Middleware penugasanPhotoProvider() {
  return provider<PenugasanPhotoRepository>((ctx) {
    if(_photoRepo != null){
      return _photoRepo!;
    }
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    _photoRepo = PenugasanPhotoRepository(conn);
    return _photoRepo!;
  });
}