import "dart:io";
import "package:dart_frog/dart_frog.dart";
import 'package:my_first/blocs/antrian/antrian_background_service.dart';
import 'package:my_first/blocs/datetime_helper.dart';
import "package:timezone/data/latest.dart" as tz;
import "package:timezone/standalone.dart" as tz;

//initialization only first time not hot reload
Future<void> init(InternetAddress ip, int port) async {
  //this initialization for sistem antrian project (background_service)
  await AntrianBackgroundService.runUpsertJadwalInBackground();
  print("Antrian Background Service has Executed");
}

Future<HttpServer> run(Handler handler,InternetAddress ip,int port) async {
  tz.initializeTimeZones();
  await DatetimeHelper.initInstance();
  return serve(handler, ip, port);
}