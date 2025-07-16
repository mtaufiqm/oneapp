import 'package:my_first/models/antrian/antrian_service_type.dart';
import 'package:my_first/repository/myconnection.dart';

class AntrianServiceRepository {
  MyConnectionPool conn;

  AntrianServiceRepository(this.conn);

  Future<List<AntrianServiceType>> readAll() async {
    return this.conn.connectionPool.runTx<List<AntrianServiceType>>((tx) async {
      var result = await tx.execute(r"SELECT * FROM antrian_service_type");
      List<AntrianServiceType> listObject = [];
      for(var item in result){
        AntrianServiceType object = AntrianServiceType.fromJson(item.toColumnMap());
        listObject.add(object);
      }
      return listObject;
    });
  }
}