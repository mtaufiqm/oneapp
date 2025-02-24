import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/inventories/categories_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<CategoriesRepository>((ctx){
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    CategoriesRepository catRepo = CategoriesRepository(conn);
    return catRepo;
  }));
}
