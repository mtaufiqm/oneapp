import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/repository/inventories/stock_transaction_repository.dart';
import 'package:my_first/repository/myconnection.dart';

Handler middleware(Handler handler) {
  // TODO: implement middleware
  return handler.use(provider<StockTransactionRepository>((ctx) {
    MyConnectionPool conn = ctx.read<MyConnectionPool>();
    StockTransactionRepository stockRepo = StockTransactionRepository(conn);
    return stockRepo;
  }));
}
