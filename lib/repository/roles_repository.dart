import 'package:my_first/models/roles.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import 'package:postgres/postgres.dart';

class RolesRepository implements MyRepository<Roles>{
  MyConnectionPool connection;

  RolesRepository(this.connection);

  Future<Roles> getById(dynamic description){
    return this.connection.connectionPool.runTx((tx) async{
      Result hasil = await tx.execute(r'SELECT * FROM roles WHERE description = $1',parameters: [description]);
      Roles roles;
      var rolesMap = hasil.first.toColumnMap();
      roles = Roles(description: rolesMap["description"] as String);
      return roles;
    });
  }
  Future<Roles> update(dynamic id, Roles object) async{
    //NO NEDD TO UPDATE ROLES
    return object;

  }
  Future<Roles> create(Roles roles){
    return this.connection.connectionPool.withConnection((conn) async{
      return conn.runTx<Roles>((tx) async{
        Result result = await tx.execute(r'INSERT INTO roles VALUES($1)',parameters: [roles.description]);
        return roles;
      });
    });
  }
  Future<List<Roles>> readAll(){
    return this.connection.connectionPool.withConnection((conn) async {
      return conn.runTx((tx) async {
        Result result = await tx.execute('SELECT * FROM roles;');
        List<Roles> listOfRoles = <Roles>[];
        for(ResultRow i in result){
          Map<String,dynamic> mapRow = i.toColumnMap();
          Roles roles = Roles.from({
            "username":mapRow["description"]
          });
          listOfRoles.add(roles);
        }
        return listOfRoles;
      });
    });
  }
  Future<void> delete(dynamic id) async{
    //NO NEDD TO DELETE ROLES
    return;
  }  
}