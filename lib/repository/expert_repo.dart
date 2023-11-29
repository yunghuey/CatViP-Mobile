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

  Future<List<ExpertApplyModel>> getAllMyApplication() async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.GetAllSingleURL);
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200){
        List result = jsonDecode(response.body);
        return result.map((e) => ExpertApplyModel.fromJson(e)).toList();
      } else {
        print("error: ${response.statusCode} : ${response.body}");
      }
      return [];

    } catch (e){
      print("error in get all my application ${e.toString()}");
      return [];
    }
  }
}