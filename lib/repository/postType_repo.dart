import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:CatViP/model/post/postType.dart';
import 'package:CatViP/repository/APIConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:CatViP/repository/APIConstant.dart';

class PostTypeRepository {

  //Get Post
  Future<List<PostType>> fetchPostTypes() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");

      http.Response response = await http.get(
          Uri.parse(APIConstant.GetPostTypesURL),
          headers: {
            'Authorization': 'Bearer ${token}',
          }
      );
      if (response.statusCode == 200){
        List<dynamic> jsonData = json.decode(response.body);
        // Assuming the JSON data is a List of posts
        List<PostType> postTypes = jsonData.map((e) => PostType.fromJson(e)).toList();
        return postTypes;
      } else {
        return[PostType.withError("Status code: ${response.statusCode}")];
      }

      //List<dynamic> value = response.body as List;
      //return value.map((e) => Post.fromJson(e)).toList();
    }catch(e){
      if(e.toString().contains("SocketException")){
        return[PostType.withError("Check your internet connection please")];
      }
    }
    return[PostType.withError(e.toString())];
  }

}

