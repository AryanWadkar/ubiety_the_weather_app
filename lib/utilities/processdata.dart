import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class DataProcess {
  int currtime = DateTime.now().toUtc().millisecondsSinceEpoch;
  String temperature = '--';
  String cityname = '--';
  IconData condition = Icons.error;
  String mintemp = '--';
  String maxtemp = '--';
  String pressure = '--';
  String humidity = '--';
  String speed = '--';
  String direction = '--';
  String description = '--';
  String setorrise = '--';
  String country = '--';
  Duration duration = Duration(hours: 0, seconds: 0, minutes: 0);
  DateTime timetosetorrise = DateTime(0, 0, 0, 0, 0, 0);
  int timezone = 0;
  String zone = '(GMT--)';
  void nullify() {
    temperature = '--';
    cityname = '--';
    condition = Icons.error;
    mintemp = '--';
    maxtemp = '--';
    pressure = '--';
    humidity = '--';
    speed = '--';
    direction = '--';
    description = '--';
    setorrise = '--';
    country = '--';
    duration = Duration(hours: 0, seconds: 0, minutes: 0);
    timetosetorrise = DateTime(0, 0, 0, 0, 0, 0);
  }

  void decodedata(List decodedjsonedited) {
    timezone = decodedjsonedited[13];
    temperature = decodedjsonedited[0];
    cityname = decodedjsonedited[1];
    condition = calculatecondition(int.parse(decodedjsonedited[2]));
    mintemp = decodedjsonedited[3] + '°C';
    maxtemp = decodedjsonedited[4] + '°C';
    pressure = decodedjsonedited[5] + ' mb';
    humidity = decodedjsonedited[6] + ' %';
    speed = decodedjsonedited[7] + ' kmph';
    direction = findwinddirection(int.parse(decodedjsonedited[8]));
    description = decodedjsonedited[9];
    country = decodedjsonedited[10];
    setorrise =
        riseorset(currtime, decodedjsonedited[11], decodedjsonedited[12]);
    duration = timetogo(currtime, decodedjsonedited[11], decodedjsonedited[12]);
    timetosetorrise =
        tosetortorise(decodedjsonedited[11], decodedjsonedited[12]);
    zone = timeZone(timezone ~/ 1000);
  }

  IconData calculatecondition(int conditionvalue) {
    IconData currentcondition = Icons.error;
    if (conditionvalue >= 200 && conditionvalue <= 232) {
      currentcondition = WeatherIcons.thunderstorm;
    } else if (conditionvalue >= 300 && conditionvalue <= 321) {
      currentcondition = WeatherIcons.sprinkle;
    } else if (conditionvalue >= 500 && conditionvalue <= 531) {
      currentcondition = WeatherIcons.rain;
    } else if (conditionvalue >= 600 && conditionvalue <= 622) {
      currentcondition = WeatherIcons.snow;
    } else if (conditionvalue >= 801 && conditionvalue <= 804) {
      currentcondition = WeatherIcons.cloud;
    } else if (conditionvalue == 800) {
      currentcondition = WeatherIcons.day_sunny;
    } else if (conditionvalue == 701) {
      currentcondition = WeatherIcons.windy;
    } else if (conditionvalue == 711) {
      currentcondition = WeatherIcons.smoke;
    } else if (conditionvalue == 721) {
      currentcondition = WeatherIcons.day_haze;
    } else if (conditionvalue == 731) {
      currentcondition = WeatherIcons.dust;
    } else if (conditionvalue == 741) {
      currentcondition = WeatherIcons.fog;
    } else if (conditionvalue == 751) {
      currentcondition = WeatherIcons.sandstorm;
    } else if (conditionvalue == 761 || conditionvalue == 762) {
      currentcondition = WeatherIcons.dust;
    } else if (conditionvalue == 781 || conditionvalue == 781) {
      currentcondition = WeatherIcons.tornado;
    }
    return currentcondition;
  }

  String findwinddirection(int degrees) {
    String dir = '--';
    if (degrees == 0) {
      dir = "E";
    } else if (degrees == 90) {
      dir = "N";
    } else if (degrees == 180) {
      dir = "W";
    } else if (degrees == 270) {
      dir = "S";
    } else if (degrees > 0 && degrees < 90) {
      dir = "NE";
    } else if (degrees > 90 && degrees < 180) {
      dir = "NW";
    } else if (degrees > 180 && degrees < 270) {
      dir = "SW";
    } else if (degrees > 270 && degrees < 360) {
      dir = "SE";
    }
    return dir;
  }

  Duration timetogo(
    int ctime,
    int rtime,
    int stime,
  ) {
    if (setorrise == 'rise') {
      double timeleft = (rtime.toDouble()) - (ctime.toDouble());
      double hours = timeleft / 3600000.ceil();
      timeleft = (timeleft / 3600000.ceil() - hours.toInt()) * 60;
      double mins = timeleft.ceilToDouble();
      double secs = (timeleft - timeleft.toInt()) * 60;
      return Duration(
          hours: hours.toInt(), minutes: mins.toInt(), seconds: secs.toInt());
    } else if (setorrise == 'set') {
      double timeleft = (stime.toDouble()) - (ctime.toDouble());
      double hours = timeleft / 3600000.ceil();
      timeleft = (timeleft / 3600000.ceil() - hours.toInt()) * 60;
      double mins = timeleft.ceilToDouble();
      double secs = (timeleft - timeleft.toInt()) * 60;
      return Duration(
          hours: hours.toInt(), minutes: mins.toInt(), seconds: secs.toInt());
    } else {
      return Duration(seconds: 0, hours: 0, minutes: 0);
    }
  } //0

  String riseorset(int ctime, int rtime, int stime) {
    String sett = '--';
    if (ctime < rtime) {
      sett = 'rise';
    } else if (ctime > rtime && ctime < stime) {
      sett = 'set';
    } else if (ctime > rtime && ctime > stime) {
      sett = 'done for the day';
    } else {
      sett = '--';
    }
    return sett;
  }

  DateTime tosetortorise(int rtime, int stime) {
    if (setorrise == 'rise') {
      return DateTime.fromMillisecondsSinceEpoch(rtime + timezone).toUtc();
    } else if (setorrise == 'set') {
      return DateTime.fromMillisecondsSinceEpoch(stime + timezone).toUtc();
    } else {
      return DateTime(0, 0, 0, 0, 0, 0);
    }
  }

  String timeZone(int tz) {
    String zone = '(GMT--)';
    if (setorrise == 'done for the day') {
      zone = '--';
    } else if (tz == 0) {
      zone = '(GMT+00:00)';
    } else if (tz == 3600) {
      zone = '(GMT+01:00)';
    } else if (tz == 7200) {
      zone = '(GMT+02:00)';
    } else if (tz == 10800) {
      zone = '(GMT+03:00)';
    } else if (tz == 14400) {
      zone = '(GMT +04:0)0';
    } else if (tz == 19800) {
      zone = '(GMT+05:30)';
    } else if (tz == 12600) {
      zone = '(GMT+03:30)';
    } else if (tz == 16200) {
      zone = '(GMT+04:30)';
    } else if (tz == 18000) {
      zone = '(GMT+05:00)';
    } else if (tz == 20700) {
      zone = '(GMT+05:45)';
    } else if (tz == 21600) {
      zone = '(GMT+06:00)';
    } else if (tz == 23400) {
      zone = '(GMT+06:30)';
    } else if (tz == 25200) {
      zone = '(GMT+07:00)';
    } else if (tz == 28800) {
      zone = '(GMT+08:00)';
    } else if (tz == 31500) {
      zone = '(GMT+08:45)';
    } else if (tz == 32400) {
      zone = '(GMT+09:00)';
    } else if (tz == 34200) {
      zone = '(GMT+09:30)';
    } else if (tz == 36000) {
      zone = '(GMT+10:00)';
    } else if (tz == 37800) {
      zone = '(GMT+10:30)';
    } else if (tz == 39600) {
      zone = '(GMT+11:00)';
    } else if (tz == 43200) {
      zone = '(GMT+12:00)';
    } else if (tz == 46800 || tz == -39600) {
      zone = '(GMT+13:00)';
    } else if (tz == 50400 || tz == -36000) {
      zone = '(GMT+14:00)';
    } else if (tz == -32400) {
      zone = '(GMT-09:00)';
    } else if (tz == -34200) {
      zone = '(GMT-09:30)';
    } else if (tz == -28800) {
      zone = '(GMT-08:00)';
    } else if (tz == -25200) {
      zone = '(GMT-07:00)';
    } else if (tz == -21600) {
      zone = '(GMT-06:00)';
    } else if (tz == -18000) {
      zone = '(GMT-05:00)';
    } else if (tz == -14400) {
      zone = '(GMT-04:00)';
    } else if (tz == -10800) {
      zone = '(GMT-03:00)';
    } else if (tz == -12600) {
      zone = '(GMT-03:30)';
    } else if (tz == -7200) {
      zone = '(GMT-02:00)';
    } else if (tz == -3600) {
      zone = '(GMT-01:00)';
    }
    return zone;
  }
}
