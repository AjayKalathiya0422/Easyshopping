import 'package:animated_text/animated_text.dart';
import 'package:easyshopping/homepage/homepage.dart';
import 'package:easyshopping/loginpage.dart';
import 'package:easyshopping/modalclass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    builder: EasyLoading.init(),
    debugShowCheckedModeBanner: false,
    home: splashscreen(),
  ));
  modal.easyload();
}

class splashscreen extends StatefulWidget {
  const splashscreen({Key? key}) : super(key: key);

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    naviagtor();
  }

  void naviagtor() async {
    modal.preference = await SharedPreferences.getInstance();
    bool stt = modal.preference!.getBool("loginst") ?? false;

    if (await modal.getinternetconnectivity()) {
      if (stt) {
        Future.delayed(Duration(
          seconds: 2,
        )).then((value) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return homepage();
            },
          ));
        });
      } else {
        Future.delayed(Duration(
          seconds: 2,
        )).then((value) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return login();
            },
          ));
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Connection lost !",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content:
            Text("Please connect internet or wifi after click on retry"),
            actions: [
              TextButton(
                  onPressed: ()  {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return splashscreen();
                    },));
                  },
                  child: Text(
                    "Try again",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 15),
                  ))
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context1) {
    double twidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 300,
                width: 300,
                child:
                    Lottie.asset("assets/splashlottie.json", fit: BoxFit.fill),
              ),
            ),
            Center(
              child: Container(
                height: 70,
                width: twidth,
                child: AnimatedText(
                  alignment: Alignment.center,
                  speed: Duration(milliseconds: 1000),
                  controller: AnimatedTextController.loop,
                  displayTime: Duration(milliseconds: 1000),
                  wordList: ['Easy', 'Shooping', 'with', 'Us'],
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontFamily: "animation",
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                height: 100,
                width: 100,
                child: Lottie.asset("assets/splashloading.json"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
