import 'package:intl/intl.dart';
import 'package:my_first/blocs/datetime_helper.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/models/penugasan_history.dart';
import 'package:my_first/models/penugasan_status.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:my_first/responses/kegiatan_mitra_penugasan_progress.dart';
import 'package:timezone/standalone.dart';
import 'package:uuid/uuid.dart';

class KegiatanMitraPenugasanRepository extends MyRepository<KegiatanMitraPenugasan>{
  MyConnectionPool conn;

  KegiatanMitraPenugasanRepository(this.conn);

  Future<KegiatanMitraPenugasan> getById(dynamic id) async {
    return this.conn.connectionPool.runTx<KegiatanMitraPenugasan>((tx) async {
      var result = await tx.execute(r"SELECT * FROM kegiatan_mitra_penugasan WHERE uuid = $1",parameters: [
        id as String
      ]);

      if(result.isEmpty){
        throw Exception("There is no Data ${id as String}");
      }

      KegiatanMitraPenugasan object = KegiatanMitraPenugasan.fromJson(result.first.toColumnMap());
      return object;
    });    
  }

  Future<KegiatanMitraPenugasanDetails> getDetailsById(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT kmp.uuid as uuid, k.uuid as kegiatan_uuid,k.name as kegiatan_name,m.mitra_id as mitra_id, m.fullname as mitra_name,m.username as mitra_username,kmp.code as code, kmp.group as group,kmp.group_type_id as group_type_id,kmp.group_desc as group_desc,kmp.description as description,kmp.unit as unit,ps.id as status,ps.description as status_desc,kmp.started_time as started_time, kmp.ended_time as ended_time,kmp.location_latitude as location_latitude,kmp.location_longitude as location_longitude,kmp.notes as notes, kmp.created_at as created_at, kmp.last_updated as last_updated FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid LEFT JOIN penugasan_status ps ON kmp.status = ps.id LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid LEFT JOIN mitra m ON kmb.mitra_id = m.mitra_id WHERE kmp.uuid = $1",parameters: [
        uuid as String
      ]);
      if(result.isEmpty){
        throw Exception("There is no Data ${uuid as String}");
      }
      KegiatanMitraPenugasanDetails object = KegiatanMitraPenugasanDetails.fromJson(result.first.toColumnMap());
      return object;
    });
  }

  Future<KegiatanMitraPenugasan> update(dynamic id, KegiatanMitraPenugasan object) async {
    return this.conn.connectionPool.runTx<KegiatanMitraPenugasan>((tx) async {
      object.uuid = id as String;

      var result = await tx.execute(r"UPDATE kegiatan_mitra_penugasan SET bridge_uuid = $1, code = $2, group = $3, group_type_id = $4, group_desc = $5, description = $6, unit = $7, status = $8, started_time = $9, ended_time = $10, location_latitude = $11, location_longitude = $12, notes = $13, created_at = $14, last_updated = $15 WHERE uuid = $16",parameters: [
          object.bridge_uuid,
          object.code,
          object.group,
          object.group_type_id,
          object.group_desc,
          object.description,
          object.unit,
          object.status,
          object.started_time,
          object.ended_time,
          object.location_latitude,
          object.location_longitude,
          object.notes,
          object.created_at,
          object.last_updated,
          object.uuid
      ]);

      //if no row affected throw error
      if(result.affectedRows < 1){
        throw Exception("Fail to Update Data");
      }
      return object;

    });
  }

  //Update Location Only
  Future<void> updateLocationOnly(String latitude,String longitude, dynamic id) async {
    return await this.conn.connectionPool.runTx<void>((tx) async {  
      String last_updated = DatetimeHelper.getCurrentMakassarTime();
      var result = await tx.execute(r"UPDATE kegiatan_mitra_penugasan SET location_latitude = $1, location_longitude = $2, last_updated = $3 WHERE uuid = $4",parameters: [
        latitude,
        longitude,
        last_updated,
        id as String
      ]);

      if(result.affectedRows < 1){
        throw Exception("Failed to Update ${id as String}");
      }
      return;
    });
  }

  Future<void> updateStatusAndNotes(int status, String started_time, String ended_time, String? notes, dynamic id) async {
    return await this.conn.connectionPool.runTx<void>((tx) async {
      String last_updated = DatetimeHelper.getCurrentMakassarTime();
      var result = await tx.execute(r"UPDATE kegiatan_mitra_penugasan SET status = $1, started_time = $2, ended_time = $3, notes = $4, last_updated = $5 WHERE uuid = $6",parameters: [
        status,
        started_time,
        ended_time,
        notes,
        last_updated,
        id as String
      ]);
      if(result.affectedRows < 1){
        throw Exception("Failed to Update");
      }

      //insert also to penugasan_history
      var uuid = Uuid().v1();
      var result2 = await tx.execute(r"INSERT INTO penugasan_history VALUES($1,$2,$3,$4,$5,$6)",parameters: [
        uuid,
        id,
        status,
        last_updated,
        null,
        null
      ]);
    });
  }

  Future<void> updateLocationAndStatusAndNotes(int status, String started_time, String ended_time, String? location_latitude, String? location_longitude, String? notes, dynamic penugasan_uuid) async {
    return await this.conn.connectionPool.runTx<void>((tx) async {
      String last_updated = DatetimeHelper.getCurrentMakassarTime();
      var result = await tx.execute(r"UPDATE kegiatan_mitra_penugasan SET status = $1, started_time = $2, ended_time = $3, location_latitude = $4, location_longitude = $5, notes = $6, last_updated = $7 WHERE uuid = $8",parameters: [
        status,
        started_time,
        ended_time,
        location_latitude,
        location_longitude,
        notes,
        last_updated,
        penugasan_uuid as String
      ]);
      if(result.affectedRows < 1){
        throw Exception("Failed to Update");
      }

      //insert also to penugasan_history
      var uuid = Uuid().v1();
      var result2 = await tx.execute(r"INSERT INTO penugasan_history VALUES($1,$2,$3,$4,$5,$6) returning uuid",parameters: [
        uuid,
        penugasan_uuid as String,
        status,
        last_updated,
        location_latitude??"",
        location_longitude??""
      ]);
      if(result2.isEmpty){
        throw Exception("Failed to Insert History");
      }
    });
  }

  //RESET STATUS
  Future<void> resetStatusAndLocation(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {      
      var result1 = await tx.execute(r"DELETE FROM penugasan_history WHERE penugasan_uuid = $1",parameters: [
        uuid as String
      ]);
      if(result1.affectedRows <= 0){
        throw Exception("Failed to Reset ${uuid as String}");
      }
      var last_updated = DatetimeHelper.getCurrentMakassarTime();
      var result2 = await tx.execute(r"UPDATE kegiatan_mitra_penugasan SET status = $1, started_time = $2, ended_time = $3, notes = $4, last_updated = $5 WHERE uuid = $6",parameters: [
        0,    //0: BELUM MULAI
        "",
        "",
        "",
        last_updated,
        uuid as String
      ]);
      if(result2.affectedRows <= 0){
        throw Exception("Failed to Reset ${uuid as String}");
      }
    });
  }

  //CREATE OBJECT
  Future<KegiatanMitraPenugasan> create(KegiatanMitraPenugasan object) async {
      return this.conn.connectionPool.runTx<KegiatanMitraPenugasan>((tx) async {
      object.uuid = Uuid().v1();

      var result = await tx.execute(r"INSERT INTO kegiatan_mitra_penugasan VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16) RETURNING uuid",parameters: [
          object.uuid,
          object.bridge_uuid,
          object.code,
          object.group,
          object.group_type_id,
          object.group_desc,
          object.description,
          object.unit,
          object.status,
          object.started_time,
          object.ended_time,
          object.location_latitude,
          object.location_longitude,
          object.notes,
          object.created_at,
          object.last_updated
      ]);

      //if no row affected throw error
      if(result.isEmpty){
        throw Exception("Fail to Insert Data");
      }
      return object;

    });  
  }

  //CREATE LIST OBJECT
  Future<List<KegiatanMitraPenugasan>> createList(List<KegiatanMitraPenugasan> list) async {
    return this.conn.connectionPool.runTx<List<KegiatanMitraPenugasan>>((tx) async {
      List<KegiatanMitraPenugasan> listOfObject = [];
      for(var item in list){
        try{
          item.uuid = Uuid().v1();
          var result = await tx.execute(r"INSERT INTO kegiatan_mitra_penugasan VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16) RETURNING uuid",parameters: [
              item.uuid,
              item.bridge_uuid,
              item.code,
              item.group,
              item.group_type_id,
              item.group_desc,
              item.description,
              item.unit,
              item.status,
              item.started_time,
              item.ended_time,
              item.location_latitude,
              item.location_longitude,
              item.notes,
              item.created_at,
              item.last_updated
          ]);
          //if no row affected throw error
          if(result.isEmpty){
            continue;
          }

          //add to list object
          listOfObject.add(item);
        } catch(e){
          print("Error ${e}");
          continue;
        }
      }  
      return listOfObject;
    });  
  }

  //this will get 100 last records, try other read methods for spesific.
  Future<List<KegiatanMitraPenugasan>> readAll() async {
    return this.conn.connectionPool.runTx<List<KegiatanMitraPenugasan>>((tx) async {
      var result = await tx.execute(r"SELECT * FROM kegiatan_mitra_penugasan LIMIT 100");
      List<KegiatanMitraPenugasan> listOfObject = [];

      for(var item in result){
        KegiatanMitraPenugasan object = KegiatanMitraPenugasan.fromJson(item.toColumnMap());
        listOfObject.add(object);
      }

      return listOfObject;
    });
  }

  //this will get 100 last records details, try other read methods for spesific.
  Future<List<KegiatanMitraPenugasanDetails>> readAllDetails() async {
    return this.conn.connectionPool.runTx<List<KegiatanMitraPenugasanDetails>>((tx) async {
      var result = await tx.execute(r"SELECT kmp.uuid as uuid, k.uuid as kegiatan_uuid,k.name as kegiatan_name,m.mitra_id as mitra_id, m.fullname as mitra_name,m.username as mitra_username,kmp.code as code, kmp.group as group,kmp.group_type_id as group_type_id,kmp.group_desc as group_desc,kmp.description as description,kmp.unit as unit,ps.id as status,ps.description as status_desc,kmp.started_time as started_time, kmp.ended_time as ended_time,kmp.location_latitude as location_latitude,kmp.location_longitude as location_longitude,kmp.notes as notes, kmp.created_at as created_at, kmp.last_updated as last_updated FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid LEFT JOIN penugasan_status ps ON kmp.status = ps.id LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid LEFT JOIN mitra m ON kmb.mitra_id = m.mitra_id LIMIT 100");
      List<KegiatanMitraPenugasanDetails> listOfObject = [];

      for(var item in result){
        KegiatanMitraPenugasanDetails object = KegiatanMitraPenugasanDetails.fromJson(item.toColumnMap());
        listOfObject.add(object);
      }

      return listOfObject;
    });
  }


