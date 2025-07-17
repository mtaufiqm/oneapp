import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:intl/intl.dart';
import 'package:my_first/blocs/datetime_helper.dart';
import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/antrian/antrian_jadwal.dart';
import 'package:my_first/models/antrian/antrian_ticket.dart';
import 'package:my_first/repository/antrian/antrian_ticket_repository.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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

Future<Response> onGet(RequestContext ctx, String uuid) async {
  AntrianTicketRepository ticketRepo = ctx.read<AntrianTicketRepository>();
  try {
    String pathLogo = "";
    if(Platform.isWindows){
      pathLogo = "logo_bps_luwu.png";
    } else if(Platform.isLinux){
      pathLogo = "/opt/oneapp/logo_bps_luwu.png";
    }
    File logo_file = File("${pathLogo}");
    print("File Exists : ${logo_file.existsSync()}");
    var listBytesLogo = logo_file.readAsBytesSync();
    pw.MemoryImage memoryLogo = pw.MemoryImage(listBytesLogo);

    AntrianTicketDetails ticketDetails = await ticketRepo.getDetailsById(uuid);
    var doc = pw.Document();
    var page = pw.Page(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.portrait,
      build: (ctx) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.SizedBox(
                  height: 80.0,
                  child: pw.Image(memoryLogo,fit: pw.BoxFit.contain)
                ),
                pw.SizedBox(height: 10.0)
              ]
            ),
            pw.SizedBox(height: 40.0),
            pw.Container(
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(20.0))
                ),
                child: pw.Padding(
                  padding: pw.EdgeInsets.all(20.0),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text("Nama :",style: pw.TextStyle(fontSize: 13.0,fontWeight: pw.FontWeight.bold)),
                        pw.Text("${ticketDetails.antrian_ticket_name}",style: pw.TextStyle(fontSize: 13.0,color: PdfColor.fromHex("#000000"))),
                        pw.SizedBox(height: 10.0),
                        pw.Text("Email :",style: pw.TextStyle(fontSize: 13.0,fontWeight: pw.FontWeight.bold)),
                        pw.Text("${ticketDetails.antrian_ticket_email}",style: pw.TextStyle(fontSize: 13.0)),
                        pw.SizedBox(height: 10.0),
                        pw.Text("Nomor. HP :",style: pw.TextStyle(fontSize: 13.0,fontWeight: pw.FontWeight.bold)),
                        pw.Text("${ticketDetails.antrian_ticket_no_hp}",style: pw.TextStyle(fontSize: 13.0)),
                        pw.SizedBox(height: 10.0),
                        pw.Text("Jenis Layanan :",style: pw.TextStyle(fontSize: 13.0,fontWeight: pw.FontWeight.bold)),
                        pw.Text("${ticketDetails.service_details?.antrian_service_description}",style: pw.TextStyle(fontSize: 13.0)),
                        pw.SizedBox(height: 10.0),
                        pw.Text("Jadwal :",style: pw.TextStyle(fontSize: 13.0,fontWeight: pw.FontWeight.bold)),
                        pw.Text("${DateFormat.yMEd().format(DatetimeHelper.parseMakassarTime(ticketDetails.jadwal_details!.antrian_jadwal_date))}",style: pw.TextStyle(fontSize: 13.0)),
                        pw.SizedBox(height: 10.0),
                        pw.Text("Sesi :",style: pw.TextStyle(fontSize: 13.0,fontWeight: pw.FontWeight.bold)),
                        pw.Text("${ticketDetails.jadwal_details!.sesi_details!.antrian_sesi_tag} - ${ticketDetails.jadwal_details!.sesi_details!.antrian_sesi_description}",style: pw.TextStyle(fontSize: 13.0)),
                        pw.SizedBox(height: 10.0)
                      ]
                  )
                )
              )
          ]
        );
      }
    );
    doc.addPage(page);
    doc.save();

    var documentBytes = await doc.save();
    return Response.bytes(
      body: documentBytes,
      headers: {"Content-Type": "application/octet-stream",'Content-Disposition':'attachment; filename="${ticketDetails.antrian_ticket_uuid}.pdf"'}
    );
  } catch(err){
    return RespHelper.badRequest(message: "Error Occured ${err}");
  }
}

