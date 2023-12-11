import 'dart:convert';
import 'dart:core';
import 'package:CatViP/model/user/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:CatViP/repository/APIConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository{

  Future<UserModel?> getUser() async {
    try{
      dynamic user_data;
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      if (token!.isNotEmpty) {
        var url = Uri.parse(APIConstant.viewProfileURL);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var response = await http.get(url, headers: header);

        if (response.statusCode == 200){
          var value = response.body;
          var jsonValue = json.decode(value);
          user_data =  UserModel.fromJson(jsonValue);
          return user_data;
        } else {
          print(response.statusCode);
        }
      }
    } catch (error){
      print('error in get user ');
      print(error.toString());
    }
    return null;
  }

  Future<bool> updateUser(UserModel user) async {
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");

      if (token!.isNotEmpty) {
        var url = Uri.parse(APIConstant.editProfileURL);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var body = json.encode({
          "fullName": user.fullname,
          "dateOfBirth": user.dateOfBirth,
          "gender": user.gender,
          "address": user.address,
          "longitude": user.longitude,
          "latitude": user.latitude,
          "profileImage": user.profileImage
        });
        var response = await http.put(url, headers: header, body: body);

        if (response.statusCode == 200){
          return true;
        } else {
          print("response fail: ${response.statusCode}");
          print("response fail: ${response.body}");
        }
      }
      return false;
    } catch (e){
      print("error in updating user ${e.toString()}");
      return false;
    }
  }

  Future<List<UserModel>> getSearchResult(String name) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      if (token!.isNotEmpty){
        var url = Uri.parse(APIConstant.searchUserURL + name.toString());
        var header = {
          "Content-Type": "application/json",
          "Authorization" : "Bearer ${token}"
        };

        var response = await http.get(url, headers: header);
        if (response.statusCode == 200){
          List<dynamic> jsonValue = json.decode(response.body);
          return jsonValue.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();        } else{
        }
      }
      return [];
    } catch (e){
      print("error in searching user: ${e.toString()}");
      return [];
    }
  }

  Future<UserModel?> getSearchUserInfo(int userid) async {
    try{
      dynamic user_data;
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      if (token!.isNotEmpty) {
        var url = Uri.parse(
            APIConstant.getSearchUserInfoURL + userid.toString());
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}"
        };
        var response = await http.get(url, headers: header);
        if (response.statusCode == 200) {
          var result = jsonDecode(response.body);
          return UserModel.fromJson(result);
        }
      }
      return null;
    } catch(e){
      print("error in getting one result of search user: ${e.toString()}");
      return null;
    }
  }

  Future<int> followUser(int userid) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      if (token!.isNotEmpty) {
        var url = Uri.parse(APIConstant.followURL + userid.toString());
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}"
        };
        var response = await http.post(url, headers: header);
        if (response.statusCode == 200) {
          return 1;
        } else if (response.statusCode == 400){
          return 0;
        }
        print("Follow user error: ${response.statusCode}: ${response.body}");
      }

      return 3;
    } catch (e) {
      print("Error in following user ${e.toString()}");
      return 3;
    }
  }

  Future<int> unfollowUser(int userid) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      if (token!.isNotEmpty) {
        var url = Uri.parse(APIConstant.unfollowURL + userid.toString());
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}"
        };
        var response = await http.delete(url, headers: header);
        if (response.statusCode == 200) {
          return 1;
        } else if (response.statusCode == 400){
          return 0;
        }
        print("Unfollow user error: ${response.statusCode}: ${response.body}");
      }
      return 3;
    } catch (e) {
      print("Error in unfollowing user ${e.toString()}");
      return 3;
    }
  }
}
