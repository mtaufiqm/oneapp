import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/products_repository.dart';
import 'package:my_first/responses/products_available_stocks.dart';

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  return(switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx,String uuid) async {
  ProductsRepository productRepo = ctx.read<ProductsRepository>();

  //AUTHORIZATION
  User authUser = ctx.read<User>();
  if(!authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","PEGAWAI","GET_PRODUCTS"])){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATION

  try{
    ProductsAvailableStocks products = await productRepo.getProductsWithAvailableStockNew(uuid);
    return Response.json(body: products);

  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Get Data ${uuid}");

    
  }
}
