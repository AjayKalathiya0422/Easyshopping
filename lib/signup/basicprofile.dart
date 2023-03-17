import 'dart:convert';
import 'dart:io';
import 'package:easyshopping/loginpage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:easyshopping/modalclass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class basicinfo extends StatefulWidget {
  const basicinfo({Key? key}) : super(key: key);

  @override
  State<basicinfo> createState() => _basicinfoState();
}

class _basicinfoState extends State<basicinfo> {
  final ImagePicker _picker = ImagePicker();
  String imagepath = "";
  DateTime selectedDate = DateTime.now();

  TextEditingController name = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController address = TextEditingController();

  bool namest = false;
  bool dobst = false;

  String nameerror = "";
  String doberror = "";

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
                "assets/login_top.png",
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
                      child: const Text(
                        "Basic information",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "animation",
                            letterSpacing: 3,
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: InkWell(
                        onTap: () async {
                          showimagedailog(context);
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                                radius: 50, backgroundImage: getimage()),
                            const Positioned(
                                bottom: 0,
                                right: 0,
                                child: Icon(
                                  Icons.photo_camera,
                                  size: 30,
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 80,
                      width: twidth * 0.8,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: name,
                        cursorColor: Colors.black,
                        maxLines: 1,
                        decoration: InputDecoration(
                            errorText: namest ? nameerror : null,
                            isDense: true,
                            prefixIcon: Icon(
                              Icons.person,
                              size: 25,
                              color: Colors.purple[900],
                            ),
                            hintText: "Name",
                            fillColor: Colors.grey[300],
                            filled: true,
                            errorBorder: modal.errorborder,
                            focusedErrorBorder: modal.errorborder,
                            focusedBorder: modal.focusandenable,
                            enabledBorder: modal.focusandenable),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: twidth * 0.8,
                      child: TextField(
                        controller: dob,
                        maxLines: 1,
                        keyboardType: TextInputType.datetime,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          errorText: dobst ? doberror : null,
                          isDense: true,
                          prefixIcon: IconButton(
                              onPressed: () {
                                selectDate(context);
                              },
                              icon: Icon(
                                Icons.date_range,
                                color: Colors.purple[900],
                              )),
                          hintText: "DOB : DD-MM-YYYY",
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
                      height: 100,
                      width: twidth * 0.8,
                      margin: const EdgeInsets.only(bottom: 30),
                      child: TextField(
                        controller: address,
                        maxLines: 5,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: "Enter address (Optional)",
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
                            EasyLoading.show(status: "Please wait");

                            String name1 = name.text;
                            String dob1 = dob.text;
                            String address1 = address.text;
                            String imagestring = "";
                            if (imagepath.isNotEmpty) {
                              List<int> imagearray =
                                  File(imagepath).readAsBytesSync();
                              imagestring = base64Encode(imagearray);
                            }

                            Map map = {
                              "name": name1,
                              "dob": dob1,
                              "address": address1,
                              "password": modal.addpass,
                              "contact": modal.addcontact,
                              "email": modal.addemail,
                              "photo": imagepath.isNotEmpty ? imagestring : ''
                            };

                            var url = Uri.parse(
                                'https://easyshopping1344.000webhostapp.com/apicalling/dataadd.php');
                            var response = await http.post(url, body: map);
                            print('Response status: ${response.statusCode}');
                            print('Response body: ${response.body}');

                            var data = await jsonDecode(response.body);
                            dataresult dd = dataresult.fromJson(data);

                            if (await dd.result == 1) {
                              EasyLoading.dismiss(animation: false);
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Lottie.asset(
                                          "assets/104368-thank-you.json"),
                                    );
                                  });
                              Future.delayed(const Duration(seconds: 3))
                                  .then((value) {
                                Navigator.pop(context);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return login();
                                  },
                                ));
                              });
                            }
                          },
                          child: const Text(
                            "SUBMIT",
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

   void showimagedailog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Please choose an option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);

                      if (image != null) {
                        Navigator.pop(context);
                        Cropimage(image);
                      }
                    },
                    child: Container(
                      height: 80,
                      width: 100,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                              image: AssetImage("assets/gallerycontent.png"))),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.camera);

                      if (image != null) {
                        Navigator.pop(context);
                        Cropimage(image);
                      }
                    },
                    child: Container(
                      height: 80,
                      width: 100,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                              image: AssetImage("assets/camera.jpg"),
                              fit: BoxFit.cover)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future Cropimage(XFile image) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.purple[900],
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    setState(() {
      imagepath = croppedFile!.path;
    });
  }

  ImageProvider getimage() {
    if (imagepath.isEmpty) {
      return const AssetImage("assets/profile_icon.jfif");
    } else {
      return FileImage(File(imagepath));
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        currentDate: selectedDate,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dob.text =
            "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
      });
    }
  }
}

class dataresult {
  int? connection;
  int? result;

  dataresult({this.connection, this.result});

  dataresult.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connection'] = this.connection;
    data['result'] = this.result;
    return data;
  }
}
