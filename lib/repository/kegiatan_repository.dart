import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

class KegiatanRepository extends MyRepository<Kegiatan>{
  final MyConnectionPool connection;

 KegiatanRepository(this.connection);

 Future<void> delete(dynamic kegiatanUuid) async{
    return this.connection.connectionPool.withConnection<void>((cnn) async{
      await cnn.runTx<void>((tx) async {
        await tx.execute(r'DELETE FROM kegiatan WHERE id = $1',parameters: [kegiatanUuid as String]);
      });
      return;
    });
  }
  
  Future<List<Kegiatan>> readAll() async{
    return this.connection.connectionPool.withConnection<List<Kegiatan>>((conn) async {
      return conn.runTx((tx) async {
        Result result = await tx.execute('SELECT * FROM kegiatan;');
        List<Kegiatan> listOfKegiatan = <Kegiatan>[];
        for(ResultRow i in result){
          Map<String,dynamic> mapRow = i.toColumnMap();
          Kegiatan kegiatan = Kegiatan.from(mapRow);
          listOfKegiatan.add(kegiatan);
        }
        return listOfKegiatan;
      });
    });
  }

  // "id" text PRIMARY KEY,
  // "name" text,
  // "description" text,
  // "start" date,
  // "last" date,
  // "monitoring_link" text,
  // "organic_involved" boolean,
  // "organic_number" integer,
  // "mitra_involved" boolean,
  // "mitra_number" integer,
  // "createdby" text


  Future<Kegiatan> create(Kegiatan kegiatan) async {
    return this.connection.connectionPool.withConnection((conn) async{
      return conn.runTx<Kegiatan>((tx) async{
        Uuid uuid = Uuid();
        String id = uuid.v1();
        Result result = await tx.execute(r'INSERT INTO kegiatan VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)',
        parameters: [
          id,
          kegiatan.name,
          kegiatan.description,
          kegiatan.start,
          kegiatan.last,
          kegiatan.monitoring_link,
          kegiatan.organic_involved,
          kegiatan.organic_number,
          kegiatan.mitra_involved,
          kegiatan.mitra_number,
          kegiatan.createdby
        ]);
        return kegiatan;
      });
    });
  }

  Future<Kegiatan> update(dynamic kegiatanId,Kegiatan kegiatan) async{
    return this.connection.connectionPool.runTx<Kegiatan>((tx) async {

      var result = await tx.execute(r"UPDATE kegiatan SET name = $1, description = $2, start = $3, last = $4, monitoring_link = $5, organic_involved = $6, organic_number = $7, mitra_involved = $8, mitra_number = $9, createdby = $10 WHERE id = $11",
      parameters: (kegiatan.toJson()..remove("id")).values.toList()..add(kegiatanId as String));
      return this.getById(kegiatanId);
    });
  }

  Future<Kegiatan> getById(dynamic kegiatanId) async{
    return this.connection.connectionPool.runTx((tx) async{
      Result hasil = await tx.execute(r'SELECT * FROM kegiatan WHERE id = $1',parameters: [kegiatanId]);
      Kegiatan kegiatan;
      var kegiatanMap = hasil.first.toColumnMap();
      kegiatan = Kegiatan.from(kegiatanMap);
      return kegiatan;
    });
  }

}