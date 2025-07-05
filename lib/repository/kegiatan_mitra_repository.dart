import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/mitra.dart';
import 'package:my_first/models/pegawai.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

class KegiatanMitraRepository {
  MyConnectionPool conn;

  KegiatanMitraRepository(this.conn);

  Future<KegiatanMitraBridge> getByKegiatanAndMitra(dynamic kegiatan_uuid,dynamic mitra_id) async {
    return await this.conn.connectionPool.runTx<KegiatanMitraBridge>((tx) async {
      Result result = await tx.execute(r"SELECT * FROM kegiatan_mitra_bridge WHERE kegiatan_uuid = $1 AND mitra_id = $2",parameters: [
        kegiatan_uuid as String,
        mitra_id as String
      ]);
      if(result.isEmpty){
        throw Exception("There is no Data ${kegiatan_uuid as String}, ${mitra_id as String}");
      }

      KegiatanMitraBridge object = KegiatanMitraBridge.fromJson(result.first.toColumnMap());
      return object;

    });
  }

  Future<List<KegiatanMitraBridge>> getByMitraId(dynamic mitra_id) async {
    return await this.conn.connectionPool.runTx<List<KegiatanMitraBridge>>((tx) async {
      var listOfObject = <KegiatanMitraBridge>[];
      Result result = await tx.execute(r"SELECT * FROM kegiatan_mitra_bridge WHERE mitra_id = $1",parameters: [
        mitra_id as String
      ]);

      for(var item in result){
        KegiatanMitraBridge kmb = KegiatanMitraBridge.fromJson(item.toColumnMap());
        listOfObject.add(kmb);
      }

      return listOfObject;
    });
  }

    Future<List<KegiatanMitraBridgeDetails>> getDetailsByMitraId(dynamic mitra_id) async {
    return await this.conn.connectionPool.runTx<List<KegiatanMitraBridgeDetails>>((tx) async {
      var listOfObject = <KegiatanMitraBridgeDetails>[];      
      Result result = await tx.execute(r'''SELECT k.*, kmb.mitra_id, kmb.kegiatan_uuid, kmb.status, kmb.pengawas FROM kegiatan_mitra_bridge kmb LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid 
      WHERE kmb.mitra_id = $1 ORDER BY k."end" DESC''',parameters: [
        mitra_id as String
      ]);
      for(var item in result){
        Kegiatan kegiatan = Kegiatan.fromJson(item.toColumnMap());
        KegiatanMitraBridge kmb = KegiatanMitraBridge.fromJson(item.toColumnMap()..remove("uuid"));
        KegiatanMitraBridgeDetails kmbDetails = KegiatanMitraBridgeDetails(
          kegiatan: kegiatan, 
          status: kmb
        );
        listOfObject.add(kmbDetails);
      }
      return listOfObject;
    });
  }

  Future<List<KegiatanMitraBridge>> getByKegiatanId(dynamic kegiatan_uuid) async {
    return await this.conn.connectionPool.runTx((tx) async {
      List<KegiatanMitraBridge> listObject = [];
      var result = await tx.execute(r"SELECT * FROM kegiatan_mitra_bridge kmb WHERE kmb.kegiatan_uuid = $1",parameters: [kegiatan_uuid as String]);
      if(result.isEmpty) {
        throw Exception("Kegiatan ${kegiatan_uuid as String} Not Found!");
      }
      result.forEach((el) {
        KegiatanMitraBridge kmb = KegiatanMitraBridge.fromJson(el.toColumnMap());
        listObject.add(kmb);
      });
      return listObject;
    });
  }

  // String? uuid;
  // String kegiatan_uuid;
  // String kegiatan_name;
  // String mitra_id;
  // String mitra_username;
  // String mitra_fullname;
  // String status;
  // String? pengawas_username;
  // String? pengawas_name;
  // bool? is_pengawas_organic;
  Future<List<KegiatanMitraBridgeMoreDetails>> getMoreDetailsByKegiatanId(dynamic kegiatan_id) async {
    return await this.conn.connectionPool.runTx<List<KegiatanMitraBridgeMoreDetails>>((tx) async {
      var listOfObject = <KegiatanMitraBridgeMoreDetails>[];
      Result result = await tx.execute(r"SELECT kmb.uuid as uuid, k.uuid as kegiatan_uuid, k.name as kegiatan_name, m.mitra_id as mitra_id, m.username as mitra_username, m.fullname as mitra_fullname, kmb.status as status, kmb.pengawas as pengawas_username FROM kegiatan_mitra_bridge kmb LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid LEFT JOIN mitra m ON kmb.mitra_id = m.mitra_id WHERE kegiatan_uuid = $1",parameters: [
        kegiatan_id as String
      ]);
      Map<String,String?> listNamePegawai = {};
      Map<String,String?> listNameMitra = {};
      List<String> listUsername = [];
      for(var item in result){
        KegiatanMitraBridgeMoreDetails kmbMoreDetails = KegiatanMitraBridgeMoreDetails.fromJson(item.toColumnMap());
        listOfObject.add(kmbMoreDetails);

        //if pengawas_username is null, it means there is no already pengawas for that mitra
        if(kmbMoreDetails.pengawas_username == null){
          continue;
        }
        //add username to list username;
        listUsername.add(kmbMoreDetails.pengawas_username!);
      }
      //select name of pegawai if there in list username
      int counter = 0;
      String inListUsernameTemplate = listUsername.map((el) {
        counter++;
        return "\$${counter}";
      }).toList().join(",");

      //if there is no username / all username is null just return the listOfObject
      if(listUsername.length == 0){
        return listOfObject;
      }
      
      var resultPegawai = await tx.execute("SELECT username, fullname FROM pegawai WHERE username IN(${inListUsernameTemplate})",parameters:listUsername);
      var resultMitra = await tx.execute("SELECT username, fullname FROM mitra WHERE username IN(${inListUsernameTemplate})",parameters: listUsername);
      resultPegawai.forEach((el){
        String username = el.toColumnMap()["username"]! as String;
        String? fullname = el.toColumnMap()["fullname"]! as String?;
        listNamePegawai[username] = fullname;
      });
      resultMitra.forEach((el){
        String username = el.toColumnMap()["username"]! as String;
        String? fullname = el.toColumnMap()["fullname"]! as String?;
        listNameMitra[username] = fullname;
      });

      //fill pengawas_name and is_pengawas_organic field
      listOfObject.forEach((el){
        if(el.pengawas_username == null){
          return;
        }
        if(listNamePegawai.containsKey(el.pengawas_username)){
          el.pengawas_name = listNamePegawai[el.pengawas_username];
          el.is_pengawas_organic = true;
          return;
        }
        if(listNameMitra.containsKey(el.pengawas_username)){
          el.pengawas_name = listNameMitra[el.pengawas_username];
          el.is_pengawas_organic = false;
          return;
        }
      });
      return listOfObject;
    });
  }

