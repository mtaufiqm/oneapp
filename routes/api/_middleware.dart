import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:my_first/blocs/jwt_helper.dart';
import 'package:my_first/models/roles.dart';
import 'package:my_first/models/user.dart';
import 'package:my_first/repository/myconnection.dart';
import 'package:my_first/repository/user_repository.dart';


Handler middleware(Handler handler){
  return handler.use(bearerAuthentication<User>(
    authenticator: (context,token) async{
      JWT jwtToken = JwtHelper.tryVerify(token);
      //print("Token : ${token}");
      //print(jwtToken??"Invalid JWT");
      if(jwtToken == null){
        return null;
      }
      var connection = context.read<MyConnectionPool>();
      String username = jwtToken!.payload["username"] as String;
      List<String> roles = (jwtToken!.payload["roles"] as List).cast<String>();
      var userRepository = UserRepository(connection);
      try{
        //this check if user with username exists in db
        User myUser = await userRepository.getById(jwtToken!.payload["username"]);
        myUser.roles = roles;
        return myUser;
      } catch(e){
        //IF FAIL GET THAT USERNAME IN DB, PREVENT IT FOR ACCESS 
        ////THIS PREVENT FOR DELETED ACCOUNT TO ACCESS APIs
        return null;
      }
    }
  ));
}