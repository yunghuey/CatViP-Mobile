import 'dart:convert';
import 'dart:typed_data';
import 'package:CatViP/repository/APIConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:CatViP/repository/APIConstant.dart';
import '../model/post/post.dart';
import '../model/post/postComment.dart';

class PostRepository{

  // New Post
  Future<bool> newPost(String description,int postTypeId,
                        String? image, int catId ) async {

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

      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.post(url,
          headers: header,
          body: body
      );

      if (response.statusCode == 200) {
        String data =  response.body;
        pref.setString("message", data);
        return true;
      }
      else if (response.statusCode == 400) {
        String data =  response.body;
        pref.setString("message", data);
        print(data.toString());
        return false;
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
      return[Post.withError(e.toString())];
    }

  }

//   Get Own Post
  Future<List<Post>> fetchMyPost() async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.GetOwnPostURL);
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200){
        List<dynamic> jsonData = json.decode(response.body);

        // Assuming the JSON data is a List of posts
        List<Post> posts = jsonData.map((e) => Post.fromJson(e)).toList();
        return posts;
      }
      return [];
    } catch (e){
      print("error in get own post");
      print(e.toString());
      return [];
    }
  }

  // get post of a cat
  Future<List<Post>> fetchCatPost(int catid) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.GetCatPostURL + catid.toString());
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200){
        List<dynamic> jsonData = json.decode(response.body);

        // Assuming the JSON data is a List of posts
        List<Post> posts = jsonData.map((e) => Post.fromJson(e)).toList();
        print("post: ${posts.toString}");
        return posts;
      }
      return [];
    } catch (e){
      print("error in get own post");
      print(e.toString());
      return [];
    }
  }

  // delete post
  Future<bool> deletePost(int postId) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.DeletePostURL + postId.toString());
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.delete(url, headers: header);
      if (response.statusCode == 200){

        return true;
      }else{
        return false;
      }

    } catch (e){
      print("error to delete post");
      print(e.toString());
      return false;
    }
  }

  // delete action post
  Future<bool> deleteActPost(int postId) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.DeleteActionPostURL + postId.toString());
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.delete(url, headers: header);
      if (response.statusCode == 200){

        return true;
      }else{
        return false;
      }

    } catch (e){
      print("error to delete action post");
      print(e.toString());
      return false;
    }
  }

  // get post comments
  Future<List<PostComment>> fetchPostComments(int postId) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.GetPostCommentsURL + "?postId=" + postId.toString());
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200){
        List<dynamic> jsonData = json.decode(response.body);

        // Assuming the JSON data is a List of posts
        List<PostComment> postComments = jsonData.map((e) => PostComment.fromJson(e)).toList();
        print("post: ${postComments.toString}");
        return postComments;
      }
      return [];
    } catch (e){
      print("error in get own post");
      print(e.toString());
      return [];
    }
  }

  // New Post Comment
  Future<bool> newComment(String description,int postId) async {

    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    try {
      var url = Uri.parse(APIConstant.NewCommentURL);

      // to serialize the data Map to JSON
      var body = json.encode(
          {
            'description': description,
            'postId': postId,
          }
          );

      var response = await http.post(url,
          headers:
          {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token}",
          },
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

  // Edit Post
  Future<bool> editPost(String description,int postId) async {

    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    try {
      var url = Uri.parse(APIConstant.EditPostURL + postId.toString());

      // to serialize the data Map to JSON
      var body = json.encode(
          {
            'description': description,
          }
      );

      var response = await http.put(url,
          headers:
          {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token}",
          },
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

  // update action post
  Future<bool> actionPost(int postId, int actionTypeId) async {

    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    try {
      var url = Uri.parse(APIConstant.ActionPostURL);

      // to serialize the data Map to JSON
      var body = json.encode(
          {
            'postId': postId,
            'actionTypeId': actionTypeId,
          }
      );

      var response = await http.put(url,
          headers:
          {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token}",
          },
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

  // get all posts of a user by ID when search user
  Future<List<Post>> getAllPostsByUserId(int userid) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.SearchUserGetPostURL + userid.toString());
      print("getallpostbyuserid : ${url}");
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200){
        List<dynamic> jsonData = json.decode(response.body);

        // Assuming the JSON data is a List of posts
        return jsonData.map((e) => Post.fromJson(e)).toList();
      }
      return [];
    } catch (e){
      print("error in get own post");
      print(e.toString());
      return [];
    }
  }

}