/***
    String? uuid;
    String kegiatan_uuid;
    String kegiatan_name;
    String mitra_id;
    String mitra_name;
    String mitra_username;
    String code;
    String group;
    int group_type_id;
    String group_desc;
    String description;
    String unit;
    int status;
    String status_desc;
    String? started_time;
    String? ended_time;
    String? location_latitude;
    String? location_longitude;
    String? notes;
    String created_at;
    String last_updated; 
 **/

  Future<List<KegiatanMitraPenugasanDetails>> readAllDetailsByKegiatan(dynamic kegiatan_id) async {
    return this.conn.connectionPool.runTx<List<KegiatanMitraPenugasanDetails>>((tx) async {
      var result = await tx.execute(r"SELECT kmp.uuid as uuid, k.uuid as kegiatan_uuid,k.name as kegiatan_name,m.mitra_id as mitra_id, m.fullname as mitra_name,m.username as mitra_username,kmp.code as code, kmp.group as group,kmp.group_type_id as group_type_id,kmp.group_desc as group_desc,kmp.description as description,kmp.unit as unit,ps.id as status,ps.description as status_desc,kmp.started_time as started_time, kmp.ended_time as ended_time,kmp.location_latitude as location_latitude,kmp.location_longitude as location_longitude,kmp.notes as notes, kmp.created_at as created_at, kmp.last_updated as last_updated FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid LEFT JOIN penugasan_status ps ON kmp.status = ps.id LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid LEFT JOIN mitra m ON kmb.mitra_id = m.mitra_id WHERE kmb.kegiatan_uuid = $1",parameters: [
        kegiatan_id as String
      ]);

      List<KegiatanMitraPenugasanDetails> listDetails = [];
      for(var item in result){
        KegiatanMitraPenugasanDetails kmpDetails = KegiatanMitraPenugasanDetails.fromJson(item.toColumnMap());
        listDetails.add(kmpDetails);
      }
      return listDetails;
    });
  }

  Future<List<KegiatanMitraPenugasanDetails>> readAllDetailsByMitra(dynamic mitra_id) async {
    return this.conn.connectionPool.runTx<List<KegiatanMitraPenugasanDetails>>((tx) async {
      var result = await tx.execute(r"SELECT kmp.uuid as uuid, k.uuid as kegiatan_uuid,k.name as kegiatan_name,m.mitra_id as mitra_id, m.fullname as mitra_name,m.username as mitra_username,kmp.code as code, kmp.group as group,kmp.group_type_id as group_type_id,kmp.group_desc as group_desc,kmp.description as description,kmp.unit as unit,ps.id as status,ps.description as status_desc,kmp.started_time as started_time, kmp.ended_time as ended_time,kmp.location_latitude as location_latitude,kmp.location_longitude as location_longitude,kmp.notes as notes, kmp.created_at as created_at, kmp.last_updated as last_updated FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid LEFT JOIN penugasan_status ps ON kmp.status = ps.id LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid LEFT JOIN mitra m ON kmb.mitra_id = m.mitra_id WHERE kmb.mitra_id = $1",parameters: [
        mitra_id as String
      ]);

      List<KegiatanMitraPenugasanDetails> listDetails = [];
      for(var item in result){
        KegiatanMitraPenugasanDetails kmpDetails = KegiatanMitraPenugasanDetails.fromJson(item.toColumnMap());
        listDetails.add(kmpDetails);
      }
      return listDetails;
    });
  }

  Future<List<KegiatanMitraPenugasanDetails>> readAllDetailsByKegiatanAndMitra(dynamic kegiatan_id,dynamic mitra_id) async {
    return this.conn.connectionPool.runTx<List<KegiatanMitraPenugasanDetails>>((tx) async {
      var result = await tx.execute(r"SELECT kmp.uuid as uuid, k.uuid as kegiatan_uuid,k.name as kegiatan_name,m.mitra_id as mitra_id, m.fullname as mitra_name,m.username as mitra_username,kmp.code as code, kmp.group as group,kmp.group_type_id as group_type_id,kmp.group_desc as group_desc,kmp.description as description,kmp.unit as unit,ps.id as status,ps.description as status_desc,kmp.started_time as started_time, kmp.ended_time as ended_time,kmp.location_latitude as location_latitude,kmp.location_longitude as location_longitude,kmp.notes as notes, kmp.created_at as created_at, kmp.last_updated as last_updated FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid LEFT JOIN penugasan_status ps ON kmp.status = ps.id LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid LEFT JOIN mitra m ON kmb.mitra_id = m.mitra_id WHERE kmb.kegiatan_uuid = $1 AND kmb.mitra_id = $2",parameters: [
        kegiatan_id as String,
        mitra_id as String
      ]);

      List<KegiatanMitraPenugasanDetails> listDetails = [];
      for(var item in result){
        KegiatanMitraPenugasanDetails kmpDetails = KegiatanMitraPenugasanDetails.fromJson(item.toColumnMap());
        listDetails.add(kmpDetails);
      }
      return listDetails;
    });
  }

  Future<List<KegiatanMitraPenugasanGroup>> readAllDetailsByStatusGroupedByKegiatan(List<dynamic> status) async {
    return this.conn.connectionPool.runTx<List<KegiatanMitraPenugasanGroup>>((tx) async {
      int counter = 0;
      var sqlWhere = status.map((el){
        counter++;
        return "kmp.status = \$${counter}";
      }).toList().join(" OR ");
      var valueSqlWhere = status.map((el) {
        return el as int;
      }).toList();

      //CURRENTLY LIMIT IT TO 100 ROWS
      var response = await tx.execute("SELECT kmp.uuid as uuid, k.uuid as kegiatan_uuid,k.name as kegiatan_name,m.mitra_id as mitra_id, m.fullname as mitra_name,m.username as mitra_username,kmp.code as code, kmp.group as group,kmp.group_type_id as group_type_id,kmp.group_desc as group_desc,kmp.description as description,kmp.unit as unit,ps.id as status,ps.description as status_desc,kmp.started_time as started_time, kmp.ended_time as ended_time,kmp.location_latitude as location_latitude,kmp.location_longitude as location_longitude,kmp.notes as notes, kmp.created_at as created_at, kmp.last_updated as last_updated FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid LEFT JOIN penugasan_status ps ON kmp.status = ps.id LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid LEFT JOIN mitra m ON kmb.mitra_id = m.mitra_id WHERE # ORDER BY kmp.group ASC, kmp.code ASC LIMIT 100".replaceAll("#", "${sqlWhere}"),
      parameters: valueSqlWhere);
      Map<String,KegiatanMitraPenugasanGroup> mapGroup = {};
      for(var item in response){
        KegiatanMitraPenugasanDetails taskDetails = KegiatanMitraPenugasanDetails.fromJson(item.toColumnMap());
        if(mapGroup.containsKey("${taskDetails.kegiatan_uuid}")){
          mapGroup["${taskDetails.kegiatan_uuid}"]!.penugasan.add(taskDetails);
          continue;
        }
        Map<String,dynamic> group = {
          "kegiatan_uuid":taskDetails.kegiatan_uuid,
          "kegiatan_name":taskDetails.kegiatan_name,
        };
        mapGroup["${taskDetails.kegiatan_uuid}"] = KegiatanMitraPenugasanGroup(group: group , penugasan: []);
        mapGroup["${taskDetails.kegiatan_uuid}"]!.penugasan.add(taskDetails);
      }
      return mapGroup.values.toList();
    });
  }


