import 'package:CatViP/model/chat/ChatListModel.dart';
import 'package:CatViP/model/chat/MessageModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'package:CatViP/repository/APIConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository{
  Future<List<ChatListModel>> getAllChatList() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      if (token!.isNotEmpty) {
        var url = Uri.parse(APIConstant.GetChatListURL);
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var response = await http.get(url, headers: header);

        if (response.statusCode == 200) {
          List<dynamic> jsonValue = json.decode(response.body);
          return jsonValue.map((e) =>
              ChatListModel.fromJson(e as Map<String, dynamic>)).toList();
        } else {
          print(response.statusCode);
        }
      }
      return [];
    } catch (e) {
      print("error in getting user chat list ${e.toString()}");
      return [];
    }
  }

  Future<List<MessageModel>> getAllMessages(int userid) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      if (token!.isNotEmpty) {
        var url = Uri.parse(APIConstant.GetChatByUserURL + userid.toString());
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var response = await http.get(url, headers: header);

        if (response.statusCode == 200) {
          List<dynamic> jsonValue = json.decode(response.body);
          return jsonValue.map((e) =>
              MessageModel.fromJson(e as Map<String, dynamic>)).toList();
        } else {
          print(response.statusCode);
        }
      }
      return [];
    } catch(e){
      print("error in getting message list ${e.toString()}");
      return [];
    }
  }

  Future<bool> updateLastSeen(int userid) async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      if (token!.isNotEmpty) {
        var url =  Uri.parse(APIConstant.UpdateLastSeenURL + userid.toString());
        var header = {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}",
        };
        var response = await http.put(url, headers: header);
        if (response.statusCode == 200) {
          return true;
        }
      }
      return false;
    } catch (e){
      print(e.toString());
      return false;
    }
  }
}