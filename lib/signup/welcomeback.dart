import 'dart:convert';

import 'package:animated_text/animated_text.dart';
import 'package:easyshopping/loginpage.dart';
import 'package:easyshopping/signup/otppage.dart';
import 'package:easyshopping/signup/setpassword.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:easyshopping/modalclass.dart';

class welcomeback extends StatefulWidget {
  const welcomeback({Key? key}) : super(key: key);

  @override
  State<welcomeback> createState() => _welcomebackState();
}

class _welcomebackState extends State<welcomeback> {
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();

  bool emailst = false;
  bool contactst = false;

  String emailerror = "";
  String contacterror = "";

  RegExp contact_regex = RegExp(r'^[6-9]{1}[0-9]{9}$');

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
                      child: AnimatedText(
                        alignment: Alignment.center,
                        speed: Duration(milliseconds: 1000),
                        controller: AnimatedTextController.loop,
                        displayTime: Duration(milliseconds: 1000),
                        wordList: ['Welcome  back ', 'Easy  shooping'],
                        textStyle: TextStyle(
                            fontFamily: "animation",
                            letterSpacing: 3,
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Lottie.asset("assets/welcome_screen.json"),
                    Container(
                      height: 80,
                      width: twidth * 0.8,
                      child: TextField(
                        controller: email,
                        cursorColor: Colors.black,
                        maxLines: 1,
                        decoration: InputDecoration(
                          isDense: true,
                          errorText: emailst ? emailerror : null,
                          prefixIcon: Icon(
                            Icons.email,
                            size: 25,
                            color: Colors.purple[900],
                          ),
                          hintText: "Enter email",
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
                      height: 80,
                      width: twidth * 0.8,
                      child: TextField(
                        controller: contact,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          isDense: true,
                          errorText: contactst ? contacterror : null,
                          prefixIcon: Icon(
                            Icons.phone,
                            size: 25,
                            color: Colors.purple[900],
                          ),
                          hintText: "Phone number",
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
                            if (await modal.getinternetconnectivity()) {
                              String email1 = email.text;
                              String contact1 = contact.text;
                              bool emst = EmailValidator.validate(email1);
                              bool allcheck = false;

                              emailst = false;
                              contactst = false;

                              setState(() {
                                if (email1.isEmpty) {
                                  emailst = true;
                                  emailerror = "Enter email";
                                } else if (email1.isNotEmpty && emst == false) {
                                  emailst = true;
                                  emailerror = "Invalid email";
                                } else if (contact1.isEmpty) {
                                  contactst = true;
                                  contacterror = "Enter phone number";
                                } else if (!contact_regex.hasMatch(contact1)) {
                                  contactst = true;
                                  contacterror = "Enter valid phone number";
                                } else {
                                  allcheck = true;
                                }
                              });
                              if (allcheck) {
                                Map mm = {"email": email1, "contact": contact1};
                                modal.easyload();
                                EasyLoading.show(status: "Please wait");
                                var url = Uri.parse(
                                    'https://easyshopping1344.000webhostapp.com/apicalling/phoneemailcheck.php');
                                var response = await http.post(url, body: mm);
                                print(
                                    'Response status: ${response.statusCode}');
                                print('Response body: ${response.body}');

                                var data = jsonDecode(response.body);
                                datacheck check = datacheck.fromJson(data);

                                if (await check.connection == 1) {
                                  EasyLoading.dismiss(animation: false);
                                  setState(() {
                                    if (check.email == 0 &&
                                        check.phonenumber == 0) {
                                      emailst = true;
                                      emailerror = "Email already used";
                                      contactst = true;
                                      contacterror =
                                          "Phone number already used";
                                    } else if (check.email == 0) {
                                      emailst = true;
                                      emailerror = "Email already used";
                                    } else if (check.phonenumber == 0) {
                                      contactst = true;
                                      contacterror =
                                          "Phone number already used";
                                    } else {
                                      modal.addemail = email1;
                                      modal.addcontact = contact1;
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                        builder: (context) {
                                          return setpass();
                                        },
                                      ));
                                    }
                                  });
                                }
                              }
                            } else {
                              modal.connectionbox(context);
                            }
                          },
                          child: Text(
                            "SIGNUP",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, letterSpacing: 2),
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an Account ?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                              onPressed: () async {
                                if (await modal.getinternetconnectivity()) {
                                  modal.easyload();
                                  Future.delayed(Duration(seconds: 2))
                                      .then((value) {
                                    EasyLoading.dismiss(animation: false);
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return login();
                                      },
                                    ));
                                  });
                                } else {
                                  modal.connectionbox(context);
                                }
                              },
                              child: Text(
                                "sign in",
                                style: modal.style1,
                              )),
                        ],
                      ),
                    )
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

class datacheck {
  int? connection;
  int? email;
  int? phonenumber;

  datacheck({this.connection, this.email, this.phonenumber});

  datacheck.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    email = json['email'];
    phonenumber = json['phonenumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connection'] = this.connection;
    data['email'] = this.email;
    data['phonenumber'] = this.phonenumber;
    return data;
  }
}
