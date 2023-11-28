import 'package:CatViP/model/cat/cat_model.dart';
import 'package:http/http.dart' as http;
import 'package:CatViP/repository/APIConstant.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CatRepository{

  Future<bool> createCat(CatModel cat) async {
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      if (token!.isNotEmpty){
        var url = Uri.parse(APIConstant.NewCatURL);
        // String image1 = image.toString();
        var body = json.encode({
          "name": cat.name,
          "description": cat.desc,
          "dateOfBirth": cat.dob,
          "gender": cat.gender,
          "profileImage": cat.profileImage,
        });

        print(body.toString());
        var response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token}",
          },
          body: body,
        );

        if (response.statusCode == 200) {
          return true;
        } else {
          print(response.statusCode);
          print(response.body);
        }
      }
    //   failed to get token
      return false;

    } catch (e) {
      print('error in create cat');
      print(e.toString());
      return false;
    }
  }

  Future<List<CatModel>> getAllCats() async {
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.GetMyCatURL);
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200){
        List result = jsonDecode(response.body);
        print(result);
        return result.map((e) => CatModel.fromJson(e)).toList();
      }
      print(response.statusCode);
      print(response.body);
      return [];
    } catch (e){
      print("error in get all cats");
      print(e.toString());
      return [];
    }
  }

  Future<bool> updateCat(CatModel cat) async {
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.UpdateCatURL+ cat.id.toString());
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var body = json.encode({
        "name": cat.name,
        "description": cat.desc,
        "dateOfBirth": cat.dob,
        "gender": cat.gender,
        "profileImage": cat.profileImage
      });

      var response = await http.put(url, headers: header, body: body);

      if (response.statusCode == 200){
        return true;
      }
      return false;
    } catch (e){
      print("error in updating cat");
      print(e.toString());
      return false;
    }
  }

  Future<bool> removeCat(int id) async {
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.DeleteCatURL+ id.toString());
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.delete(url, headers: header);

      if (response.statusCode == 200){
        return true;
      }
      return false;
    } catch(e){
      print("error in deleting cat");
      print(e.toString());
      return false;
    }
  }

  Future<CatModel?> getCat(int catid) async {
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.GetOneCatURL + catid.toString());
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      print(url);
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200){
        var result = jsonDecode(response.body);
        print(result);
        return CatModel.fromJson(result);
      }
      print(response.statusCode);
      print(response.body);
      return null;
    } catch (e){
      print("error in get one cat");
      print(e.toString());
      return null;
    }
  }

}