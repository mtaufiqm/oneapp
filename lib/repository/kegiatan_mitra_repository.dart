import 'package:dart_frog/dart_frog.dart';
import 'package:my_first/models/kegiatan.dart';
import 'package:my_first/models/kegiatan_mitra_bridge.dart';
import 'package:my_first/models/mitra.dart';
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
      Result result = await tx.execute(r'''SELECT k.*, kmb.mitra_id, kmb.kegiatan_uuid, kmb.status FROM kegiatan_mitra_bridge kmb LEFT JOIN kegiatan k ON kmb.kegiatan_uuid = k.uuid 
      WHERE kmb.mitra_id = $1''',parameters: [
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

  Future<List<KegiatanMitraBridge>> getByKegiatanId(dynamic kegiatan_id) async {
    return await this.conn.connectionPool.runTx<List<KegiatanMitraBridge>>((tx) async {
      var listOfObject = <KegiatanMitraBridge>[];
      Result result = await tx.execute(r"SELECT * FROM kegiatan_mitra_bridge WHERE kegiatan_uuid = $1",parameters: [
        kegiatan_id as String
      ]);

      for(var item in result){
        KegiatanMitraBridge kmb = KegiatanMitraBridge.fromJson(item.toColumnMap());
        listOfObject.add(kmb);
      }

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
          Result result = await tx.execute(r"INSERT INTO kegiatan_mitra_bridge VALUES($1,$2,$3,$4) ON CONFLICT (kegiatan_uuid,mitra_id) DO NOTHING RETURNING uuid",parameters: [
            item.uuid!,
            item.kegiatan_uuid,
            item.mitra_id,
            item.status
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

  Future<List<KegiatanMitraBridge>> updateList(List<KegiatanMitraBridge> list) async {
    return await this.conn.connectionPool.runTx<List<KegiatanMitraBridge>>((tx) async {
      List<KegiatanMitraBridge> listOfObject = [];
      for(var item in list){
        try{
          var hasil = await tx.execute(r"UPDATE kegiatan_mitra_bridge SET status = $1 WHERE kegiatan_uuid = $2 AND mitra_id = $3",
          parameters: [
            item.status,
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
}