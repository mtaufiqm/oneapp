import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/inventories/products_repository.dart';
import 'package:my_first/repository/inventories/transactions_item_repository.dart';
import 'package:my_first/repository/inventories/transactions_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<TransactionsRepository>((ctx){
    var conn = ctx.read<MyConnectionPool>();
    return TransactionsRepository(conn);
  })).use(provider<TransactionsItemRepository>((ctx){
    var conn = ctx.read<MyConnectionPool>();
    return TransactionsItemRepository(conn);
  })).use(provider<ProductsRepository>((ctx) {
    var conn = ctx.read<MyConnectionPool>();
    return ProductsRepository(conn);
  }));
}
