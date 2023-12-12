import 'dart:convert';
import 'package:CatViP/model/caseReport/caseReport.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'APIConstant.dart';

class ReportCaseRepository{


  // New Report Case
  Future<bool> newReportCase(
      String description,
      String address,
      double longitude,
      double latitude,
      List<String?> images,
      int? catId
      ) async {

    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    try {
      var url = Uri.parse(APIConstant.CreateCaseReportURL);

      List<Map<String, dynamic>> imageObjects = [];

      if (images != null && images.isNotEmpty) {

        for (String? image in images) {
          Map<String, dynamic> imageObject = {
            'image': image,
            'isBloodyContent': false,
          };

          imageObjects.add(imageObject);
        }
      }

        // to serialize the data Map to JSON
      var body = json.encode({
        'description': description,
        'address': address,
        'longitude': longitude,
        'latitude': latitude,
        'catId': catId == 0 ? null : catId,
        'caseReportImages': imageObjects,

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

  //Get Case Report
  Future<List<CaseReport>> fetchCases() async {
    try {
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      http.Response response = await http.get(
          Uri.parse(APIConstant.GetCaseReportsURL),
          headers: {
            'Authorization': 'Bearer ${token}',
          }
      );

      if (response.statusCode == 200){
        List<dynamic> jsonData = json.decode(response.body);

        // Assuming the JSON data is a List of posts
        List<CaseReport> caseReports = jsonData.map((e) => CaseReport.fromJson(e)).toList();
        return caseReports;
      } else {
        return[CaseReport.withError("Status code: ${response.statusCode}")];
      }
      //List<dynamic> value = response.body as List;
      //return value.map((e) => Post.fromJson(e)).toList();
    }catch(e){
      if(e.toString().contains("SocketException")){
        return[CaseReport.withError("Check your internet connection please")];
      }
      return[CaseReport.withError(e.toString())];
    }

  }

  //   Get Own Case
  Future<List<CaseReport>> fetchMyCase() async{
    try{
      var pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");
      var url = Uri.parse(APIConstant.GetOwnCaseReportURL);
      var header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token}",
      };
      var response = await http.get(url, headers: header);
      if (response.statusCode == 200){
        List<dynamic> jsonData = json.decode(response.body);

        // Assuming the JSON data is a List of posts
        List<CaseReport> posts = jsonData.map((e) => CaseReport.fromJson(e)).toList();
        return posts;
      }
      return [];
    } catch (e){
      print("error in get own post");
      print(e.toString());
      return [];
    }
  }





}