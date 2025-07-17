import 'dart:developer';
import 'dart:io';

import 'package:cron/cron.dart';
import 'package:intl/intl.dart';
import 'package:my_first/blocs/datetime_helper.dart';
import 'package:my_first/models/antrian/antrian_sesi.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

class AntrianBackgroundService {
  static Future<void> runUpsertJadwalInBackground() async {
    try {
      Cron cronJob = Cron();
      cronJob.schedule((Schedule.parse("22 1,3,20 * * *")), () async {
        try {
          Pool connectionPool = prepareConnectionPool();
          var result = await automaticInsertNewJadwal(connectionPool, 15);
          print("Success Insert ${result} Jadwal Antrian");
        } catch(err){
          print("Error ${err}");
        }
      });
    } catch(err) {
      print("Error Run CronJob ${err}");
    }
  }

  static Pool prepareConnectionPool() {
      String host = Platform.environment["dbhost"]??"103.85.117.69";
      String databaseName = Platform.environment["dbname"]??"myapp";
      String user = Platform.environment["dbuser"]??"postgres";
      String password = Platform.environment["dbpassword"]??"taufiq1729";
      Endpoint endpoint = Endpoint(host: host, database: databaseName,username: user,password: password);
      var conn = Pool.withEndpoints([endpoint],settings: PoolSettings(maxConnectionCount: 3,connectTimeout: Duration(seconds: 5),sslMode: SslMode.disable));
      return conn;
  }

    //insert two weeks new jadwal for future 
  static Future<int> automaticInsertNewJadwal(Pool connectionPool,int kuotaPerSesiPerDay) async {
    return connectionPool.runTx<int>((tx) async {
      List<DateTime> twoWeeksMore = [];

      //get current date
      DateTime currentDate = DatetimeHelper.parseMakassarTime(DatetimeHelper.getCurrentMakassarTime());
      twoWeeksMore.add(currentDate);

      //get all two weeks more days
      for(int i = 0; i < 14;i++){
        DateTime nextDay = currentDate.add(Duration(days: (i+1)));
        twoWeeksMore.add(nextDay);
      }

      //filter only workDays
      List<DateTime> workDays = twoWeeksMore.where((el) {
        if(el.weekday == 6 || el.weekday == 7){
          return false;
        }
        return true;
      }).toList();

      //get all sesi
      List<AntrianSesi> allSesi = [];
      var result1 = await tx.execute(r"SELECT * FROM antrian_sesi");
      for(var item in result1){
        AntrianSesi sesi = AntrianSesi.fromJson(item.toColumnMap());
        allSesi.add(sesi);
      }

      //count successful insert data
      int successCounter = 0;

      //upsert new antrian jadwal based two week work days
      for(var dateItem in workDays){
        try {
          for(var sesiItem in allSesi){
            String uuid = Uuid().v1();
            String date = DateFormat("yyyy-MM-dd").format(dateItem);
            var result2 = await tx.execute(r"INSERT INTO antrian_jadwal VALUES($1,$2,$3,$4) ON CONFLICT(date,sesi) DO NOTHING RETURNING uuid",parameters: [
              uuid,
              date,
              sesiItem.uuid!,
              kuotaPerSesiPerDay
            ]);
            if(result2.isNotEmpty){
              successCounter++;
            }
          }
        } catch(err){
          log("Error Insert Jadwal Date ${dateItem.toIso8601String()} ${err}");
          continue;
        }
      }
      return successCounter;
    });
  }
}