// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class User {
  String username;
  String? pwd;
  List<String>? roles;
  User({
    required this.username,
    this.pwd,
    this.roles,
  });


  User copyWith({
    String? username,
    String? pwd,
    List<String>? roles,
  }) {
    return User(
      username: username ?? this.username,
      pwd: pwd ?? this.pwd,
      roles: roles ?? this.roles,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'pwd': pwd,
      'roles': roles,
    };
  }

  factory User.from(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      pwd: map['pwd'] != null ? map['pwd'] as String : null,
      roles: map['roles'] != null ? List<String>.from((map['roles'] as List<String>)) : null,
    );
  }

  bool isContain(String role){
    bool result = false;
    if(this.roles == null){
      return result;
    }
    for(String itemRoles in this.roles!){
      if(itemRoles == role){
        result = true;
      }
    }
    return result;
  }

  bool isContainOne(List<String> roles){
    bool result = false;
    if(this.roles == null){
      return result;
    }
    for(String itemRoles in this.roles!){
      for(String item in roles){
        if(itemRoles == item){
          result = true;
          return result;
        }
      }
    }
    return result;
  }
}
