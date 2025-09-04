import 'dart:developer';

import 'package:my_first/blocs/datetime_helper.dart';
import 'package:my_first/models/ickm/structure_penilaian_mitra.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';

  // String? uuid;
  // String kuesioner_penilaian_mitra_uuid;
  // String? penilai_username;
  // String? mitra_username;
  // String? survei_uuid;

class StructurePenilaianRepository extends MyRepository<StructurePenilaianMitra>{
  final MyConnectionPool conn;

  StructurePenilaianRepository(this.conn);

  @override
  Future<StructurePenilaianMitra> getById(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM structure_penilaian_mitra WHERE uuid = $1",parameters: [uuid as String]);
      if(result.isEmpty){
        throw Exception("There is No Data with uuid ${uuid}");
      }
      var resultMap = result.first.toColumnMap();
      StructurePenilaianMitra documentation = StructurePenilaianMitra.fromJson(resultMap);
      return documentation;
    });
  }

  Future<StructurePenilaianMitra> update(dynamic uuid, StructurePenilaianMitra object) async {
    return this.conn.connectionPool.runTx((tx) async {
      object.uuid = uuid as String;
      var result = await tx.execute(r"UPDATE structure_penilaian_mitra SET kuesioner_penilaian_mitra_uuid = $1, penilai_username = $2, mitra_username = $3, survei_uuid = $4 WHERE uuid = $5",parameters: [
        object.kuesioner_penilaian_mitra_uuid,
        object.penilai_username,
        object.mitra_username,
        object.survei_uuid,
        uuid as String
      ]);
      if(result.affectedRows <= 0){
        throw Exception("Data not updated.");
      }
      object.uuid = uuid as String;
      return object;
    });
  }

  Future<StructurePenilaianMitra> create(StructurePenilaianMitra object) async {
    return this.conn.connectionPool.runTx((tx) async {
      String uuid =  Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO structure_penilaian_mitra VALUES($1,$2,$3,$4,$5) RETURNING uuid", parameters: [
        object.uuid,
        object.kuesioner_penilaian_mitra_uuid,
        object.penilai_username,
        object.mitra_username,
        object.survei_uuid
      ]);
      if(result.isEmpty){
        throw Exception("Error Create structure ${uuid}");
      }
      return object;
    });
  }

  Future<List<StructurePenilaianMitra>> readAll() async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"SELECT * FROM structure_penilaian_mitra");
      List<StructurePenilaianMitra> listStructure = [];
      for(var item in result){
        var itemStructure = StructurePenilaianMitra.fromJson(item.toColumnMap());
        listStructure.add(itemStructure);
      }
      return listStructure;
    });
  }

  // String? uuid;
  // String kuesioner_penilaian_mitra_uuid;
  // String? penilai_username;
  // String? mitra_username;
  // String? survei_uuid;
  Future<List<StructurePenilaianMitra>> insertList(List<StructurePenilaianMitra> listObject) async {
    return this.conn.connectionPool.runTx<List<StructurePenilaianMitra>>((tx) async {
      for(var item in listObject){
        try {
          String uuid = Uuid().v1();
          item.uuid = uuid;
          var result = await tx.execute(r"INSERT INTO structure_penilaian_mitra VALUES($1,$2,$3,$4,$5) returning uuid",parameters: [
            item.uuid,
            item.kuesioner_penilaian_mitra_uuid,
            item.penilai_username,
            item.mitra_username,
            item.survei_uuid
          ]);
          if(result.isEmpty){
            throw Exception("Failed Insert Structure Penilaian Item");
          }
        } catch(err){
          log("Error Create Structure Penilaian ${item.kuesioner_penilaian_mitra_uuid}, Mitra ${item.mitra_username}");
          throw Exception(err);
        }
      }
      return listObject;
    });
  }

  // String? uuid;
  // String kuesioner_penilaian_mitra_uuid;
  // String? penilai_username;
  // String? mitra_username;
  // String? survei_uuid;
  Future<List<StructurePenilaianMitra>> insertListAndResponse(List<StructurePenilaianMitra> listObject) async {
    return this.conn.connectionPool.runTx<List<StructurePenilaianMitra>>((tx) async {
      for(var item in listObject){
        try {
          String uuid = Uuid().v1();
          item.uuid = uuid;
          var result = await tx.execute(r"INSERT INTO structure_penilaian_mitra VALUES($1,$2,$3,$4,$5) RETURNING *",parameters: [
            item.uuid,
            item.kuesioner_penilaian_mitra_uuid,
            item.penilai_username,
            item.mitra_username,
            item.survei_uuid
          ]);
          if(result.isEmpty){
            throw Exception("Failed Insert Structure Penilaian Item");
          }
          String currentTime = DatetimeHelper.getCurrentMakassarTime();
          StructurePenilaianMitra structure = StructurePenilaianMitra.fromDb(result.first.toColumnMap());
          String uuid2 = Uuid().v1();
          var result2 = await tx.execute(r"INSERT INTO response_assignment VALUES($1,$2,$3,$4,$5,$6,$7) RETURNING uuid",parameters: [
            uuid2,
            structure.uuid!,
            currentTime,
            currentTime,
            false,
            structure.survei_uuid!,
            ""
          ]);
          if(result2.isEmpty){
            log("Error Create Response Penilaian ${item.kuesioner_penilaian_mitra_uuid}, Mitra ${item.mitra_username}");
            throw Exception("Failed Insert Response Assignment");
          }
        } catch(err){
          log("Error Create Structure Penilaian ${item.kuesioner_penilaian_mitra_uuid}, Mitra ${item.mitra_username}");
          throw Exception(err);
        }
      }
      return listObject;
    });
  }

  Future<void> delete(dynamic uuid) async {
    return this.conn.connectionPool.runTx((tx) async {
      var result = await tx.execute(r"DELETE FROM structure_penilaian_mitra WHERE uuid = $1",parameters: [uuid as String]);
      if(result.affectedRows <= 0){
        throw Exception("Fail to delete structure ${uuid}");
      }
      return;
    });
  }

  // String? uuid;
  // String kuesioner_penilaian_mitra_uuid;
  // String kuesioner_penilaian_mitra_title;
  // String kuesioner_penilaian_mitra_start_date;
  // String kuesioner_penilaian_mitra_end_date;
  // String kegiatan_name;
  // String? penilai_username;
  // String? penilai_fullname;
  // String? mitra_username;
  // String? mitra_id;
  // String? mitra_fullname;
  // String? survei_uuid;
  // String? survei_name;
  // String? survei_type;
  // bool? isHaveResponse;
  // String? response_uuid;
  // bool? response_is_completed;
  // String? response_updated_at;
  Future<List<StructurePenilaianMitraDetails>> readDetailsByPenilaian(dynamic penilaian_uuid) async {
    return this.conn.connectionPool.runTx<List<StructurePenilaianMitraDetails>>((tx) async {
      var result = await tx.execute(r"select spm.uuid as uuid, kpm.uuid as kuesioner_penilaian_mitra_uuid, kpm.title as kuesioner_penilaian_mitra_title, kpm.start_date as kuesioner_penilaian_mitra_start_date, kpm.end_date as kuesioner_penilaian_mitra_end_date, k.uuid as kegiatan_uuid, k.name as kegiatan_name, spm.penilai_username as penilai_username, p.fullname as penilai_fullname, spm.mitra_username as mitra_username, m.mitra_id as mitra_id, m.fullname as mitra_fullname, s.uuid as survei_uuid, s.description as survei_name, s.survei_type as survei_type  , ra.uuid as response_uuid, ra.is_completed as response_is_completed, ra.updated_at as response_updated_at from structure_penilaian_mitra spm left join kuesioner_penilaian_mitra kpm on spm.kuesioner_penilaian_mitra_uuid = kpm.uuid left join kegiatan k on kpm.kegiatan_uuid = k.uuid  left join mitra m on spm.mitra_username = m.username left join pegawai p on spm.penilai_username = p.username left join survei s on spm.survei_uuid = s.uuid left join response_assignment ra on spm.uuid = ra.structure_uuid WHERE kpm.uuid = $1",parameters: [penilaian_uuid as String]);
      List<StructurePenilaianMitraDetails> listObject = [];
      for(var item in result){
        try {
          StructurePenilaianMitraDetails spmDetails = StructurePenilaianMitraDetails.fromJson(item.toColumnMap());
          if(spmDetails.response_uuid == null || spmDetails.response_uuid!.isEmpty){
            spmDetails.isHaveResponse = false;
          } else {
            spmDetails.isHaveResponse = true;
          }
          listObject.add(spmDetails);
        } catch(err){
          log("Error read Details By Penilaian ${penilaian_uuid} : ${err}");
          continue;
        }
      }
      return listObject;
    });
  }

  Future<List<StructurePenilaianMitraDetails>> readDetailsByPenilaianAndPenilai(dynamic penilaian_uuid, dynamic penilai_username) async {
    return this.conn.connectionPool.runTx<List<StructurePenilaianMitraDetails>>((tx) async {
      var result = await tx.execute(r"select spm.uuid as uuid, kpm.uuid as kuesioner_penilaian_mitra_uuid, kpm.title as kuesioner_penilaian_mitra_title, kpm.start_date as kuesioner_penilaian_mitra_start_date, kpm.end_date as kuesioner_penilaian_mitra_end_date, k.uuid as kegiatan_uuid, k.name as kegiatan_name, spm.penilai_username as penilai_username, p.fullname as penilai_fullname, spm.mitra_username as mitra_username, m.mitra_id as mitra_id, m.fullname as mitra_fullname, s.uuid as survei_uuid, s.description as survei_name, s.survei_type as survei_type  , ra.uuid as response_uuid, ra.is_completed as response_is_completed, ra.updated_at as response_updated_at from structure_penilaian_mitra spm left join kuesioner_penilaian_mitra kpm on spm.kuesioner_penilaian_mitra_uuid = kpm.uuid left join kegiatan k on kpm.kegiatan_uuid = k.uuid  left join mitra m on spm.mitra_username = m.username left join pegawai p on spm.penilai_username = p.username left join survei s on spm.survei_uuid = s.uuid left join response_assignment ra on spm.uuid = ra.structure_uuid  WHERE kpm.uuid = $1 AND spm.penilai_username = $2",parameters: [
        penilaian_uuid as String,
        penilai_username as String
      ]);
      List<StructurePenilaianMitraDetails> listObject = [];
      for(var item in result){
        try {
          StructurePenilaianMitraDetails spmDetails = StructurePenilaianMitraDetails.fromJson(item.toColumnMap());
          if(spmDetails.response_uuid == null || spmDetails.response_uuid!.isEmpty){
            spmDetails.isHaveResponse = false;
          } else {
            spmDetails.isHaveResponse = true;
          }
          listObject.add(spmDetails);
        } catch(err){
          log("Error read Details By Penilaian ${penilaian_uuid} : ${err}");
          continue;
        }
      }
      return listObject;
    });
  }

    Future<StructurePenilaianMitraDetails> readDetailsByUuid(dynamic structure_uuid) async {
    return this.conn.connectionPool.runTx<StructurePenilaianMitraDetails>((tx) async {
      var result = await tx.execute(r"select spm.uuid as uuid, kpm.uuid as kuesioner_penilaian_mitra_uuid, kpm.title as kuesioner_penilaian_mitra_title, kpm.start_date as kuesioner_penilaian_mitra_start_date, kpm.end_date as kuesioner_penilaian_mitra_end_date, k.uuid as kegiatan_uuid, k.name as kegiatan_name, spm.penilai_username as penilai_username, p.fullname as penilai_fullname, spm.mitra_username as mitra_username, m.mitra_id as mitra_id, m.fullname as mitra_fullname, s.uuid as survei_uuid, s.description as survei_name, s.survei_type as survei_type  , ra.uuid as response_uuid, ra.is_completed as response_is_completed, ra.updated_at as response_updated_at from structure_penilaian_mitra spm left join kuesioner_penilaian_mitra kpm on spm.kuesioner_penilaian_mitra_uuid = kpm.uuid left join kegiatan k on kpm.kegiatan_uuid = k.uuid  left join mitra m on spm.mitra_username = m.username left join pegawai p on spm.penilai_username = p.username left join survei s on spm.survei_uuid = s.uuid left join response_assignment ra on spm.uuid = ra.structure_uuid WHERE spm.uuid = $1",parameters: [structure_uuid as String]);
      try {
        StructurePenilaianMitraDetails spmDetails = StructurePenilaianMitraDetails.fromJson(result.first.toColumnMap());
        if(spmDetails.response_uuid == null || spmDetails.response_uuid!.isEmpty){
          spmDetails.isHaveResponse = false;
        } else {
          spmDetails.isHaveResponse = true;
        }
        return spmDetails;
      } catch(err){
        String message = "Error read Details By Uuid ${structure_uuid as String} : ${err}";
        log(message);
        throw Exception(message);
      }
    });
  }

  Future<List<StructurePenilaianMitraDetails>> readAllDetails() async {
    return this.conn.connectionPool.runTx<List<StructurePenilaianMitraDetails>>((tx) async {
      var result = await tx.execute(r"select spm.uuid as uuid, kpm.uuid as kuesioner_penilaian_mitra_uuid, kpm.title as kuesioner_penilaian_mitra_title, kpm.start_date as kuesioner_penilaian_mitra_start_date, kpm.end_date as kuesioner_penilaian_mitra_end_date, k.uuid as kegiatan_uuid, k.name as kegiatan_name, spm.penilai_username as penilai_username, p.fullname as penilai_fullname, spm.mitra_username as mitra_username, m.mitra_id as mitra_id, m.fullname as mitra_fullname, s.uuid as survei_uuid, s.description as survei_name, s.survei_type as survei_type  , ra.uuid as response_uuid, ra.is_completed as response_is_completed, ra.updated_at as response_updated_at from structure_penilaian_mitra spm left join kuesioner_penilaian_mitra kpm on spm.kuesioner_penilaian_mitra_uuid = kpm.uuid left join kegiatan k on kpm.kegiatan_uuid = k.uuid  left join mitra m on spm.mitra_username = m.username left join pegawai p on spm.penilai_username = p.username left join survei s on spm.survei_uuid = s.uuid left join response_assignment ra on spm.uuid = ra.structure_uuid");
      List<StructurePenilaianMitraDetails> listObject = [];
      for(var item in result){
        try {
          StructurePenilaianMitraDetails spmDetails = StructurePenilaianMitraDetails.fromJson(item.toColumnMap());
          if(spmDetails.response_uuid == null || spmDetails.response_uuid!.isEmpty){
            spmDetails.isHaveResponse = false;
          } else {
            spmDetails.isHaveResponse = true;
          }
          listObject.add(spmDetails);
        } catch(err){
          log("Error read Details By Penilaian ${err}");
          continue;
        }
      }
      return listObject;
    });
  }

  Future<List<StructurePenilaianMitraDetails>> readAllDetailsLimit(int limit) async {
    return this.conn.connectionPool.runTx<List<StructurePenilaianMitraDetails>>((tx) async {
      var result = await tx.execute(r"select spm.uuid as uuid, kpm.uuid as kuesioner_penilaian_mitra_uuid, kpm.title as kuesioner_penilaian_mitra_title, kpm.start_date as kuesioner_penilaian_mitra_start_date, kpm.end_date as kuesioner_penilaian_mitra_end_date, k.uuid as kegiatan_uuid, k.name as kegiatan_name, spm.penilai_username as penilai_username, p.fullname as penilai_fullname, spm.mitra_username as mitra_username, m.mitra_id as mitra_id, m.fullname as mitra_fullname, s.uuid as survei_uuid, s.description as survei_name, s.survei_type as survei_type  , ra.uuid as response_uuid, ra.is_completed as response_is_completed, ra.updated_at as response_updated_at from structure_penilaian_mitra spm left join kuesioner_penilaian_mitra kpm on spm.kuesioner_penilaian_mitra_uuid = kpm.uuid left join kegiatan k on kpm.kegiatan_uuid = k.uuid  left join mitra m on spm.mitra_username = m.username left join pegawai p on spm.penilai_username = p.username left join survei s on spm.survei_uuid = s.uuid left join response_assignment ra on spm.uuid = ra.structure_uuid LIMIT $1",parameters: [limit as int]);
      List<StructurePenilaianMitraDetails> listObject = [];
      for(var item in result){
        try {
          StructurePenilaianMitraDetails spmDetails = StructurePenilaianMitraDetails.fromJson(item.toColumnMap());
          if(spmDetails.response_uuid == null || spmDetails.response_uuid!.isEmpty){
            spmDetails.isHaveResponse = false;
          } else {
            spmDetails.isHaveResponse = true;
          }
          listObject.add(spmDetails);
        } catch(err){
          print("Error read Details By Penilaian :  ${err}");
          continue;
        }
      }
      return listObject;
    });
  }

    Future<List<StructurePenilaianMitraDetails>> readAllDetailsByPenilai(dynamic penilai_username) async {
    return this.conn.connectionPool.runTx<List<StructurePenilaianMitraDetails>>((tx) async {
      var result = await tx.execute(r"select spm.uuid as uuid, kpm.uuid as kuesioner_penilaian_mitra_uuid, kpm.title as kuesioner_penilaian_mitra_title, kpm.start_date as kuesioner_penilaian_mitra_start_date, kpm.end_date as kuesioner_penilaian_mitra_end_date, k.uuid as kegiatan_uuid, k.name as kegiatan_name, spm.penilai_username as penilai_username, p.fullname as penilai_fullname, spm.mitra_username as mitra_username, m.mitra_id as mitra_id, m.fullname as mitra_fullname, s.uuid as survei_uuid, s.description as survei_name, s.survei_type as survei_type  , ra.uuid as response_uuid, ra.is_completed as response_is_completed, ra.updated_at as response_updated_at from structure_penilaian_mitra spm left join kuesioner_penilaian_mitra kpm on spm.kuesioner_penilaian_mitra_uuid = kpm.uuid left join kegiatan k on kpm.kegiatan_uuid = k.uuid  left join mitra m on spm.mitra_username = m.username left join pegawai p on spm.penilai_username = p.username left join survei s on spm.survei_uuid = s.uuid left join response_assignment ra on spm.uuid = ra.structure_uuid  WHERE spm.penilai_username = $1",parameters:[penilai_username as String]);
      List<StructurePenilaianMitraDetails> listObject = [];
      for(var item in result){
        try {
          StructurePenilaianMitraDetails spmDetails = StructurePenilaianMitraDetails.fromJson(item.toColumnMap());
          if(spmDetails.response_uuid == null || spmDetails.response_uuid!.isEmpty){
            spmDetails.isHaveResponse = false;
          } else {
            spmDetails.isHaveResponse = true;
          }
          listObject.add(spmDetails);
        } catch(err){
          log("Error read Details By Penilaian");
          continue;
        }
      }
      return listObject;
    });
  }

  Future<StructurePenilaianMitraDetails> getDetailsByUuid(dynamic uuid) async {
    return await this.conn.connectionPool.runTx<StructurePenilaianMitraDetails>((tx) async {
      var result = await tx.execute(r"select spm.uuid as uuid, kpm.uuid as kuesioner_penilaian_mitra_uuid, kpm.title as kuesioner_penilaian_mitra_title, kpm.start_date as kuesioner_penilaian_mitra_start_date, kpm.end_date as kuesioner_penilaian_mitra_end_date, k.uuid as kegiatan_uuid, k.name as kegiatan_name, spm.penilai_username as penilai_username, p.fullname as penilai_fullname, spm.mitra_username as mitra_username, m.mitra_id as mitra_id, m.fullname as mitra_fullname, s.uuid as survei_uuid, s.description as survei_name, s.survei_type as survei_type  , ra.uuid as response_uuid, ra.is_completed as response_is_completed, ra.updated_at as response_updated_at from structure_penilaian_mitra spm left join kuesioner_penilaian_mitra kpm on spm.kuesioner_penilaian_mitra_uuid = kpm.uuid left join kegiatan k on kpm.kegiatan_uuid = k.uuid  left join mitra m on spm.mitra_username = m.username left join pegawai p on spm.penilai_username = p.username left join survei s on spm.survei_uuid = s.uuid left join response_assignment ra on spm.uuid = ra.structure_uuid  WHERE spm.uuid = $1",parameters: [
        uuid as String
      ]);
      StructurePenilaianMitraDetails spmDetails = StructurePenilaianMitraDetails.fromJson(result.first.toColumnMap());
      if(spmDetails.response_uuid == null || spmDetails.response_uuid!.isEmpty){
        spmDetails.isHaveResponse = false;
      } else {
        spmDetails.isHaveResponse = true;
      }
      return spmDetails;
    });
  }

  Future<StructurePenilaianMitraDetails> getDetailsByResponseUuid(dynamic response_uuid) async {
    return await this.conn.connectionPool.runTx<StructurePenilaianMitraDetails>((tx) async {
      var result = await tx.execute(r"select spm.uuid as uuid, kpm.uuid as kuesioner_penilaian_mitra_uuid, kpm.title as kuesioner_penilaian_mitra_title, kpm.start_date as kuesioner_penilaian_mitra_start_date, kpm.end_date as kuesioner_penilaian_mitra_end_date, k.uuid as kegiatan_uuid, k.name as kegiatan_name, spm.penilai_username as penilai_username, p.fullname as penilai_fullname, spm.mitra_username as mitra_username, m.mitra_id as mitra_id, m.fullname as mitra_fullname, s.uuid as survei_uuid, s.description as survei_name, s.survei_type as survei_type  , ra.uuid as response_uuid, ra.is_completed as response_is_completed, ra.updated_at as response_updated_at from structure_penilaian_mitra spm left join kuesioner_penilaian_mitra kpm on spm.kuesioner_penilaian_mitra_uuid = kpm.uuid left join kegiatan k on kpm.kegiatan_uuid = k.uuid  left join mitra m on spm.mitra_username = m.username left join pegawai p on spm.penilai_username = p.username left join survei s on spm.survei_uuid = s.uuid left join response_assignment ra on spm.uuid = ra.structure_uuid  WHERE ra.uuid = $1",parameters: [
        response_uuid as String
      ]);
      StructurePenilaianMitraDetails spmDetails = StructurePenilaianMitraDetails.fromJson(result.first.toColumnMap());
      if(spmDetails.response_uuid == null || spmDetails.response_uuid!.isEmpty){
        spmDetails.isHaveResponse = false;
      } else {
        spmDetails.isHaveResponse = true;
      }
      return spmDetails;
    });
  }
}