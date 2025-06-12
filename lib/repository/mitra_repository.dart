import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/mitra.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

class MitraRepository extends MyRepository<Mitra>{
  final MyConnectionPool connection;
  MitraRepository(this.connection);
  
  Future<void> delete(dynamic mitraId) async{
  return this.connection.connectionPool.withConnection<void>((cnn) async{
    await cnn.runTx<void>((tx) async {
      await tx.execute(r'DELETE FROM mitra WHERE mitra_id = $1',parameters: [mitraId as String]);
    });
    return;
  });
  }
  
  Future<List<Mitra>> readAll() async{
    return this.connection.connectionPool.withConnection<List<Mitra>>((conn) async {
      return conn.runTx((tx) async {
        Result result = await tx.execute('SELECT * FROM mitra');
        List<Mitra> listOfMitra = <Mitra>[];
        for(ResultRow i in result){
          Map<String,dynamic> mapRow = i.toColumnMap();
          Mitra mitra = Mitra.fromJson(mapRow);
          listOfMitra.add(mitra);
        }
        return listOfMitra;
      });
    });
  }

      // 'uuid': uuid,
      // 'fullname': fullname,
      // 'fullname_with_title': fullname_with_title,
      // 'nickname': nickname,
      // 'date_of_birth': date_of_birth,
      // 'city_of_birth': city_of_birth,
      // 'nip': nip,
      // 'old_nip': old_nip,
      // 'age': age,
      // 'username': username,
      // 'status_pegawai': status_pegawai,

  Future<Mitra> create(Mitra mitra) async {
    return this.connection.connectionPool.withConnection((conn) async{
      return conn.runTx<Mitra>((tx) async{
        Result result = await tx.execute(r'INSERT INTO mitra(mitra_id,fullname,nickname,date_of_birth,city_of_birth,username,email,phone_number,address_code,address_detail) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) RETURNING mitra_id',
        parameters: mitra.toJson().values.toList());
        if(result.isEmpty){
          throw Exception("Error Create Mitra ${mitra.mitra_id}");
        }
        return mitra;
      });
    });
  }

  Future<Mitra> update(dynamic mitraId,Mitra mitra) async{
    return this.connection.connectionPool.runTx<Mitra>((tx) async {
      var result = await tx.execute(r"UPDATE mitra SET fullname = $1, nickname = $2, date_of_birth = $3, city_of_birth = $4, email = $5, username = $6, phone_number = $7, address_code = $8, address_detail = $9 WHERE mitra_id = $10",
      parameters: [
        mitra.fullname,
        mitra.nickname,
        mitra.nickname,
        mitra.date_of_birth,
        mitra.city_of_birth,
        mitra.email,
        mitra.username,
        mitra.phone_number,
        mitra.address_code,
        mitra.address_detail,
        mitraId as String
      ]);
      if(result.affectedRows < 1){
        throw Exception("There is no row updated!");
      }
      return mitra;
    });
  }

  Future<Mitra> getById(dynamic mitraId) async{
    return this.connection.connectionPool.runTx((tx) async{
      Result hasil = await tx.execute(r'SELECT * FROM mitra WHERE mitra_id = $1',parameters: [mitraId as String]);
      Mitra mitra;
      if(hasil.isEmpty){
        throw Exception("There is no Data ${mitraId as String}");
      }
      var mitraMap = hasil.first.toColumnMap();
      mitra = Mitra.fromJson(mitraMap);
      return mitra;
    });
  }

  Future<MitraWithKegiatan> getByIdWithKegiatan(dynamic mitraId) async {
    return this.connection.connectionPool.runTx((tx) async {
      Result hasil = await tx.execute(r"SELECT * FROM mitra WHERE mitra_id = $1",parameters: [
        mitraId as String
      ]);
      if(hasil.isEmpty){
        throw Exception("There is no Data ${mitraId as String}");
      }
      var mitraMap = hasil.first.toColumnMap();
      Mitra mitra = Mitra.fromJson(mitraMap);
      List<Kegiatan> listOfKegiatan = [];
      Result hasil2 = await tx.execute(r"SELECT * FROM kegiatan kg LEFT JOIN kegiatan_mitra_bridge kmb ON kg.uuid = kmb.kegiatan_uuid WHERE kmb.mitra_id = $1",
      parameters: [
        mitraId as String
      ]);
      for(var item in hasil2){
        Kegiatan kegiatan = Kegiatan.fromJson(item.toColumnMap());
        listOfKegiatan.add(kegiatan);
      }

      //return mitra with kegiatan {mitra:{},kegiatan:[]}
      return MitraWithKegiatan(mitra: mitra, kegiatan: listOfKegiatan);
    });
  }
  
  Future<Mitra> getByUsername(dynamic mitraUsername) async{
    return this.connection.connectionPool.runTx((tx) async{
      Result hasil = await tx.execute(r'SELECT * FROM mitra WHERE username = $1',parameters: [mitraUsername as String]);
      Mitra mitra;
      if(hasil.isEmpty){
        throw Exception("There is no Data ${mitraUsername as String}");
      }
      var mitraMap = hasil.first.toColumnMap();
      mitra = Mitra.fromJson(mitraMap);
      return mitra;
    });
  }

  Future<MitraWithKegiatan> getByUsernameWithKegiatan(dynamic mitraUsername) async{
    return await this.connection.connectionPool.runTx((tx) async {
      Result hasil = await tx.execute(r"SELECT * FROM mitra WHERE username = $1",parameters: [
        mitraUsername as String
      ]);
      if(hasil.isEmpty){
        throw Exception("There is no Data ${mitraUsername as String}");
      }
      var mitraMap = hasil.first.toColumnMap();
      Mitra mitra = Mitra.fromJson(mitraMap);
      List<Kegiatan> listOfKegiatan = [];
      Result hasil2 = await tx.execute(r"SELECT * FROM kegiatan kg LEFT JOIN kegiatan_mitra_bridge kmb ON kg.uuid = kmb.kegiatan_uuid LEFT JOIN mitra mt ON kmb.mitra_id = mt.mitra_id WHERE mt.username = $1",
      parameters: [
         mitraUsername as String
      ]);
      for(var item in hasil2){
        Kegiatan kegiatan = Kegiatan.fromJson(item.toColumnMap());
        listOfKegiatan.add(kegiatan);
      }

      //return mitra with kegiatan {mitra:{},kegiatan:[]}
      return MitraWithKegiatan(mitra: mitra, kegiatan: listOfKegiatan);
    });
  }
}