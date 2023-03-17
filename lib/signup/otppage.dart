import 'dart:async';

import 'package:easyshopping/signup/setpassword.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:easyshopping/modalclass.dart';

class Otppage extends StatefulWidget {
  String email;

  Otppage(this.email);

  @override
  State<Otppage> createState() => _OtppageState();
}

class _OtppageState extends State<Otppage> {
  late Timer timer;
  int start = 30;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sendotp1();
    startTimer();
  }

  void sendotp1() async {
    EmailAuth emailAuth =
        EmailAuth(sessionName: "Ragisteration on easyshopping");

    var res = await emailAuth.sendOtp(recipientMail: widget.email);
  }

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
                      "Email Verification",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "animation",
                          letterSpacing: 3,
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Lottie.asset("assets/otpverification.json"),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      "otp sent to ${widget.email}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Pinput(
                      length: 6,
                      defaultPinTheme: PinTheme(
                        width: 56,
                        height: 56,
                        textStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                        decoration: BoxDecoration(
                          color: Colors.purple[900],
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (s) {
                        var res = EmailAuth(
                                sessionName: "Ragisteration on easyshopping")
                            .validateOtp(
                                recipientMail: widget.email,
                                userOtp: s.toString());
                        if (res) {
                          EasyLoading.showSuccess("otp verified");
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                            return setpass();
                          },));
                        } else {
                          return 'Incorrect otp';
                        }
                      },
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onCompleted: (pin) => print(pin),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive OTP?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          style: ButtonStyle(alignment: Alignment.centerLeft),
                            onPressed: () {
                              if(start==0)
                                {
                                  EasyLoading.showSuccess("otp sent successfully");
                                  startTimer();
                                  start = 5;
                                  sendotp1();
                                }

                            },
                            child: Text(
                              timer.isActive ? "$start" : "Resend",
                              style: TextStyle(
                                  color: Colors.purple[900],
                                  fontWeight: FontWeight.bold,
                                  decoration: start==0 ? TextDecoration.underline : TextDecoration.none,
                                  decorationColor: Colors.purple[900]),
                            )),
                      ],
                    ),
                  ),
                  Text("please check otp on your spam box",style: TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
