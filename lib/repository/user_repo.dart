import 'dart:convert';

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
          print("receive 200");
          print(jsonValue.toString());
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
        print(body.toString());
        var response = await http.put(url, headers: header, body: body);

        if (response.statusCode == 200){
          print("profile updated");
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
}