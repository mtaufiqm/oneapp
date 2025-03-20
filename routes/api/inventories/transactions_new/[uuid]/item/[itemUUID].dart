import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/inventories/transactions.dart';
import 'package:my_first/models/inventories/transactions_item.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/transactions_item_repository.dart';
import 'package:my_first/repository/inventories/transactions_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
  String itemUUID,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid,itemUUID),
    HttpMethod.post => onPost(context,uuid,itemUUID),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


//NEED IMPLEMENTATIONS
Future<Response> onGet(RequestContext ctx, String uuid, String itemUUID) async {
  TransactionsRepository transactionsRepo = ctx.read<TransactionsRepository>();
  TransactionsItemRepository transactionsItemRepo = ctx.read<TransactionsItemRepository>();
  User authUser = ctx.read<User>();

  try{
    Transactions transactions = await transactionsRepo.getById(uuid);

    // AUTHORIZATION
    if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN INVENTORIES"]) || transactions.created_by == authUser.username)){
      return RespHelper.unauthorized();
    }
    // AUTHORIZATION

    TransactionsItem item = await transactionsItemRepo.getById(itemUUID);
    return Response.json(body: item);

  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Occured");
  }
}


//NEED IMPLEMENTATIONS
Future<Response> onPost(RequestContext ctx, String uuid, String itemUUID) async {
  return Response.json();
}
