import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'makeapicalls.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class UserLocation {
  Duration wait =Duration(seconds: 8);
  var userweatherdata;
  Future<dynamic> getuserlocationdata(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Internet not connected!"),
        duration: Duration(seconds: 4),
      ));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Enable internet and restart the app"),
        duration: Duration(seconds: 4),
      ));
      await Future.delayed(wait, (){
        return SystemNavigator.pop();
      });
    }
    try{
      Position position = await _determinePosition();
      userweatherdata = await NetworkManager().makeinitialapicall(position.latitude.toString(), position.longitude.toString(), context);
      if(userweatherdata == 1)
        {
          return ['1','2','3'];
        }else{
        return datalist(userweatherdata);
      }

    }catch(e){
      if(e=='1'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Location permissions denied, restart the app and allow."),
          duration: Duration(seconds: 8),
        ));
        Future.delayed(wait, (){
          return SystemNavigator.pop();
        });
      }else if(e=='2'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Location permissions are permanently denied, we cannot request permissions."),
            duration: Duration(seconds: 8)
        ));
        Future.delayed(wait, (){
          return SystemNavigator.pop();
        });
      }
    }

  }

  Future<dynamic> getrequestedlocationdata(String cityname,BuildContext context) async {
    var userweatherdata = await NetworkManager().makerequestedapicall(cityname,context);
    if(userweatherdata == '1'){
      return '1';
    }
    return datalist(userweatherdata);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await openLocationSetting();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('1');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('2');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
  }

  Future<void> openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  List<dynamic> datalist(var decodedjson) {
    List<dynamic> finallist = [];
    finallist.add(decodedjson['main']['temp'].toStringAsFixed(0)); //Temperature 0
    finallist.add(decodedjson['name'].toString()); //City Name 1
    finallist.add(decodedjson['weather'][0]['id'].toString()); //condition 2
    finallist.add(decodedjson['main']['temp_min'].round().toString()); //mint 3
    finallist.add(decodedjson['main']['temp_max'].round().toString()); //maxt 4
    finallist.add(decodedjson['main']['pressure'].toString()); //press 5
    finallist.add(decodedjson['main']['humidity'].toString()); //humidity 6
    finallist.add(decodedjson['wind']['speed'].round().toString()); //speed 7
    finallist.add(decodedjson['wind']['deg'].toString()); //direction 8
    finallist.add(decodedjson['weather'][0]['description']); //desc 9
    finallist.add(decodedjson['sys']['country']); //country 10
    finallist.add(decodedjson['sys']['sunrise']*1000);//sunrise
    finallist.add(decodedjson['sys']['sunset']*1000);//sunet
    finallist.add(decodedjson['timezone']*1000);//timezone
    return finallist;
  }
}
