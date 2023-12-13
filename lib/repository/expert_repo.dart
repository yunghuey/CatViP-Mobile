import 'package:CatViP/model/expert/expert_model.dart';
import 'package:http/http.dart' as http;
import 'package:CatViP/repository/APIConstant.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ExpertRepository{
  Future<bool> createExpert(String desc, String doc) async {
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.NewExpertURL);
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var body = json.encode({
        "description": desc,
        "documentation": doc
      });
      var response = await http.post(url, headers: header, body: body);

      if (response.statusCode == 200){
        return true;
      } else {
        print("Error (${response.statusCode}): ${response.body}");
      }
    return false;
    } catch (e){
      print(e.toString());
      return false;
    }
  }

  Future<ExpertApplyModel?> getMyApplication() async{
    dynamic expert_data;
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.GetApplicationURL);
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200){
        var value = response.body;
        var jsonValue = json.decode(value);
        expert_data =  ExpertApplyModel.fromJson(jsonValue);
        return expert_data;
      }
      print("error: ${response.statusCode} : ${response.body}");
      return null;

    } catch (e){
      print("error in get all my application ${e.toString()}");
      return null;
    }
  }

  Future<bool> revokeApplication(int formid) async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.RevokeApplicationURL+ formid.toString()) ;
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.delete(url, headers: header);

      if (response.statusCode == 200){
        return true;
      }
      print(response.statusCode);
      return false;
    } catch (e){
      print("Error in delete application ${e.toString()}");
      return false;
    }
  }
}