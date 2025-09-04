import 'dart:io';

import "package:postgres/postgres.dart";


class MyConnectionPool{
  late Pool connectionPool;
  MyConnectionPool(){
    try{
      String host = Platform.environment["dbhost"]??"localhost";
      String databaseName = Platform.environment["dbname"]??"myapp";
      String user = Platform.environment["dbuser"]??"postgres";
      String password = Platform.environment["dbpassword"]??"taufiq1729";
      Endpoint endpoint = Endpoint(host: host, database: databaseName,username: user,password: password);
      connectionPool = Pool.withEndpoints([endpoint],settings: PoolSettings(maxConnectionCount: 3,connectTimeout: Duration(seconds: 5),sslMode: SslMode.disable));
    } catch(e){
      print(e);
    }
  }

  Future<void> closeConnectionPool() async{
    await this.connectionPool.close();
  }
}