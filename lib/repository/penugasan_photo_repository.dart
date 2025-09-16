import 'package:my_first/blocs/datetime_helper.dart';
import 'package:my_first/models/penugasan_photo.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:uuid/uuid.dart';

class PenugasanPhotoRepository {
  MyConnectionPool conn;

  PenugasanPhotoRepository(this.conn);

  Future<PenugasanPhoto?> getByUuid(String uuid) async {
    return this.conn.connectionPool.runTx<PenugasanPhoto?>((tx) async {
        var result = await tx.execute(r"SELECT * FROM penugasan_photo pp WHERE pp.uuid = $1",parameters: [
          uuid
        ]);
        if(result.isEmpty){
          return null;
        }
        return PenugasanPhoto.fromDb(result.first.toColumnMap());
    });
  }

  Future<PenugasanPhoto> update(String uuid, PenugasanPhoto object) async {
    return this.conn.connectionPool.runTx<PenugasanPhoto>((tx) async {
      String current_time = DatetimeHelper.getCurrentMakassarTime();
      object.uuid = uuid;
      var result = await tx.execute(r"UPDATE penugasan_photo SET kmp_uuid = $1, photo1_loc = $2, photo1_ext = $3, photo2_loc = $4, photo2_ext = $5, photo3_loc = $6, photo3_ext = $7, last_updated = $8  WHERE uuid = $9 RETURNING *",parameters: [
        object.kmp_uuid,
        object.photo1_loc,
        object.photo1_ext,
        object.photo2_loc,
        object.photo2_ext,
        object.photo3_loc,
        object.photo3_ext,
        current_time,
        object.uuid!
      ]);
      if(result.isEmpty){
        throw Exception("Failed Update Data");
      }
      return PenugasanPhoto.fromDb(result.first.toColumnMap());
    });
  }

  Future<PenugasanPhoto> upsertByKmpUuid(String uuid, PenugasanPhoto object) async {
    return this.conn.connectionPool.runTx<PenugasanPhoto>((tx) async {
      String current_time = DatetimeHelper.getCurrentMakassarTime();
      String uuid = Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO penugasan_photo VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9) ON CONFLICT (kmp_uuid) DO UPDATE SET photo1_loc = $3, photo1_ext = $4, photo2_loc = $5, photo2_ext = $6, photo3_loc = $7, photo3_ext = $8, last_updated = $9 RETURNING *",parameters: [
        object.uuid,
        object.kmp_uuid,
        object.photo1_loc,
        object.photo1_ext,
        object.photo2_loc,
        object.photo2_ext,
        object.photo3_loc,
        object.photo3_ext,
        current_time,
      ]);
      if(result.isEmpty){
        throw Exception("Failed Update Data");
      }
      return PenugasanPhoto.fromDb(result.first.toColumnMap());
    });
  }

  Future<PenugasanPhoto> create(PenugasanPhoto object) async {
    return this.conn.connectionPool.runTx<PenugasanPhoto>((tx) async {
      String uuid = Uuid().v1();
      String current_time = DatetimeHelper.getCurrentMakassarTime();
      object.uuid = uuid;
      object.last_updated = current_time;
      var result = await tx.execute(r"INSERT INTO penugasan_photo VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING *",parameters: [
        object.uuid,
        object.kmp_uuid,
        object.photo1_loc,
        object.photo1_ext,
        object.photo2_loc,
        object.photo2_ext,
        object.photo3_loc,
        object.photo3_ext,
        current_time
      ]);
      if(result.isEmpty){
        throw Exception("Failed Insert Data");
      }
      return PenugasanPhoto.fromDb(result.first.toColumnMap());
    });
  }

  //there is no implementation for now
  Future<List<PenugasanPhoto>> readAll() async {
    return [];
  }

  Future<PenugasanPhoto?> getByKmpUuid(String kmp_uid) async {
    return this.conn.connectionPool.runTx<PenugasanPhoto?>((tx) async {
        var result = await tx.execute(r"SELECT * FROM penugasan_photo pp WHERE pp.kmp_uuid = $1",parameters: [
          kmp_uid
        ]);
        if(result.isEmpty){
          return null;
        }
        return PenugasanPhoto.fromDb(result.first.toColumnMap());
    });
  }

  Future<void> delete(String uuid) async {
    return this.conn.connectionPool.runTx<void>((tx) async {
      var result = await tx.execute(r"DELETE FROM penugasan_photo WHERE uuid = $1",parameters: [
        uuid
      ]);
      if(result.affectedRows <= 0){
        throw Exception("Failed Delete Data ${uuid}");
      }
    });
  }

  Future<void> deleteByKmpUuid(String kmp_uuid) async {
    return this.conn.connectionPool.runTx<void>((tx) async {
      var result = await tx.execute(r"DELETE FROM penugasan_photo WHERE kmp_uuid = $1",parameters: [
        kmp_uuid
      ]);
      if(result.affectedRows <= 0){
        throw Exception("Failed Delete Data ${kmp_uuid}");
      }
    });
  }
}