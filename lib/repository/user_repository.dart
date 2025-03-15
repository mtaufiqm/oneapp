import 'dart:async';

import 'package:my_first/models/roles.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/myrepository.dart';
import "package:my_first/models/user.dart";
import 'package:postgres/postgres.dart';

class UserRepository extends MyRepository<User>{
  MyConnectionPool connection;

  UserRepository(this.connection);

  Future<void> delete(dynamic username) async{
    return this.connection.connectionPool.withConnection<void>((cnn) async{
      await cnn.runTx<void>((tx) async {
        await tx.execute(r'DELETE FROM "user" WHERE username = $1',parameters: [username as String]);
      });
      return;
    });
  }
  
  Future<List<User>> readAll() async{
    return this.connection.connectionPool.withConnection((conn) async {
      return conn.runTx((tx) async {
        Result result = await tx.execute('SELECT username FROM "user";');
        List<User> listOfUser = <User>[];
        for(ResultRow i in result){
          Map<String,dynamic> mapRow = i.toColumnMap();
          User user = User.from({
            "username":mapRow["username"]
          });
          listOfUser.add(user);
        }
        return listOfUser;
      });
    });
  }

  Future<User> create(User user) async {
    return this.connection.connectionPool.withConnection((conn) async{
      return conn.runTx<User>((tx) async{
        Result result = await tx.execute(r'INSERT INTO "user" VALUES($1,$2)',parameters: [user.username,user.pwd]);
        return user;
      });
    });
  }

  Future<User> update(dynamic username,User user) async{
    return this.connection.connectionPool.runTx<User>((tx) async {
      var result = await tx.execute(r'UPDATE "user" SET pwd = $1 WHERE username = $2',parameters: [user.pwd,username as String]);
      return this.getById(username);
    });
  }

  Future<User> getById(dynamic username) async{
    return this.connection.connectionPool.runTx((tx) async{
      Result hasil = await tx.execute(r'SELECT * FROM "user" WHERE username = $1',parameters: [username]);
      User user;
      var userMap = hasil.first.toColumnMap();
      user = User(username: userMap["username"] as String,pwd: userMap["pwd"] as String);
      return user;
    });
  }

  Future<List<Roles>> getRolesByUserId(dynamic username) async{
    return this.connection.connectionPool.runTx<List<Roles>>((tx) async{
      Result result = await tx.execute(r'SELECT * FROM user_role_bridge WHERE username = $1',parameters: [username]);
      List<Roles> roles = <Roles>[];
      for(ResultRow i in result){
        var descriptionValue = (i.toColumnMap()["description"]) as String;
        roles.add(Roles(description: descriptionValue));
      }
      return roles;
    });
  }

  Future<void> deleteOldUserRoles(User targetUser) async{
    return this.connection.connectionPool.runTx<void>((tx) async {
      Result hasil = await tx.execute(r"DELETE FROM user_role_bridge WHERE username = $1",parameters: [targetUser.username]);
      return;
    });
  }

  Future<List<Roles>> createUserRoles(User targetUser,List<Roles> roles) async{
    return this.connection.connectionPool.runTx<List<Roles>>((tx) async {
      List<Roles> listOfRoles = <Roles>[];
      for(Roles role in roles){
        try{
          await tx.execute(r"INSERT INTO user_role_bridge values($1,$2)",parameters: [targetUser.username,role.description]);
        } catch(e){
        }
      }
      return await this.getRolesByUserId(targetUser.username);
    });
  }

  Future<List<User>> getUsersWithRole(dynamic role) async {
    return await this.connection.connectionPool.runTx<List<User>>((tx) async {
      var result = await tx.execute(r'select "user".username as username, "user".pwd as pwd from "user" LEFT JOIN user_role_bridge ON "user".username  = user_role_bridge.username where description = $1',parameters: [role as String]);
      if(result.isEmpty){
        throw Exception("There is User with ${role as String} role");
      }
      List<User> returnValue = [];
      for(var item in result){
        User itemUser = User.from(item.toColumnMap());
        returnValue.add(itemUser);
      }
      return returnValue;
    });
  }
}