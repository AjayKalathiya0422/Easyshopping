import 'package:easyshopping/modalclass.dart';
import 'package:easyshopping/signup/basicprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';

class setpass extends StatefulWidget {
  const setpass({Key? key}) : super(key: key);

  @override
  State<setpass> createState() => _setpassState();
}

class _setpassState extends State<setpass> {
  bool passstatus = true;
  TextEditingController pass = TextEditingController();
  TextEditingController cpass = TextEditingController();

  bool passst = false;
  bool cpassst = false;

  String cpasserror = "";

  @override
  Widget build(BuildContext context) {
    double twidth = MediaQuery.of(context).size.width;
    double stbar = MediaQuery.of(context).padding.top;
    double navigation = MediaQuery.of(context).padding.bottom;
    double theight = MediaQuery.of(context).size.height;
    double bodyheight = theight - stbar - navigation;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/signup_top.png",
                fit: BoxFit.cover,
                width: twidth * 0.35,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              width: twidth * 0.2,
              child: Image.asset(
                "assets/signup_bottom.png",
                fit: BoxFit.cover,
                width: theight * 0.2,
              ),
            ),
            Container(
              height: bodyheight,
              width: twidth,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      width: twidth,
                      child: Text(
                        "Set password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "animation",
                            letterSpacing: 3,
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Lottie.asset("assets/passwordset.json",height: 300),
                    Container(
                      height: 80,
                      width: twidth * 0.8,
                      child: TextField(
                        obscureText: passstatus,
                        maxLines: 1,
                        controller: pass,
                        cursorColor: Colors.black,
                        maxLength: 16,
                        decoration: InputDecoration(
                          isDense: true,
                          errorText: passst ? "Enter password" : null,
                          suffixIcon: passstatus
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passstatus = false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.purple[900],
                                  ))
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passstatus = true;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.lock_open,
                                    color: Colors.purple[900],
                                  )),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.purple[900],
                          ),
                          hintText: "Password",
                          fillColor: Colors.grey[300],
                          filled: true,
                          focusedErrorBorder: modal.errorborder,
                          errorBorder: modal.errorborder,
                          focusedBorder: modal.focusandenable,
                          enabledBorder: modal.focusandenable,
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: twidth * 0.8,
                      child: TextField(
                        controller: cpass,
                        obscureText: passstatus,
                        maxLines: 1,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          isDense: true,
                          errorText: cpassst ? cpasserror : null,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.purple[900],
                          ),
                          hintText: "Confirm Password",
                          fillColor: Colors.grey[300],
                          filled: true,
                          errorBorder: modal.errorborder,
                          focusedErrorBorder: modal.errorborder,
                          focusedBorder: modal.focusandenable,
                          enabledBorder: modal.focusandenable,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: twidth * 0.8,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.purple[900]),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ))),
                          onPressed: () async {
                            String pass1 = pass.text;
                            String cpass1 = cpass.text;

                            passst = false;
                            cpassst = false;

                            setState(() {
                              if (pass1.isEmpty) {
                                passst = true;
                                pass1 = "Enter Password";
                              } else if (cpass1.isEmpty) {
                                cpassst = true;
                                cpasserror = "Enter phone number";
                              } else if (pass1 != cpass1) {
                                cpassst = true;
                                cpasserror = "Password not match";
                              } else {
                                modal.addpass = pass1;
                                EasyLoading.show(status: "please wait");
                                Future.delayed(Duration(seconds: 2))
                                    .then((value) {
                                  EasyLoading.dismiss(animation: false);
                                  EasyLoading.showSuccess(
                                      "Password set successfully");
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return basicinfo();
                                    },
                                  ));
                                });
                              }
                            });
                          },
                          child: Text(
                            "Set Password",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, letterSpacing: 2),
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
