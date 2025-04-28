import 'package:my_first/blocs/datetime_helper.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/kegiatan_mitra_penugasan.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
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
        mapGroup["${taskDetails.group}"] = KegiatanMitraPenugasanGroup(group: group , penugasan: []);
        mapGroup["${taskDetails.group}"]!.penugasan.add(taskDetails);
      }
      return mapGroup.values.toList();
    });
  }

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
        mapGroup["${taskDetails.group}"] = KegiatanMitraPenugasanGroup(group: group , penugasan: []);
        mapGroup["${taskDetails.group}"]!.penugasan.add(taskDetails);
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

  //continue this
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
}