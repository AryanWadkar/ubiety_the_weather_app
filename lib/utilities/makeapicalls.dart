import 'package:flutter/services.dart';
import 'package:http/http.dart' as httppackage;
import 'dart:convert';
import 'package:flutter/material.dart';

const API_key='2bb57e14da1bd899481d42cf3276243a';
const generalurl = 'https://api.openweathermap.org/data/2.5/weather';

class NetworkManager{

  Future makeinitialapicall(String lat, String lon,BuildContext context)async{
    Uri url = Uri.parse('$generalurl?lat=$lat&lon=$lon&appid=$API_key&units=metric');
    try{
      httppackage.Response apireturn = await httppackage.get(url);
      if(apireturn.statusCode != 200)
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error retrieving data for your location!"),
          duration: Duration(seconds: 8),
        ));
        SystemNavigator.pop();
      }
      else{
        return jsonDecode(apireturn.body);
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error retrieving data for your location!"),
        duration: Duration(seconds: 8),
      ));
      return 1;
    }


  }

  Future makerequestedapicall(String cityname,BuildContext context)async{
    Uri url = Uri.parse('$generalurl?q=$cityname&appid=$API_key&units=metric');
    try{
      httppackage.Response apireturn = await httppackage.get(url);
      if(apireturn.statusCode != 200)
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error retrieving data for requested city!"),
          duration: Duration(seconds: 8),
        ));
        return '1';
      }
      else{
        return jsonDecode(apireturn.body);
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Internet not connected!"),
        duration: Duration(seconds: 8),
      ));
      return '1';
    }
  }
}