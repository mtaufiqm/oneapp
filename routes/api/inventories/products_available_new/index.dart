import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/inventories/products.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/products_repository.dart';
import 'package:my_first/responses/products_available_stocks.dart';

Future<Response> onRequest(RequestContext context) async {
  return (switch(context.request.method){
    HttpMethod.get => onGet(context),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}


Future<Response> onGet(RequestContext ctx) async {
  ProductsRepository productsRepo = ctx.read<ProductsRepository>();
  User authUser = ctx.read<User>(); 
      
  //AUTHORIZATIONS
  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_INVENTORIES","PEGAWAI","GET_PRODUCTS"]))){
    return RespHelper.unauthorized();
  }
  //AUTHORIZATIONS
  try{
    List<ProductsAvailableStocks> listProducts = await productsRepo.getAllProductsWithAvailableStockNew();
    return Response.json(body: listProducts);
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Get List Data ${e}");
  }

}



