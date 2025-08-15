import 'dart:io';

import 'package:excel/excel.dart';
import 'package:my_first/blocs/hash_crypt_helper.dart';
import 'package:my_first/models/petugas_pst/petugas_pst.dart';
import 'package:my_first/models/user.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

Future<void> main() async {
  Pool poolConn = prepareConnection();
  String fileName = "InitData.xlsx";

  Excel excelFile = Excel.decodeBytes(File(fileName).readAsBytesSync());
  Sheet firstSheet = excelFile.sheets.values.first;
  var rows = firstSheet.rows;
  await poolConn.runTx((tx) async {
    for(int i = 0; i < rows.length; i++){
      if(i == 0){
        continue;
      }
      try {
        var row = rows[i];
        String petugas_name = row[0]!.value!.toString();
        String start_date = row[1]!.value!.toString();
        String end_date = row[2]!.value!.toString();
        String photo = row[3]!.value!.toString();

        print("LOG ${i} : 1");
        String uuid = Uuid().v1();
        PetugasPst petugas = PetugasPst(uuid: uuid, nama: petugas_name, start_date: start_date, end_date: end_date,photo: photo);
        var result = await tx.execute(r'INSERT INTO "petugas_pst" VALUES($1,$2,$3,$4,$5) RETURNING *',parameters: [
          petugas.uuid,
          petugas.nama,
          petugas.start_date,
          petugas.end_date,
          petugas.photo
        ]);

        if(result.isEmpty){
          print("Gagal Insert ${petugas.nama}");
        }

        print("Sukses Insert ${petugas.nama}");
      } catch(err){
        print("Error ${err}");
        continue;
      }
    }
  });
  print("Success");
}

Pool prepareConnection() {
    try{
      String host = Platform.environment["dbhost"]??"103.85.117.69";
      String databaseName = Platform.environment["dbname"]??"myapp";
      String user = Platform.environment["dbuser"]??"postgres";
      String password = Platform.environment["dbpassword"]??"taufiq1729";
      Endpoint endpoint = Endpoint(
        host: host, 
        database: databaseName,
        username: user,
        password: password
      );
      return Pool.withEndpoints(
        [endpoint],
        settings: PoolSettings(
          maxConnectionCount: 3,
          connectTimeout: Duration(seconds: 10),
          sslMode: SslMode.disable)
          );
    } catch(e){
      throw Exception(e);
    }
}