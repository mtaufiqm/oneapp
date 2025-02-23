import 'package:my_first/models/mitra.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:postgres/postgres.dart';

class MitraRepository extends MyRepository<Mitra>{
  MyConnectionPool connection;
  
  MitraRepository(this.connection);

 Future<void> delete(dynamic mitraId) async{
    return this.connection.connectionPool.withConnection<void>((cnn) async{
      await cnn.runTx<void>((tx) async {
        await tx.execute(r'DELETE FROM mitra WHERE mitraId = $1',parameters: [mitraId as String]);
      });
      return;
    });
  }
  
  Future<List<Mitra>> readAll() async{
    return this.connection.connectionPool.withConnection((conn) async {
      return conn.runTx((tx) async {
        Result result = await tx.execute('SELECT * FROM mitra;');
        List<Mitra> listOfUser = <Mitra>[];
        for(ResultRow i in result){
          Map<String,dynamic> mapRow = i.toColumnMap();
          Mitra mitra = Mitra.from(mapRow);
          listOfUser.add(mitra);
        }
        return listOfUser;
      });
    });
  }

  Future<Mitra> create(Mitra mitra) async {
    return this.connection.connectionPool.withConnection((conn) async{
      return conn.runTx<Mitra>((tx) async{
        Result result = await tx.execute(r'INSERT INTO mitra VALUES($1,$2,$3,$4,$5,$6)',parameters: [mitra.mitraId, mitra.fullname,mitra.nickname,mitra.date_of_birth,mitra.city_of_birth,mitra.username]);
        return mitra;
      });
    });
  }

  Future<List<Mitra>> createList(List<Mitra> listOfMitra) async{
    return this.connection.connectionPool.runTx<List<Mitra>>((tx) async {
      List<Mitra> returnList = <Mitra>[];
      for(Mitra item in listOfMitra){
        Result hasil = await tx.execute(r"INSERT INTO mitra values($1,$2,$3,$4,$5,$6)",parameters: [item.mitraId, item.fullname,item.nickname,item.date_of_birth,item.city_of_birth,item.username]);
        returnList.add(item);
      }
      return returnList;
    });
  }

  // "mitraId" text PRIMARY KEY,
  // "fullname" text,
  // "nickname" text,
  // "date_of_birth" date,
  // "city_of_birth" text,
  // "username" text UNIQUE

  // fullname,nickname,date_of_birth,city_of_birth,username

  Future<Mitra> update(dynamic mitraId,Mitra mitra) async{
    return this.connection.connectionPool.runTx<Mitra>((tx) async {
      var result = await tx.execute(r'UPDATE mitra SET  full_name = $1, nickname = $2, date_of_birth = $3,city_of_birth = $4, username = $5 WHERE mitraId = $6',parameters: [mitra.fullname,mitra.nickname,mitra.date_of_birth,mitra.city_of_birth,mitra.username,mitraId]);
      return this.getById(mitraId);
    });
  }

  Future<Mitra> getById(dynamic mitraId) async{
    return this.connection.connectionPool.runTx((tx) async{
      Result hasil = await tx.execute(r'SELECT * FROM mitra WHERE mitraId = $1',parameters: [mitraId]);
      Mitra mitra;
      var mitraMap = hasil.first.toColumnMap();
      mitra = Mitra.from(mitraMap);
      return mitra;
    });
  }
}