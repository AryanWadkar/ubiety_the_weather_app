import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:ubiety_the_weather_app/utilities/get_location.dart';
import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void getnewuserlocation() async {
    UserLocation newuser = UserLocation();
    var response = await newuser.getuserlocationdata(context);
    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              userlocationjson: response,
            ),
          ),
        );

  }

  @override
  void initState() {
    super.initState();
    getnewuserlocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color(0xFF40C4FF),
                Color(0xFF70DDF2),
              ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(top: 60),
                child: Column(
                  children: [
                    Hero(
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
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'The Weather App',
                      style: TextStyle(
                        fontFamily: 'MontserratAlt',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              JumpingDotsProgressIndicator(
                fontSize: 40,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