  //this will create new kegiatan mitra bridge
  Future<List<KegiatanMitraBridge>> create(List<KegiatanMitraBridge> list) async {
    return await this.conn.connectionPool.runTx<List<KegiatanMitraBridge>>((tx) async {
      var listOfObject = <KegiatanMitraBridge>[];
      for(var item in list){
        try{
          item.uuid = Uuid().v1();
          Result result = await tx.execute(r"INSERT INTO kegiatan_mitra_bridge VALUES($1,$2,$3,$4,$5) ON CONFLICT (kegiatan_uuid,mitra_id) DO NOTHING RETURNING uuid",parameters: [
            item.uuid!,
            item.kegiatan_uuid,
            item.mitra_id,
            item.status,
            item.pengawas
          ]);

          //if there is conflict continue it;
          if(result.isEmpty){
            continue;
          }
          //if success, add item to resultObject
          listOfObject.add(item);
        } catch(e){
          continue;
        }
      }
      return listOfObject;
    });
  }

  Future<void> deleteByMitraId(dynamic uuid) async {
    return await this.conn.connectionPool.runTx<void>((tx) async {
      Result response = await tx.execute(r"DELETE FROM kegiatan_mitra_bridge WHERE mitra_id = $1", parameters: [
        uuid as String
      ]);

    });
  }

  Future<void> deleteByKegiatanId(dynamic uuid) async {
    return await this.conn.connectionPool.runTx<void>((tx) async {
      Result response = await tx.execute(r"DELETE FROM kegiatan_mitra_bridge WHERE kegiatan_uuid = $1", parameters: [
        uuid as String
      ]);
    });
  }

  //if error, rollback
  Future<void> deleteList(List<KegiatanMitraBridge> list) async {
    return await this.conn.connectionPool.runTx<void>((tx) async {
      for(var item in list){
        Result result = await tx.execute(r"DELETE FROM kegiatan_mitra_bridge WHERE kegiatan_uuid = $1 AND mitra_id = $2" ,parameters: [
          item.kegiatan_uuid,
          item.mitra_id
        ]);
      }
    });
  }

  Future<KegiatanMitraBridge> updateByUuid(dynamic uuid, KegiatanMitraBridge item) async {
    return await this.conn.connectionPool.runTx<KegiatanMitraBridge>((tx) async {
          var hasil = await tx.execute(r"UPDATE kegiatan_mitra_bridge SET status = $1, pengawas = $2 WHERE uuid = $3 RETURNING *",
          parameters: [
            item.status,
            item.pengawas,
            item.uuid!
          ]);

          //if there is no row affected, continue it
          if(hasil.affectedRows < 1){
            throw Exception("Fail to Update ${uuid as String}");
          }

          KegiatanMitraBridge object = KegiatanMitraBridge.fromJson(hasil.first.toColumnMap());
          return object;
    });
  }

  Future<List<KegiatanMitraBridge>> updateList(List<KegiatanMitraBridge> list) async {
    return await this.conn.connectionPool.runTx<List<KegiatanMitraBridge>>((tx) async {
      List<KegiatanMitraBridge> listOfObject = [];
      for(var item in list){
        try{
          var hasil = await tx.execute(r"UPDATE kegiatan_mitra_bridge SET status = $1, pengawas = $2 WHERE kegiatan_uuid = $3 AND mitra_id = $4",
          parameters: [
            item.status,
            item.pengawas,
            item.kegiatan_uuid,
            item.mitra_id
          ]);

          //if there is no row affected, continue it
          if(hasil.length < 1){
            continue;
          }

          //if success add to list of object for return
          listOfObject.add(item);
        } catch(e){

          //if error
          print("Error ${e}");
          continue;
        }
      }
      return listOfObject;
    });
  }

  Future<List<KegiatanMitraBridge>> updateListByUuid(List<KegiatanMitraBridge> list) async {
    return await this.conn.connectionPool.runTx<List<KegiatanMitraBridge>>((tx) async {
      List<KegiatanMitraBridge> listOfObject = [];
      for(var item in list){
        try{
          var hasil = await tx.execute(r"UPDATE kegiatan_mitra_bridge SET status = $1, pengawas = $2 WHERE uuid = $3",
          parameters: [
            item.status,
            item.pengawas,
            item.uuid!
          ]);

          //if there is no row affected, continue it
          if(hasil.length < 1){
            continue;
          }

          //if success add to list of object for return
          listOfObject.add(item);
        } catch(e){

          //if error
          print("Error ${e}");
          continue;
        }
      }
      return listOfObject;
    });
  }

}