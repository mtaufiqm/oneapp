import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/provider/user_repo_provider.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/user_repository.dart';


//ADD USER REPOSITORY

Handler middleware(Handler handler) {

  // TODO: implement middleware
  return handler.use(userRepoProvider());
}
