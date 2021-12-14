import 'package:flutter/material.dart';
import 'package:ubiety_the_weather_app/utilities/processdata.dart';
import 'package:ubiety_the_weather_app/utilities/get_location.dart';
import 'dart:async';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

DataProcess getdata = DataProcess();
UserLocation newdata = UserLocation();

class HomeScreen extends StatefulWidget {
  final List userlocationjson;
  HomeScreen({required this.userlocationjson});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String cityname = '';
  TextEditingController inputcontroller = TextEditingController();
  Color iconcolor = Colors.grey;

  @override
  void initState() {
    super.initState();
    if (widget.userlocationjson[0] == '1') {
      getdata.nullify();
    } else {
      getdata.decodedata(widget.userlocationjson);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color(0xFF40C4FF),
                Color(0xFF70DDF2),
              ])),
          child: Column(
            children: [
              AppName(),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                padding: EdgeInsets.all(10),
                child: ListTile(
                  title: TextField(
                    controller: inputcontroller,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black45, width: 1.5),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(),
                        hintText: 'Enter City Name',
                        hintStyle: TextStyle(
                            color: Colors.grey[350],
                            fontFamily: 'Montserrat',
                            fontSize: 15)),
                    onChanged: (userip) {
                      cityname = userip;
                    },
                  ),
                  trailing: GestureDetector(
                    onTap: () async {
                      var requestedjsondecoded;
                      if (cityname != '') {
                        setState(() {
                          iconcolor = Colors.black;
                        });
                        requestedjsondecoded = await newdata
                            .getrequestedlocationdata(cityname, context);
                        if (requestedjsondecoded == '1') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Try again!"),
                            duration: Duration(seconds: 4),
                          ));
                          cityname = '';
                        } else {
                          getdata.decodedata(requestedjsondecoded);
                        }
                        inputcontroller.clear();
                        FocusScope.of(context).unfocus();
                        setState(() {
                          iconcolor = Colors.grey;
                        });
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: iconcolor,
                        ),
                        Text(
                          'Request!',
                          style: TextStyle(
                            fontSize: 12,
                            color: iconcolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              WeatherDataCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherDataCard extends StatelessWidget {
  const WeatherDataCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Icon(
                          getdata.condition,
                          size: 80,
                          color: Colors.blue.shade700,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                '${getdata.cityname},',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${getdata.country}',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 2,
                  height: 170,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          '${getdata.temperature}°',
                          style:
                              TextStyle(fontSize: 50, fontFamily: 'Montserrat'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'in Celsius',
                          style:
                              TextStyle(fontFamily: 'Montserrat', fontSize: 20),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          '${getdata.description}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Text(
                'Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5),
              ),
            ),
            Flexible(
              child: ListView(
                children: [
                  WeatherProperty(
                    propname: 'Lowest Temperature ',
                    propvalue: getdata.mintemp,
                    reqicon: Icons.arrow_downward,
                  ),
                  WeatherProperty(
                    propname: 'Highest Temperature ',
                    propvalue: getdata.maxtemp,
                    reqicon: Icons.arrow_upward,
                  ),
                  TimerOrTime(hours: 5, mins: 5, secs: 5),
                  WeatherProperty(
                    propname: 'Wind Speed',
                    propvalue: getdata.speed,
                    reqicon: Icons.speed,
                  ),
                  WeatherProperty(
                    propname: 'Wind Direction',
                    propvalue: getdata.direction,
                    reqicon: Icons.explore,
                  ),
                  WeatherProperty(
                    propname: 'Pressure',
                    propvalue: getdata.pressure,
                    reqicon: Icons.air,
                  ),
                  WeatherProperty(
                    propname: 'Humidity',
                    propvalue: getdata.humidity,
                    reqicon: Icons.water_damage,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AppName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Hero(
        tag: 'logo',
        child: Text(
          'Ubiety',
          style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 50,
              color: Colors.white,
              fontWeight: FontWeight.w200,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

class WeatherProperty extends StatelessWidget {
  final String propname;
  final String propvalue;
  final IconData reqicon;
  final Color color;
  WeatherProperty(
      {required this.propname,
      this.propvalue = '--',
      required this.reqicon,
      this.color = Colors.grey});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('$propname'),
          Row(
            children: [
              Text('$propvalue'),
              SizedBox(
                width: 5,
              ),
              Icon(
                reqicon,
                color: color,
              )
            ],
          ),
        ]));
  }
}

class TimerOrTime extends StatefulWidget {
  final hours;
  final mins;
  final secs;
  TimerOrTime({required this.hours, required this.mins, required this.secs});
  @override
  _TimerOrTimeState createState() => _TimerOrTimeState();
}

class _TimerOrTimeState extends State<TimerOrTime> {
  bool timer = false;
  String ampm = '--';
  Color iconcolor = Colors.grey;
  DateTime rendertime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String goodminute=getdata.timetosetorrise.minute <= 9 ? '0${getdata.timetosetorrise.minute.toString()}' : '${getdata.timetosetorrise.minute.toString()}';
    if (getdata.setorrise == 'rise') {
      ampm = 'AM';
    } else if (getdata.setorrise == 'set') {
      ampm = 'PM';
    } else {
      ampm = '--';
    }
    if (timer) {
      return GestureDetector(
        child: TimerWidget(
          propname: "Sun-${getdata.setorrise}",
          reqicon: Icons.timer,
          color: iconcolor,
          rendertime: rendertime,
        ),
        onTap: () {
          setState(() {
            iconcolor = Colors.black;
          });
          Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
            setState(() {
              iconcolor = Colors.grey;
            });
          });
          setState(() {
            timer = false;
          });
        },
      );
    } else {
      return GestureDetector(
        child: WeatherProperty(
          propname: "Sun-${getdata.setorrise}",
          reqicon: Icons.wb_sunny,
          propvalue:
              '${(getdata.timetosetorrise.hour.toInt() % 12).toString()}:$goodminute $ampm ${getdata.zone}',
          color: iconcolor,
        ),
        onTap: () {
          setState(() {
            iconcolor = Colors.black;
          });
          Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
            setState(() {
              iconcolor = Colors.grey;
            });
          });

          setState(() {
            timer = true;
          });
        },
      );
    }
  }
}

class TimerWidget extends StatelessWidget {
  final String propname;
  final IconData reqicon;
  final Color color;
  final rendertime;
  TimerWidget(
      {required this.propname,
      required this.reqicon,
      this.color = Colors.grey,
      required this.rendertime});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$propname'),
          Row(
            children: [
              TimerCountdown(
                endTime: rendertime.add(getdata.duration),
                format: CountDownTimerFormat.hoursMinutesSeconds,
                enableDescriptions: false,
                spacerWidth: 2,
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                reqicon,
                color: color,
              )
            ],
          ),
        ],
      ),
    );
  }
}
