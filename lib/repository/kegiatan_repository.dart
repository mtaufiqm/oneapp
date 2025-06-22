import 'package:my_first/blocs/response_helper.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/mitra.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

class KegiatanRepository extends MyRepository<Kegiatan>{
  final MyConnectionPool connection;

  KegiatanRepository(this.connection);

  Future<void> delete(dynamic uuid) async{
    return this.connection.connectionPool.withConnection<void>((cnn) async{
      await cnn.runTx<void>((tx) async {
        await tx.execute(r'DELETE FROM kegiatan WHERE uuid = $1',parameters: [uuid as String]);
      });
      return;
    });
  }
  
  Future<List<Kegiatan>> readAll() async{
    return this.connection.connectionPool.withConnection<List<Kegiatan>>((conn) async {
      return conn.runTx((tx) async {
        Result result = await tx.execute('SELECT * FROM kegiatan ORDER BY "end" DESC');
        List<Kegiatan> listOfKegiatan = <Kegiatan>[];
        for(ResultRow i in result){
          Map<String,dynamic> mapRow = i.toColumnMap();
          Kegiatan kegiatan = Kegiatan.fromJson(mapRow);
          listOfKegiatan.add(kegiatan);
        }
        return listOfKegiatan;
      });
    });
  }

  Future<List<Kegiatan>> readAllByMitra(dynamic mitra_id) async {
    return await this.connection.connectionPool.runTx<List<Kegiatan>>((tx) async {
      Result result = await tx.execute(r"SELECT * FROM kegiatan_mitra_bridge kmb LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid WHERE kmb.mitra_id = $1",parameters: [
        mitra_id as String
      ]);
      List<Kegiatan> listObject = [];
      for(var item in result){
        Kegiatan kegiatan = Kegiatan.fromJson(item.toColumnMap());
        listObject.add(kegiatan);
      }
      return listObject;
    });
  }

  Future<KegiatanWithMitra> getByIdWithMitra(dynamic uuid) async {
    return await this.connection.connectionPool.runTx<KegiatanWithMitra>((tx) async {
      var result = await tx.execute(r"SELECT * FROM kegiatan WHERE uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is no data ${uuid as String}");
      }
      Kegiatan kegiatan = Kegiatan.fromJson(result.first.toColumnMap());
      List<Mitra> listOfMitra = [];
      var resultsMitra = await tx.execute(r"SELECT * FROM kegiatan_mitra_bridge kmb LEFT JOIN mitra mt ON kmb.mitra_id = mt.mitra_id WHERE kmb.kegiatan_uuid = $1",parameters: [
        uuid as String
      ]);
      for(var item in resultsMitra){
        Mitra mitra = Mitra.fromJson(item.toColumnMap());
        listOfMitra.add(mitra);
      }
      KegiatanWithMitra returnValue = KegiatanWithMitra(kegiatan: kegiatan, mitra: listOfMitra);
      return returnValue;
    });
  }
    // String? uuid,
    // String? name,
    // String? description,
    // String? start,
    // String? end,
    // String? monitoring_link,
    // bool? organic_involved,
    // int? organic_number,
    // bool? mitra_involved,
    // int? mitra_number,
    // String? created_by

  Future<Kegiatan> create(Kegiatan kegiatan) async {
    return this.connection.connectionPool.withConnection((conn) async{
      return conn.runTx<Kegiatan>((tx) async{
        kegiatan.uuid = Uuid().v1();
        Result result = await tx.execute(r'INSERT INTO kegiatan VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12) RETURNING uuid',
        parameters: [
          kegiatan.uuid,
          kegiatan.name,
          kegiatan.description,
          kegiatan.start,
          kegiatan.end,
          kegiatan.monitoring_link,
          kegiatan.organic_involved,
          kegiatan.organic_number,
          kegiatan.mitra_involved,
          kegiatan.mitra_number,
          kegiatan.created_by,
          kegiatan.penanggung_jawab
        ]);
        if(result.isEmpty){
          throw Exception("Error Create Kegiatan ${kegiatan.uuid}");
        }
        return kegiatan;
      });
    });
  }

    // String? uuid,
    // String? name,
    // String? description,
    // String? start,
    // String? end,
    // String? monitoring_link,
    // bool? organic_involved,
    // int? organic_number,
    // bool? mitra_involved,
    // int? mitra_number,
    // String? created_by,

  Future<Kegiatan> update(dynamic uuid,Kegiatan kegiatan) async{
    return this.connection.connectionPool.runTx<Kegiatan>((tx) async {
      var result = await tx.execute(r'UPDATE kegiatan SET name = $1, description = $2, "start" = $3, "end" = $4, monitoring_link = $5, organic_involved = $6, organic_number = $7, mitra_involved = $8, mitra_number = $9, created_by = $10, penanggung_jawab = $11 WHERE uuid = $12',
      parameters: [
        kegiatan.name,
        kegiatan.description,
        kegiatan.start,
        kegiatan.end,
        kegiatan.monitoring_link,
        kegiatan.organic_involved,
        kegiatan.organic_number,
        kegiatan.mitra_involved,
        kegiatan.mitra_number,
        kegiatan.created_by,
        kegiatan.penanggung_jawab,
        uuid as String
      ]);
      if(result.affectedRows < 1){
        throw Exception("There is no row updated!");
      }
      return kegiatan;
    });
  }

  Future<Kegiatan> getById(dynamic uuid) async{
    return this.connection.connectionPool.runTx((tx) async{
      Result hasil = await tx.execute(r'SELECT * FROM kegiatan WHERE uuid = $1',parameters: [uuid as String]);
      Kegiatan kegiatan;
      if(hasil.isEmpty){
        throw Exception("There is no Data ${uuid as String}");
      }
      var kegiatanMap = hasil.first.toColumnMap();
      kegiatan = Kegiatan.fromJson(kegiatanMap);
      return kegiatan;
    });
  }
}