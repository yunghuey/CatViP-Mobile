import 'dart:convert';
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
      String? image,
      int catId
      ) async {

    var pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    try {
      var url = Uri.parse(APIConstant.CreateCaseReportURL);

      // to serialize the data Map to JSON
      var body = json.encode({
        'description': description,
        'address': address,
        'longitude': longitude,
        'latitude': latitude,
        'catId': catId,
        'caseReportImages': [
          {
            'image': image,
            'isBloodyContent': false
          }
        ],

      });
      print(body);

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




}