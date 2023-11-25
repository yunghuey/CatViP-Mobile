import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:CatViP/repository/APIConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:CatViP/repository/APIConstant.dart';
import '../model/post/post.dart';

class PostRepository{

  // New Post
  Future<bool> newPost(
      String description,
      int postTypeId,
      String? image,
      int catId
      ) async {

    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    try {
      var url = Uri.parse(APIConstant.NewPostURL);

      // to serialize the data Map to JSON
      var body = json.encode({
        'postTypeId': postTypeId,
        'description': description,
        'postImages': [
          {
            'image': image,
            'isBloodyContent': false
          }
        ],
        'mentionedCats': [
          {
            'catId': catId
          }
        ]
      });

      var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        String data =  response.body;
        pref.setString("message", data);
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //Get Post
  Future<List<Post>> fetchPost() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");

        http.Response response = await http.get(
            Uri.parse(APIConstant.GetPostsURL),
            headers: {
              'Authorization': 'Bearer ${token}',
            }
        );
      if (response.statusCode == 200){
        List<dynamic> jsonData = json.decode(response.body);
        // Assuming the JSON data is a List of posts
        List<Post> posts = jsonData.map((e) => Post.fromJson(e)).toList();
        return posts;
      } else {
        return[Post.withError("Status code: ${response.statusCode}")];
      }

      //List<dynamic> value = response.body as List;
      //return value.map((e) => Post.fromJson(e)).toList();
    }catch(e){
      if(e.toString().contains("SocketException")){
        return[Post.withError("Check your internet connection please")];
      }
      }
      return[Post.withError(e.toString())];
    }

  }
