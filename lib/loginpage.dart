import 'dart:convert';

import 'package:easyshopping/homepage/homepage.dart';
import 'package:easyshopping/signup/welcomeback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:easyshopping/modalclass.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool obstractst = true;
  bool emailandphone = false;
  bool emailst = false;
  bool passst = false;

  SnackBar snackBar = SnackBar(content: Text("User not found"));

  Border hoverborder =
      Border(bottom: BorderSide(color: Colors.purple.shade900, width: 2));

  @override
  Widget build(BuildContext context) {
    double twidth = MediaQuery.of(context).size.width;
    double stbar = MediaQuery.of(context).padding.top;
    double navigation = MediaQuery.of(context).padding.bottom;
    double theight = MediaQuery.of(context).size.height;
    double bodyheight = theight - stbar - navigation;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: bodyheight,
          width: twidth,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "assets/login_top.png",
                  fit: BoxFit.cover,
                  width: twidth * 0.35,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  "assets/login_bottom.png",
                  fit: BoxFit.cover,
                  width: twidth * 0.2,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Login Account",
                        style: TextStyle(
                            fontSize: 30,
                            letterSpacing: 3,
                            fontWeight: FontWeight.bold,
                            fontFamily: "animation"),
                      ),
                    ),
                    Lottie.asset("assets/loginlottie.json",
                        height: bodyheight * 0.3),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                email.text = "";
                                FocusManager.instance.primaryFocus?.unfocus();
                                emailandphone = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                  border: emailandphone ? null : hoverborder),
                              child: Text(
                                "Email",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                email.text = "";
                                FocusManager.instance.primaryFocus?.unfocus();
                                emailandphone = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: emailandphone ? hoverborder : null),
                              child: Text(
                                "phone number",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      height: 80,
                      width: twidth * 0.8,
                      child: TextField(
                        cursorColor: Colors.black,
                        maxLines: 1,
                        maxLength: emailandphone ? 10 : null,
                        controller: email,
                        keyboardType: emailandphone
                            ? TextInputType.number
                            : TextInputType.text,
                        decoration: InputDecoration(
                          errorText: emailst
                              ? emailandphone
                                  ? "Enter valid phone number"
                                  : "Enter valid email"
                              : null,
                          isDense: true,
                          prefixIcon: emailandphone
                              ? Icon(
                                  Icons.phone,
                                  color: Colors.purple[900],
                                )
                              : Icon(
                                  Icons.email,
                                  color: Colors.purple[900],
                                ),
                          hintText: emailandphone
                              ? "Enter phone number"
                              : "Enter email",
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
                      height: 70,
                      width: twidth * 0.8,
                      child: TextField(
                        obscureText: obstractst ? true : false,
                        maxLines: 1,
                        maxLength: 16,
                        cursorColor: Colors.black,
                        controller: password,
                        decoration: InputDecoration(
                          errorText: passst ? "Enter password" : null,
                          suffixIcon: obstractst
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obstractst = false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.purple[900],
                                  ))
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obstractst = true;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.lock_open,
                                    color: Colors.purple[900],
                                  )),
                          isDense: true,
                          prefixIcon: Icon(
                            Icons.password,
                            color: Colors.purple[900],
                          ),
                          hintText: "Enter password",
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
                      margin: EdgeInsets.only(right: 35),
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () async {
                            if (await modal.getinternetconnectivity()) {
                            } else {
                              modal.connectionbox(context);
                            }
                          },
                          child: Text(
                            "Forgot Password",
                            style: modal.style1,
                          )),
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
                              modal.easyload();
                              EasyLoading.show(status: "Please wait");
                              String email1 = email.text;
                              String pass1 = password.text;

                              bool st = false;

                              emailst = false;
                              passst = false;

                              setState(() {
                                if (email1.isEmpty) {
                                  Future.delayed(Duration(seconds: 2))
                                      .then((value) {
                                    EasyLoading.dismiss(animation: false);
                                  });
                                  emailst = true;
                                } else if (pass1.isEmpty) {
                                  Future.delayed(Duration(seconds: 2))
                                      .then((value) {
                                    EasyLoading.dismiss(animation: false);
                                  });
                                  passst = true;
                                } else {
                                  st = true;
                                }
                              });

                              if (st) {
                                Map map = {"email": email1, "password": pass1};

                                var url = Uri.parse(
                                    'https://easyshopping1344.000webhostapp.com/apicalling/login.php');
                                var response = await http.post(url, body: map);
                                print(
                                    'Response status: ${response.statusCode}');
                                print('Response body: ${response.body}');

                                var data = await jsonDecode(response.body);

                                if (await data['connection'] == 1 &&
                                    data['login'] == 1) {
                                  Logindata dd = Logindata.fromJson(data);
                                  EasyLoading.dismiss(animation: false);
                                  EasyLoading.showSuccess("Login successful");


                                  modal.preference!.setBool("loginst", true);

                                  modal.preference!
                                      .setString('id', dd.details.id);
                                  modal.preference!
                                      .setString('name', dd.details.name);
                                  modal.preference!
                                      .setString('phone', dd.details.phone);
                                  modal.preference!
                                      .setString('email', dd.details.email);
                                  modal.preference!.setString(
                                      'password', dd.details.password);
                                  modal.preference!
                                      .setString('dob', dd.details.dob);
                                  modal.preference!
                                      .setString('address', dd.details.address);
                                  modal.preference!.setString(
                                      'profilephoto', dd.details.profilephoto);

                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return homepage();
                                    },
                                  ));
                                } else {
                                  EasyLoading.dismiss(animation: false);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }
                            } else {
                              modal.connectionbox(context);
                            }
                          },
                          child: Text(
                            "LOGIN",
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
                            "Don't have an Account ?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                              onPressed: () async {
                                if (await modal.getinternetconnectivity()) {
                                  modal.easyload();
                                  EasyLoading.show(status: "Please wait");
                                  Future.delayed(Duration(seconds: 2))
                                      .then((value) {
                                    EasyLoading.dismiss(animation: false);
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return welcomeback();
                                      },
                                    ));
                                  });
                                } else {
                                  modal.connectionbox(context);
                                }
                              },
                              child: Text(
                                "sign up",
                                style: modal.style1,
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class Logindata {
  Logindata(
    this.connection,
    this.login,
    this.result,
    this.details,
  );

  int connection;
  int login;
  int result;
  Details details;

  factory Logindata.fromJson(Map<String, dynamic> json) => Logindata(
        json["connection"],
        json["login"],
        json["result"],
        Details.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "connection": connection,
        "login": login,
        "result": result,
        "details": details.toJson(),
      };
}

class Details {
  Details(
    this.id,
    this.name,
    this.phone,
    this.email,
    this.password,
    this.dob,
    this.address,
    this.profilephoto,
  );

  String id;
  String name;
  String phone;
  String email;
  String password;
  String dob;
  String address;
  String profilephoto;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        json["Id"],
        json["Name"],
        json["Phone"],
        json["Email"],
        json["Password"],
        json["Dob"],
        json["Address"],
        json["Profilephoto"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Phone": phone,
        "Email": email,
        "Password": password,
        "Dob": dob,
        "Address": address,
        "Profilephoto": profilephoto,
      };
}
