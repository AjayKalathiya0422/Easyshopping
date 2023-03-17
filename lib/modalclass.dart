import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class modal {

  static  List<String> catagorieslist = [
    'Mobiles',
    'Shoes',
    'Cloths',
    'Sun glasses',
  ];

  static void connectionbox(BuildContext context)
  {
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
                onPressed: () {
                  Navigator.pop(context);
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

  static SharedPreferences? preference;

  static TextStyle style1 = TextStyle(
      color: Colors.purple[900],
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
      decorationColor: Colors.purple[900]);

  static Future<bool> getinternetconnectivity() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }


  static String? addemail;
  static String? addcontact;
  static String? addpass;

  static OutlineInputBorder focusandenable = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(20),
  );
  static OutlineInputBorder errorborder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
    borderRadius: BorderRadius.circular(20),
  );

   static List<String> warranty = ['Yes', 'No'];

  static void easyload() {
    EasyLoading.instance.userInteractions = false;
    EasyLoading.instance.backgroundColor = Colors.purple[900];
    EasyLoading.instance.textColor = Colors.white;
    EasyLoading.instance.indicatorColor = Colors.white;
    EasyLoading.instance.indicatorSize = 40;
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.dualRing;
    EasyLoading.instance.animationDuration = Duration(seconds: 1);
  }

  static void dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: 300,
            width: 200,
            color: Colors.purple[900],
            child: Column(
              children: [
                Container(
                    height: 50,
                    width: 200,
                    alignment: Alignment.center,
                    child: Text(
                      "Check your internet!",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20,letterSpacing: 1),
                    )),
                Container(
                    height: 200,
                    child: Lottie.asset("assets/internetlost.json")),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red[900]),
                    ),
                    onPressed: () async {
                      if (await InternetConnectionChecker().hasConnection) {
                        Navigator.pop(context);
                      } else {
                        dialog(context);
                      }
                    },
                    child: Text(
                      "Retry",
                      style: TextStyle(letterSpacing: 2,fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}
