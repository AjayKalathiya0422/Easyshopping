import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easyshopping/homepage/homepage.dart';
import 'package:easyshopping/modalclass.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class addproduct extends StatefulWidget {
  const addproduct({Key? key}) : super(key: key);

  @override
  State<addproduct> createState() => _addproductState();
}

class _addproductState extends State<addproduct> {
  final ImagePicker _picker = ImagePicker();

  int currentstep = 0;
  String? selectedvalue;
  String? selectedwarranty;
  String? refund;
  bool dataadd = true;

  TextEditingController pname = TextEditingController();
  TextEditingController pdescription = TextEditingController();
  TextEditingController actualprice = TextEditingController();
  TextEditingController sellprice = TextEditingController();
  TextEditingController warrantycondition = TextEditingController();

   List addphoto = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double twidth = MediaQuery.of(context).size.width;
    double stbar = MediaQuery.of(context).padding.top;
    double navigation = MediaQuery.of(context).padding.bottom;
    double theight = MediaQuery.of(context).size.height;
    double bodyheight = theight - stbar - navigation - kToolbarHeight;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.purple[900],
          title: Text("Upload products"),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(primary: Colors.purple.shade500)),
          child: Stepper(
              currentStep: currentstep,
              controlsBuilder: (context, details) {
                return Row(
                  children: [
                    if (currentstep != 0)
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (currentstep != 0) {
                                currentstep--;
                              }
                            });
                          },
                          child: Text("Back")),
                    Spacer(),
                    ElevatedButton(
                        onPressed: () async {
                          if (currentstep == 1) {
                            EasyLoading.show(status: "Please wait");

                            var imagestring = [];

                            for (int i = 0; i < addphoto.length; i++) {
                              List<int> imagearray =
                                  File(addphoto[i]).readAsBytesSync();
                              imagestring.add(base64Encode(imagearray));
                            }

                            String nn = modal.preference!.getString("id") ?? "";

                            var map = {
                              "userid": nn,
                              "name": pname.text,
                              "catagory": selectedvalue,
                              "description": pdescription.text,
                              "actualprice": actualprice.text,
                              "sellprice": sellprice.text,
                              "warranty": selectedwarranty,
                              "wcondition": warrantycondition.text,
                              "refund": refund,
                              "photos": imagestring.toString(),
                              "length": addphoto.length.toString()
                            };

                            print(map);
                            print("*****${imagestring.length}");

                            var url = Uri.parse(
                                'https://easyshopping1344.000webhostapp.com/apicalling/productadd.php');
                            var response = await http.post(url, body: map);
                            print('Response status: ${response.statusCode}');
                            print('Response body: ${response.body}');

                            var data = jsonDecode(response.body);

                            datacode dd =  datacode.fromJson(data);

                            if (dd.connection == 1) {
                              if (dd.result == 1) {
                                EasyLoading.dismiss(animation: false);
                                EasyLoading.showSuccess("Upload sucessfully");
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return homepage();
                                  },
                                ));
                              }
                            }
                          } else if (currentstep != 1) {
                            setState(() {
                              currentstep++;
                            });
                          }
                        },
                        child: Text(currentstep == 1 ? "Complete" : "Next")),
                  ],
                );
              },
              type: StepperType.horizontal,
              steps: getsteps(bodyheight, twidth)),
        ),
      ),
    );
  }

  List<Step> getsteps(double bodyheight, double twidth) => [
        Step(
          state: currentstep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentstep >= 0,
          title: Image.asset(
            "assets/upload.jpg",
            height: 50,
            width: 50,
          ),
          content: Container(
            height: 900,
            width: twidth,
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      "Add product details",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text("Enter your products details here"),
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      height: 320,
                      width: twidth,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add product images",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            "Add upto 5 images. First image is your product's cover image that will be highlighted everywhere",
                          ),
                          Container(
                            height: 250,
                            width: twidth,
                            margin: EdgeInsets.only(top: 10),
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: addphoto.length != 5
                                  ? addphoto.length + 1
                                  : addphoto.length,
                              itemBuilder: (context, index) {
                                return index == addphoto.length && index <= 4
                                    ? InkWell(
                                        onTap: () {
                                          showimagedailog(context);
                                        },
                                        child: DottedBorder(
                                          color: Colors.black,
                                          strokeWidth: 1,
                                          child: Container(
                                              height: 100,
                                              width: 110,
                                              child: Icon(
                                                Icons.add,
                                                size: 30,
                                              )),
                                        ),
                                      )
                                    : Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Image.file(
                                            File(addphoto[index]),
                                            height: 100,
                                            width: 110,
                                          ),
                                          Theme(
                                            data: Theme.of(context).copyWith(
                                              highlightColor:
                                                  Colors.transparent,
                                              splashColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                            ),
                                            child: IconButton(
                                                alignment: Alignment.topRight,
                                                onPressed: () {
                                                  setState(() {
                                                    addphoto.removeAt(index);
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 20,
                                                )),
                                          )
                                        ],
                                      );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: 100,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 10,
                                      crossAxisCount: 3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 480,
                  width: twidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter product details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text("Select product category")),
                      DropdownButtonFormField2(
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        isExpanded: true,
                        hint: Text(
                          'Select your product catagories',
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                        buttonHeight: 50,
                        buttonPadding: EdgeInsets.only(left: 20, right: 10),
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        items: modal.catagorieslist
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select catagories.';
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            selectedvalue = value.toString();
                          });
                        },
                        onSaved: (value) {
                          selectedvalue = value.toString();
                        },
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text("product name")),
                      Container(
                        height: 50,
                        width: twidth,
                        child: TextField(
                          controller: pname,
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Enter product name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text("Product description")),
                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: TextField(
                          controller: pdescription,
                          maxLines: 10,
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Enter description here',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: currentstep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentstep >= 1,
          title: Image.asset(
            "assets/setproductprice.png",
            height: 30,
            width: 30,
          ),
          content: Container(
            height: 400,
            width: twidth,
            child: Column(
              children: [
                Text(
                  "Set product price",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text("Enter your products price here"),
                Container(
                    margin: EdgeInsets.only(top: 50, bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                            width: twidth * 0.4, child: Text("Product price")),
                        Spacer(),
                        SizedBox(
                            width: twidth * 0.4,
                            child: Text("Product sell price")),
                      ],
                    )),
                Container(
                  height: 50,
                  width: twidth,
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: twidth * 0.4,
                        child: TextField(
                          controller: actualprice,
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: 'product real price',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 50,
                        width: twidth * 0.4,
                        child: TextField(
                          controller: sellprice,
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: 'product sell price',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                            width: twidth * 0.4,
                            child: Text("Product warranty")),
                        Spacer(),
                        if (selectedwarranty == 'Yes')
                          SizedBox(
                              width: twidth * 0.4,
                              child: Text("Warranty condition")),
                      ],
                    )),
                Container(
                  height: 50,
                  width: twidth,
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: twidth * 0.4,
                        child: DropdownButtonFormField2(
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          isExpanded: true,
                          hint: Text(
                            'Warranty available',
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 30,
                          buttonHeight: 50,
                          buttonPadding: EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          items: modal.warranty
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select warranty.';
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              selectedwarranty = value.toString();
                            });
                          },
                          onSaved: (value) {
                            selectedwarranty = value.toString();
                          },
                        ),
                      ),
                      Spacer(),
                      if (selectedwarranty == 'Yes')
                        Container(
                          height: 50,
                          width: twidth * 0.4,
                          child: TextField(
                            controller: warrantycondition,
                            decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Warranty condition',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text("Product refund policy ?"),
                        Radio(
                          fillColor:
                              MaterialStateProperty.all(Colors.purple[900]),
                          value: "yes",
                          groupValue: refund,
                          onChanged: (value) {
                            setState(() {
                              refund = value.toString();
                            });
                          },
                        ),
                        Text("Yes"),
                        Radio(
                          fillColor:
                              MaterialStateProperty.all(Colors.purple[900]),
                          value: "no",
                          groupValue: refund,
                          onChanged: (value) {
                            setState(() {
                              refund = value.toString();
                            });
                          },
                        ),
                        Text("No")
                      ],
                    )),
              ],
            ),
          ),
        ),
      ];

  void showimagedailog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Please choose an option"),
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
                      decoration: BoxDecoration(
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
                      decoration: BoxDecoration(
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
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
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
      addphoto.add(croppedFile!.path);
    });
  }
}

class datacode {
  int? connection;
  int? result;

  datacode({this.connection, this.result});

  datacode.fromJson(Map<String, dynamic> json) {
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