//FUTURE IMPLEMENTATIONS ADD DATE FILTER FOR KEGIATAN, (ONLY NOT ENDED)
Future<List<KegiatanMitraPenugasanGroup>> readAllDetailsByMitraGroupedByKegiatan(dynamic mitra_id) async {
    return this.conn.connectionPool.runTx<List<KegiatanMitraPenugasanGroup>>((tx) async {

      //CURRENTLY LIMIT IT TO 100 ROWS
      var response = await tx.execute(r"SELECT kmp.uuid as uuid, k.uuid as kegiatan_uuid,k.name as kegiatan_name,m.mitra_id as mitra_id, m.fullname as mitra_name,m.username as mitra_username,kmp.code as code, kmp.group as group,kmp.group_type_id as group_type_id,kmp.group_desc as group_desc,kmp.description as description,kmp.unit as unit,ps.id as status,ps.description as status_desc,kmp.started_time as started_time, kmp.ended_time as ended_time,kmp.location_latitude as location_latitude,kmp.location_longitude as location_longitude,kmp.notes as notes, kmp.created_at as created_at, kmp.last_updated as last_updated FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid LEFT JOIN penugasan_status ps ON kmp.status = ps.id LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid LEFT JOIN mitra m ON kmb.mitra_id = m.mitra_id WHERE m.mitra_id = $1 ORDER BY kmp.group ASC, kmp.code",
      parameters: [mitra_id as String]);
      Map<String,KegiatanMitraPenugasanGroup> mapGroup = {};
      for(var item in response){
        KegiatanMitraPenugasanDetails taskDetails = KegiatanMitraPenugasanDetails.fromJson(item.toColumnMap());
        if(mapGroup.containsKey("${taskDetails.kegiatan_uuid}")){
          mapGroup["${taskDetails.kegiatan_uuid}"]!.penugasan.add(taskDetails);
          continue;
        }
        Map<String,dynamic> group = {
          "kegiatan_uuid":taskDetails.kegiatan_uuid,
          "kegiatan_name":taskDetails.kegiatan_name,
        };
        mapGroup["${taskDetails.kegiatan_uuid}"] = KegiatanMitraPenugasanGroup(group: group , penugasan: []);
        mapGroup["${taskDetails.kegiatan_uuid}"]!.penugasan.add(taskDetails);
      }
      return mapGroup.values.toList();
    });
  }


  //get all details by kegiatan and mitra, grouped by group
  Future<List<KegiatanMitraPenugasanGroup>> readAllDetailsByKegiatanAndMitraGrouped(dynamic kegiatan_id,dynamic mitra_id) async {
    return this.conn.connectionPool.runTx<List<KegiatanMitraPenugasanGroup>>((tx) async {
      var response = await tx.execute(r"SELECT kmp.uuid as uuid, k.uuid as kegiatan_uuid,k.name as kegiatan_name,m.mitra_id as mitra_id, m.fullname as mitra_name,m.username as mitra_username,kmp.code as code, kmp.group as group,kmp.group_type_id as group_type_id,kmp.group_desc as group_desc,kmp.description as description,kmp.unit as unit,ps.id as status,ps.description as status_desc,kmp.started_time as started_time, kmp.ended_time as ended_time,kmp.location_latitude as location_latitude,kmp.location_longitude as location_longitude,kmp.notes as notes, kmp.created_at as created_at, kmp.last_updated as last_updated FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid LEFT JOIN penugasan_status ps ON kmp.status = ps.id LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid LEFT JOIN mitra m ON kmb.mitra_id = m.mitra_id WHERE kmb.kegiatan_uuid = $1 AND kmb.mitra_id = $2 ORDER BY kmp.group ASC, kmp.code ASC",
      parameters: [
        kegiatan_id as String,
        mitra_id as String
      ]);
      Map<String,KegiatanMitraPenugasanGroup> mapGroup = {};
      for(var item in response){
        KegiatanMitraPenugasanDetails taskDetails = KegiatanMitraPenugasanDetails.fromJson(item.toColumnMap());
        if(mapGroup.containsKey("${taskDetails.group}")){
          mapGroup["${taskDetails.group}"]!.penugasan.add(taskDetails);
          continue;
        }
        Map<String,dynamic> group = {
          "group":taskDetails.group,
          "group_type_id":taskDetails.group_type_id,
          "group_desc":taskDetails.group_desc
        };
        mapGroup["${taskDetails.group}"] = KegiatanMitraPenugasanGroup(group: group , penugasan: []);
        mapGroup["${taskDetails.group}"]!.penugasan.add(taskDetails);
      }
      return mapGroup.values.toList();
    });
  }


  Future<void> delete(dynamic id) async {
    return this.conn.connectionPool.runTx<void>((tx) async {
      var result = await tx.execute(r"DELETE FROM kegiatan_mitra_penugasan WHERE uuid = $1",parameters: [
        id as String
      ]);
      if(result.affectedRows < 1){
        throw Exception("Failed Delete ${id as String}");
      }
      return;
    });
  }

  //delete all penugasan related to kegiatan and mitra
  Future<void> deleteByKegiatanMitra(dynamic kegiatan_uuid,dynamic mitra_id) async {
    return await this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM kegiatan_mitra_bridge WHERE kegiatan_uuid = $1 AND mitra_id = $2",parameters: [
        kegiatan_uuid as String,
        mitra_id as String
      ]);

      //if there is no relation
      if(result.isEmpty){
        throw Exception("There is no Relation Kegiatan ${kegiatan_uuid as String} and Mitra ${mitra_id as String}");
      }

      KegiatanMitraBridge kmb = KegiatanMitraBridge.fromJson(result.first.toColumnMap());
      
      var result2 = await tx.execute(r"DELETE FROM kegiatan_mitra_penugasan WHERE bridge_uuid = $1",parameters: [
        kmb.uuid
      ]);

    }); 
  }

  Future<KegiatanMitraPenugasanDetailsWithHistory> getDetailsWithHistoryByUuid(dynamic uuid) async {
    return this.conn.connectionPool.runTx<KegiatanMitraPenugasanDetailsWithHistory>((tx) async {
      var result = await tx.execute(r"SELECT kmp.uuid as uuid, k.uuid as kegiatan_uuid,k.name as kegiatan_name,m.mitra_id as mitra_id, m.fullname as mitra_name,m.username as mitra_username,kmp.code as code, kmp.group as group,kmp.group_type_id as group_type_id,kmp.group_desc as group_desc,kmp.description as description,kmp.unit as unit,ps.id as status,ps.description as status_desc,kmp.started_time as started_time, kmp.ended_time as ended_time,kmp.location_latitude as location_latitude,kmp.location_longitude as location_longitude,kmp.notes as notes, kmp.created_at as created_at, kmp.last_updated as last_updated FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid LEFT JOIN penugasan_status ps ON kmp.status = ps.id LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid LEFT JOIN mitra m ON kmb.mitra_id = m.mitra_id WHERE kmp.uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is No Data ${uuid}");
      }
      KegiatanMitraPenugasanDetails kmpDetails = KegiatanMitraPenugasanDetails.fromJson(result.first.toColumnMap());
      List<PenugasanHistoryDetails> history = [];
      var result2 = await tx.execute(r"SELECT ph.*, ps.description as status_description FROM penugasan_history ph LEFT JOIN penugasan_status ps ON ph.status = ps.id WHERE ph.penugasan_uuid = $1 ORDER BY ph.created_at ASC",parameters: [
        kmpDetails.uuid!
      ]);
      for(var item in result2){
        PenugasanHistoryDetails historyDetails = PenugasanHistoryDetails.fromJson(item.toColumnMap());
        history.add(historyDetails);
      }
      return KegiatanMitraPenugasanDetailsWithHistory(details: kmpDetails, history: history);
    });
  }

  //this return all penugasan that active today (exclude status:0 BELUM MULAI where it is inactive)
  Future<List<KegiatanMitraPenugasanDetailsWithHistory>> readAllDetailsByStatusActiveLastUpdatedToday() async {
    return this.conn.connectionPool.runTx<List<KegiatanMitraPenugasanDetailsWithHistory>>((tx) async {
      DateTime currentMakassateDateTime = TZDateTime.now(DatetimeHelper.makassarLocation);
      var dateformatted = DateFormat("yyyy-MM-dd").format(currentMakassateDateTime);

      List<KegiatanMitraPenugasanDetailsWithHistory> listObject = []; 

      var result = await tx.execute(r"SELECT kmp.uuid as uuid, k.uuid as kegiatan_uuid,k.name as kegiatan_name,m.mitra_id as mitra_id, m.fullname as mitra_name,m.username as mitra_username,kmp.code as code, kmp.group as group,kmp.group_type_id as group_type_id,kmp.group_desc as group_desc,kmp.description as description,kmp.unit as unit,ps.id as status,ps.description as status_desc,kmp.started_time as started_time, kmp.ended_time as ended_time,kmp.location_latitude as location_latitude,kmp.location_longitude as location_longitude,kmp.notes as notes, kmp.created_at as created_at, kmp.last_updated as last_updated FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid LEFT JOIN penugasan_status ps ON kmp.status = ps.id LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid LEFT JOIN mitra m ON kmb.mitra_id = m.mitra_id WHERE to_date(kmp.last_updated, 'YYYY-MM-DD') = $1 AND kmp.status != 0",parameters: [
        dateformatted
      ]);

      if(result.isEmpty){
        return listObject;
      }

      for(var item in result){
          // String? uuid;
          // String penugasan_uuid;
          // int status;
          // String status_description;
          // String created_at;
        try {
          KegiatanMitraPenugasanDetails kmpDetailsItem = KegiatanMitraPenugasanDetails.fromJson(item.toColumnMap());
          List<PenugasanHistoryDetails> history = [];
          var result1 = await tx.execute(r"SELECT ph.*,ps.description as status_description FROM penugasan_history ph LEFT JOIN penugasan_status ps ON ph.status = ps.id WHERE ph.penugasan_uuid = $1",parameters: [kmpDetailsItem.uuid!]);
          result1.forEach((el) {
            PenugasanHistoryDetails phDetails = PenugasanHistoryDetails.fromJson(el.toColumnMap());
            history.add(phDetails);
          });
          KegiatanMitraPenugasanDetailsWithHistory kmpHistory = KegiatanMitraPenugasanDetailsWithHistory(
            details: kmpDetailsItem, 
            history: history
            );
          
          listObject.add(kmpHistory);
        } catch(e) {
          print("Error ${e}");
          continue;
        }
      }
      return listObject;
    });
  }

  Future<List<KegiatanMitraPenugasanGroup>> readAllDetailsByHistoryStatusAndHistoryUpdateGroupedByMitra(String date) async {
    return this.conn.connectionPool.runTx<List<KegiatanMitraPenugasanGroup>>((tx) async {
      var result = await tx.execute(r"SELECT kmp.uuid as uuid, k.uuid as kegiatan_uuid,k.name as kegiatan_name,m.mitra_id as mitra_id, m.fullname as mitra_name,m.username as mitra_username,kmp.code as code, kmp.group as group,kmp.group_type_id as group_type_id,kmp.group_desc as group_desc,kmp.description as description,kmp.unit as unit,ps.id as status,ps.description as status_desc,kmp.started_time as started_time, kmp.ended_time as ended_time,kmp.location_latitude as location_latitude,kmp.location_longitude as location_longitude,kmp.notes as notes, kmp.created_at as created_at, kmp.last_updated as last_updated FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid LEFT JOIN penugasan_status ps ON kmp.status = ps.id LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid LEFT JOIN mitra m ON kmb.mitra_id = m.mitra_id WHERE kmp.uuid IN (SELECT ph.penugasan_uuid FROM penugasan_history ph WHERE ph.status != 0 AND to_date(ph.created_at,'YYYY-MM-DD') = $1) ORDER BY kmb.mitra_id, kmb.kegiatan_uuid, kmp.group, kmp.last_updated DESC",parameters: [
        date
      ]);
      Map<String,KegiatanMitraPenugasanGroup> mapObject = {};
      for(var item in result){
        KegiatanMitraPenugasanDetails kmpDetails = KegiatanMitraPenugasanDetails.fromJson(item.toColumnMap());
        if(mapObject.containsKey(kmpDetails.mitra_id)){
          mapObject[kmpDetails.mitra_id]!.penugasan.add(kmpDetails);
          continue;
        }
        Map<String,dynamic> group_item = {
          "mitra_id":kmpDetails.mitra_id,
          "mitra_name":kmpDetails.mitra_name,
          "mitra_username":kmpDetails.mitra_username
        };
        mapObject[kmpDetails.mitra_id] = KegiatanMitraPenugasanGroup(group: group_item, penugasan: [kmpDetails]);
        continue;
      }
      return mapObject.values.toList();
    });
  }

  Future<List<KegiatanMitraPenugasanGroup>> readAllDetailsByHistoryStatusAndHistoryUpdateGroupedByKegiatan(String date) async {
    return this.conn.connectionPool.runTx<List<KegiatanMitraPenugasanGroup>>((tx) async {
      var result = await tx.execute(r"SELECT kmp.uuid as uuid, k.uuid as kegiatan_uuid,k.name as kegiatan_name,m.mitra_id as mitra_id, m.fullname as mitra_name,m.username as mitra_username,kmp.code as code, kmp.group as group,kmp.group_type_id as group_type_id,kmp.group_desc as group_desc,kmp.description as description,kmp.unit as unit,ps.id as status,ps.description as status_desc,kmp.started_time as started_time, kmp.ended_time as ended_time,kmp.location_latitude as location_latitude,kmp.location_longitude as location_longitude,kmp.notes as notes, kmp.created_at as created_at, kmp.last_updated as last_updated FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid LEFT JOIN penugasan_status ps ON kmp.status = ps.id LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid LEFT JOIN mitra m ON kmb.mitra_id = m.mitra_id WHERE kmp.uuid IN (SELECT ph.penugasan_uuid FROM penugasan_history ph WHERE ph.status != 0 AND to_date(ph.created_at,'YYYY-MM-DD') = $1) ORDER BY kmb.kegiatan_uuid, kmb.mitra_id, kmp.group, kmp.last_updated DESC",parameters: [
        date
      ]);
      Map<String,KegiatanMitraPenugasanGroup> mapObject = {};
      for(var item in result){
        KegiatanMitraPenugasanDetails kmpDetails = KegiatanMitraPenugasanDetails.fromJson(item.toColumnMap());
        if(mapObject.containsKey(kmpDetails.kegiatan_uuid)){
          mapObject[kmpDetails.kegiatan_uuid]!.penugasan.add(kmpDetails);
          continue;
        }
        Map<String,dynamic> group_item = {
          "kegiatan_uuid":kmpDetails.kegiatan_uuid,
          "kegiatan_name":kmpDetails.kegiatan_name
        };
        mapObject[kmpDetails.kegiatan_uuid] = KegiatanMitraPenugasanGroup(group: group_item, penugasan: [kmpDetails]);
        continue;
      }
      return mapObject.values.toList();
    });
  }

  Future<List<KegiatanMitraPenugasanByMitraProgress>> getProgressKegiatan(dynamic kegiatan_uuid) async {
    return this.conn.connectionPool.runTx<List<KegiatanMitraPenugasanByMitraProgress>>((tx) async {
      List<KegiatanMitraPenugasanByMitraProgress> listObject = [];

      var result = await tx.execute(r"SELECT * FROM penugasan_status");
      List<PenugasanStatus> listStatus = result.map((el) {
        return PenugasanStatus.fromJson(el.toColumnMap());
      }).toList();

      var result2 = await tx.execute(r"SELECT kmb.uuid as uuid, m.mitra_id as mitra_id, m.fullname as mitra_name, m.username as mitra_username, k.uuid as kegiatan_uuid, k.name as kegiatan_name, k.description as kegiatan_desc FROM kegiatan_mitra_bridge kmb LEFT JOIN mitra m ON m.mitra_id = kmb.mitra_id LEFT JOIN kegiatan k ON k.uuid = kmb.kegiatan_uuid WHERE kmb.kegiatan_uuid = $1",parameters: [kegiatan_uuid as String]);

      if(result2.isEmpty){
        return listObject;
      }


      Map<String,KegiatanMitraPenugasanByMitraProgress> mapMitraProgress = {};

      result2.forEach((el) {
        Map<String,dynamic> kmbMap = el.toColumnMap();
        //bridge uuid, that unique for spesific mitra_id and kegiatan_uuid
        var uuid = kmbMap["uuid"]! as String;
        KegiatanMitraPenugasanByMitraProgress kmpMitraProgress = KegiatanMitraPenugasanByMitraProgress(
          mitra_id: kmbMap["mitra_id"]! as String,
          mitra_name: kmbMap["mitra_name"]! as String, 
          mitra_username: kmbMap["mitra_username"]! as String, 
          kegiatan_uuid: kmbMap["kegiatan_uuid"]! as String,
          kegiatan_name: kmbMap["kegiatan_name"]! as String, 
          kegiatan_desc: kmbMap["kegiatan_desc"]! as String, 
          progress: listStatus.map((el) {
            return StatusProgress(status: el.id!, status_desc: el.description, total: 0);
          }).toList()
          );
          mapMitraProgress[uuid] = kmpMitraProgress;
      });

      var result3 = await tx.execute(r"SELECT kmp.*, kmb.mitra_id as mitra_id FROM kegiatan_mitra_penugasan kmp LEFT JOIN kegiatan_mitra_bridge kmb ON kmp.bridge_uuid = kmb.uuid WHERE kmb.kegiatan_uuid = $1",
      parameters: [kegiatan_uuid as String]);
      if(result3.isEmpty){
        return mapMitraProgress.values.toList();
      }

      //if result 3 is not empty, iterate it through all
      result3.forEach((el){
        var kmpMap = el.toColumnMap();
        var bridge_uuid = kmpMap["bridge_uuid"]! as String;
        var status = kmpMap["status"]! as int;

        //if there is no kmb related, just continue iterate
        if(mapMitraProgress[bridge_uuid] == null){
          return;
        }

        //if there
        List<StatusProgress> listStatusProgress = mapMitraProgress[bridge_uuid]!.progress;
        for(var item in listStatusProgress){
          if(item.status == status){
            item.total++;
            return;
          }
        }
      });
      return mapMitraProgress.values.toList();
    });
  }
}