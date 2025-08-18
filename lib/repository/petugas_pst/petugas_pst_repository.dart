import 'package:my_first/models/petugas_pst/petugas_pst.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:uuid/uuid.dart';

class PetugasPstRepository {
  MyConnectionPool conn;

  PetugasPstRepository(this.conn);


  Future<PetugasPst> getById(String uuid) async {
    return this.conn.connectionPool.runTx<PetugasPst>((tx) async {
      var result = await tx.execute(r"SELECT * FROM petugas_pst WHERE $1",parameters: [uuid]);
      if(result.isEmpty){
        throw Exception("There is no Data ${uuid}");
      }
      return PetugasPst.fromDb(result.first.toColumnMap());
    });
  }

  Future<PetugasPst> getByDate(String date) async {
    return this.conn.connectionPool.runTx<PetugasPst>((tx) async {
      var result = await tx.execute(r"SELECT * FROM petugas_pst pp WHERE TO_DATE(pp.end_date,'YYYY-MM-DD') >= $1 AND TO_DATE(pp.start_date,'YYYY-MM-DD') <= $1",parameters: [date]);
      
      if(result.isEmpty){
        throw Exception("There is no Data at time ${date}");
      }
      return PetugasPst.fromDb(result.first.toColumnMap());
    });
  }

  Future<PetugasPst> update(String uuid, PetugasPst object) async {
    return object;
  }

  Future<PetugasPst> create(PetugasPst object) async {
    return this.conn.connectionPool.runTx<PetugasPst>((tx) async {
      String uuid = Uuid().v1();
      object.uuid = uuid;
      var result = await tx.execute(r"INSERT INTO petugas_pst VALUES($1,$2,$3,$4,$5) RETURNING *",parameters: [
        object.uuid!,
        object.nama,
        object.start_date,
        object.end_date,
        object.photo
      ]);
      if(result.isEmpty){
        throw Exception("Failed Insert Data");
      }
      return PetugasPst.fromDb(result.first.toColumnMap());
    });
  }

  Future<List<PetugasPst>> readAll() async {
    return [];
  }

  Future<void> delete(String id) async {
    return;
  }
}