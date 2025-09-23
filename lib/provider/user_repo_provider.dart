import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/user_repository.dart';

UserRepository? _userRepository = null;

Middleware userRepoProvider() {
  return provider((ctx) {
    if(_userRepository == null){
      MyConnectionPool conn = ctx.read<MyConnectionPool>();
      _userRepository = UserRepository(conn);
      return _userRepository!;
    }
    if(_userRepository != null){
      return _userRepository!;
    }
  });
} 