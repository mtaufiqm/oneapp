import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/transactions_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String username,
) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,username),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext ctx,String username) async {
  TransactionsRepository transactionsRepo = ctx.read<TransactionsRepository>();
  User authUser = ctx.read<User>();

  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","GET_TRANSACTIONS"]) || (authUser.username == username))){
    return RespHelper.unauthorized();
  }
  try{
    //read all username transactions
    var listObject = await transactionsRepo.readWithItemDetailsByUserCreator(username);
    return Response.json(body: listObject);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Occured");
  } 
}
