import 'package:http/http.dart' as http;
import 'package:CatViP/repository/APIConstant.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CatRepository{

  Future<bool> createCat(
      String catname, String desc, String bdayDate, int gender, String image)
      async
  {

    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      if (token!.isNotEmpty){
        bool genderFemale;
        if (gender == 0){ genderFemale = false; }
        else            { genderFemale = true; }

        var url = Uri.parse(APIConstant.NewCatURL);
        // String image1 = image.toString();
        var body = json.encode({
          "name": catname,
          "description": desc,
          "dateOfBirth": bdayDate,
          "gender": genderFemale,
          "profileImage": image,
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
}