import 'dart:convert';
import 'dart:typed_data';
import 'package:CatViP/repository/APIConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:CatViP/repository/APIConstant.dart';
import '../model/post/post.dart';

class PostRepository{

  // New Post
  Future<bool> newPost(String description,int postTypeId,
                        String? image, int catId ) async {

    var pref = await SharedPreferences.getInstance();
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
          headers: {"Content-Type": "application/json"},
          body: body
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
      http.Response response = await http.get(
          Uri.parse(APIConstant.GetPostsURL),
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9zaWQiOiIzIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6InRvbmciLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJDYXQgRXhwZXJ0IiwiZXhwIjoxNzAxMTg1MjM0fQ.CF2zzn1755VKchHMhxMbMSLt9Votc_wCOIU9d7r3paQ',
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
      return[Post.withError(e.toString())];
    }

  }

   


}