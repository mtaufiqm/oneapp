import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:my_first/blocs/datetime_helper.dart';
import 'package:my_first/models/antrian/antrian_jadwal.dart';
import 'package:my_first/models/antrian/antrian_sesi.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';

class AntrianJadwalRepository extends MyRepository<AntrianJadwal> {
  MyConnectionPool conn;

  AntrianJadwalRepository(this.conn);

  Future<AntrianJadwal> getById(dynamic id) async {
    return this.conn.connectionPool.runTx<AntrianJadwal>((tx) async {
      var result = await tx.execute(r"SELECT * FROM antrian_jadwal WHERE uuid = $1",parameters: [id as String]);
      if(result.isEmpty){
        throw Exception("There is no Data with ID ${id as String}");
      }
      AntrianJadwal object = AntrianJadwal.fromJson(result.first.toColumnMap());
      return object;
    });
  }

  Future<AntrianJadwal> update(dynamic id, AntrianJadwal object) async {
    //there is no implementation for now
    return object;
  }

  // String? uuid;
  // String date;
  // String sesi;
  // int kuota;

  Future<AntrianJadwal> create(AntrianJadwal object) async {
    return this.conn.connectionPool.runTx<AntrianJadwal>((tx) async {
      String uuid = Uuid().v1();
      object.uuid;
      var result = await tx.execute(r"INSERT INTO antrian_jadwal VALUES($1,$2,$3,$4) RETURNING uuid",
      parameters: [
        uuid,
        object.date,
        object.sesi,
        object.kuota
      ]);
      if(result.isEmpty) {
        throw Exception("Failed to Insert Data");
      }
      return object;
    });
  }

  //return all jadwal
  Future<List<AntrianJadwal>> readAll() async {
    return this.conn.connectionPool.runTx<List<AntrianJadwal>>((tx) async {
      var result = await tx.execute(r"SELECT * FROM antrian_jadwal ORDER BY date DESC");
      List<AntrianJadwal> listObject = [];
      for(var item in result){
        AntrianJadwal object = AntrianJadwal.fromJson(item.toColumnMap());
        listObject.add(object);
      }
      return listObject;
    });
  }

  Future<Map<String,List<AntrianJadwalDetails>>> readAllAvailableJadwalGroupByDate() async {
    return this.conn.connectionPool.runTx<Map<String,List<AntrianJadwalDetails>>>((tx) async {
      String currentDate = DateFormat("yyyy-MM-dd").format(DatetimeHelper.parseMakassarTime(DatetimeHelper.getCurrentMakassarTime()));
      String query = 
r'''

SELECT

aj.uuid as antrian_jadwal_uuid,
aj.date as antrian_jadwal_date,
aj.kuota - COALESCE(count(att.jadwal),0) as antrian_jadwal_kuota,

ass.uuid as antrian_sesi_uuid,
ass.order as antrian_sesi_order,
ass.description as antrian_sesi_description,
ass.tag as antrian_sesi_tag,
ass.code as antrian_sesi_code,
ass.sesi_start as antrian_sesi_start,
ass.sesi_end as antrian_sesi_end

FROM antrian_jadwal aj

LEFT JOIN antrian_sesi ass
ON aj.sesi = ass.uuid

LEFT JOIN antrian_ticket att
ON aj.uuid = att.jadwal

WHERE aj.date >= $1

GROUP BY
aj.uuid,
aj.date,
ass.uuid,
ass.order,
ass.description,
ass.tag,
ass.code,
ass.sesi_start,
ass.sesi_end

ORDER BY aj.date ASC, ass.order ASC
''';

      var result = await tx.execute(query,parameters: [currentDate]);
  
      Map<String,List<AntrianJadwalDetails>> mapObject = {};
      for(var item in result){
        AntrianJadwalDetails object = AntrianJadwalDetails.fromJson(item.toColumnMap());
        AntrianSesiDetails sesi = AntrianSesiDetails.fromJson(item.toColumnMap());
        object.sesi_details = sesi;
        if(mapObject.containsKey(object.antrian_jadwal_date)){
          mapObject[object.antrian_jadwal_date]?.add(object);
          continue;
        }
        mapObject[object.antrian_jadwal_date] = [object];
      }
      return mapObject;
    });
  }


    Future<AntrianJadwalDetails> getDetailsByUuidWithRemainderKuota(dynamic jadwal_uuid) async {
    return this.conn.connectionPool.runTx<AntrianJadwalDetails>((tx) async {
      String query = 
r'''

SELECT

aj.uuid as antrian_jadwal_uuid,
aj.date as antrian_jadwal_date,
aj.kuota - COALESCE(count(att.jadwal),0) as antrian_jadwal_kuota,

ass.uuid as antrian_sesi_uuid,
ass.order as antrian_sesi_order,
ass.description as antrian_sesi_description,
ass.tag as antrian_sesi_tag,
ass.code as antrian_sesi_code,
ass.sesi_start as antrian_sesi_start,
ass.sesi_end as antrian_sesi_end

FROM antrian_jadwal aj

LEFT JOIN antrian_sesi ass
ON aj.sesi = ass.uuid

LEFT JOIN antrian_ticket att
ON aj.uuid = att.jadwal

WHERE aj.uuid = $1

GROUP BY
aj.uuid,
aj.date,
ass.uuid,
ass.order,
ass.description,
ass.tag,
ass.code,
ass.sesi_start,
ass.sesi_end

ORDER BY aj.date ASC, ass.order ASC
''';

      var result = await tx.execute(query,parameters: [jadwal_uuid as String]);
      if(result.isEmpty) {
        throw Exception("There is No Antrian Jadwal ${jadwal_uuid as String}");
      }
      AntrianJadwalDetails object = AntrianJadwalDetails.fromJson(result.first.toColumnMap());
      AntrianSesiDetails sesiDetails = AntrianSesiDetails.fromJson(result.first.toColumnMap());
      object.sesi_details = sesiDetails;
      return object;
    });
  }
  

  Future<void> delete(dynamic id) async {
    return this.conn.connectionPool.runTx<void>((tx) async {
      var result = await tx.execute(r"DELETE FROM antrian_jadwal WHERE uuid = $1",parameters: [id as String]);
      if(result.affectedRows <= 0) {
        throw Exception("Failed delete Data with ID ${id as String}");
      }
      return;
    });
  }
}