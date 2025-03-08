import 'dart:io';
import 'dart:typed_data';

import 'package:dart_frog/dart_frog.dart';
import 'package:intl/intl.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/inventories/products.dart';
import 'package:my_first/models/inventories/stock_transactions.dart';
import 'package:my_first/models/pegawai.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/inventories/products_repository.dart';
import 'package:my_first/repository/inventories/stock_transaction_repository.dart';
import 'package:my_first/repository/pegawai_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as wp;

Future<Response> onRequest(
  RequestContext context,
  String uuid,
) async {
  // TODO: implement route handler
  return (switch(context.request.method){
    HttpMethod.get => onGet(context,uuid),
    _ => Future.value(RespHelper.methodNotAllowed())
  });
}

Future<Response> onGet(RequestContext ctx,String uuid) async {
  //IMPLEMENT THIS
  StockTransactionRepository transactionsRepo = ctx.read<StockTransactionRepository>();
  PegawaiRepository pegawaiRepo = ctx.read<PegawaiRepository>();
  ProductsRepository productsRepo = ctx.read<ProductsRepository>();

  User authUser = ctx.read<User>();
  if(!(authUser.isContainOne(["SUPERADMIN","ADMIN","ADMIN_REPOSITORIES"]))){
    return RespHelper.methodNotAllowed();
  }

  try{
    StockTransactions transactions = await transactionsRepo.getById(uuid);
    Products products = await productsRepo.getById(transactions.product_uuid);
    Pegawai transactionCreator = await pegawaiRepo.getByUsername(transactions.created_by);
    Pegawai admin = await pegawaiRepo.getByUsername(authUser.username);
    var result = await getBytesPdfTransactions(transactions, products, transactionCreator, admin);

    DateTime now = DateTime.now().toLocal();
    String fileName = "Transactions_${Uuid().v1()}.pdf";
    return Response.bytes(body:result,headers: {"Content-Type": "application/octet-stream",'Content-Disposition':'attachment; filename="${fileName}"'});
  } catch(e){
    print(e);
    return RespHelper.badRequest(message: "Error Occured");
  }
}



Future<Uint8List> getBytesPdfTransactions(StockTransactions transactions, Products products, Pegawai transactionCreator,Pegawai admin) async {
  File logo_file = File("logo_bps_luwu.png");
  print("File Exists : ${logo_file.existsSync()}");
  var listBytesLogo = logo_file.readAsBytesSync();
  wp.MemoryImage memoryLogo = wp.MemoryImage(listBytesLogo);

  //format last updated transactions (completed by admin)
  DateTime lastUpdatedDate = DateTime.parse(transactions.last_updated);
  String lastUpdatedFormatted = DateFormat.yMMMEd().format(lastUpdatedDate);
  

  wp.Document document = wp.Document();
  wp.Page firstPage = wp.Page(pageFormat: PdfPageFormat.a4,build: (ctx){
    return wp.Container(
      child: wp.Column(
        children: [
          wp.Row(
            children: [
              wp.SizedBox(
                height: 80.0,
                child: wp.Image(memoryLogo,fit: wp.BoxFit.contain)
              )
            ]
          ),
          wp.SizedBox(height: 0.0),
          wp.Row(
            mainAxisAlignment: wp.MainAxisAlignment.center,
            children: [
              wp.Text("Bukti Transaksi",style: wp.TextStyle(fontSize: 17.0,fontWeight: wp.FontWeight.bold)),
            ]
          ),
          wp.SizedBox(height: 20.0),
          wp.Row(
            children: [
              wp.RichText(text: wp.TextSpan(
                children: [
                  wp.TextSpan(text: "Tanggal Penerimaan"),
                  wp.TextSpan(text: " : ${lastUpdatedFormatted}",style: wp.TextStyle(fontWeight: wp.FontWeight.bold))
                ]
              ))
            ]
          ),
          wp.SizedBox(height: 5.0),
          wp.Table(
            border: wp.TableBorder.all(),
            children: [
              wp.TableRow(children: [
                wp.Padding(padding: wp.EdgeInsets.only(left: 5.0,right: 5.0),child: wp.Text("Nama Pemesan",style: wp.TextStyle(fontWeight: wp.FontWeight.bold))),
                wp.Padding(padding: wp.EdgeInsets.only(left: 5.0,right: 5.0),child: wp.Text("Nama Products",style: wp.TextStyle(fontWeight: wp.FontWeight.bold))),
                wp.Padding(padding: wp.EdgeInsets.only(left: 5.0,right: 5.0),child: wp.Text("Jumlah Pesanan",style: wp.TextStyle(fontWeight: wp.FontWeight.bold))),
                wp.Padding(padding: wp.EdgeInsets.only(left: 5.0,right: 5.0),child: wp.Text("Satuan",style: wp.TextStyle(fontWeight: wp.FontWeight.bold)))
              ],
              verticalAlignment: wp.TableCellVerticalAlignment.middle
              ),
              wp.TableRow(children: [
                wp.Padding(padding: wp.EdgeInsets.only(left: 5.0,right: 5.0),child: wp.Text("${transactionCreator.fullname}")),
                wp.Padding(padding: wp.EdgeInsets.only(left: 5.0,right: 5.0),child: wp.SizedBox(width: 150.0,child: wp.Text("${products.name}"))),
                wp.Padding(padding: wp.EdgeInsets.only(left: 5.0,right: 5.0),child: wp.Text("${transactions.quantity}")),
                wp.Padding(padding: wp.EdgeInsets.only(left: 5.0,right: 5.0),child: wp.Text("${products.unit}"))
              ]),
                ]
          ),
          wp.SizedBox(height: 100.0),
          wp.Row(
            mainAxisAlignment: wp.MainAxisAlignment.spaceBetween,
            children: [
              wp.Container(
                child: wp.Column(
                  crossAxisAlignment: wp.CrossAxisAlignment.center,
                  children: [
                    wp.Text("Pemesan",style: wp.TextStyle(fontWeight: wp.FontWeight.bold)),
                    wp.SizedBox(height: 30.0),
                    wp.Text("${transactionCreator.fullname}")
                  ]
                )
              ),
              wp.Container(
                child: wp.Column(
                  crossAxisAlignment: wp.CrossAxisAlignment.center,
                  children: [
                    wp.Text("Admin Inventories",style: wp.TextStyle(fontWeight: wp.FontWeight.bold)),
                    wp.SizedBox(height: 30.0),
                    wp.Text("${admin.fullname}")
                  ]
                )
              )
            ]
          )
        ]
      )
    );
  });
  document.addPage(firstPage);
  return await document.save();

}