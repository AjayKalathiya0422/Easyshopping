import 'dart:convert';

import 'package:easyshopping/homepage/homepage.dart';
import 'package:easyshopping/modalclass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

import '../homepage/updateproduct.dart';

class uploadedproduct extends StatefulWidget {
  const uploadedproduct({Key? key}) : super(key: key);

  @override
  State<uploadedproduct> createState() => _uploadedproductState();
}

class _uploadedproductState extends State<uploadedproduct> {
  bool emptyproduct = false;

  List<Detail> product = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkuploaddata();
  }

  @override
  Widget build(BuildContext context) {
    double twidth = MediaQuery.of(context).size.width;
    double stbar = MediaQuery.of(context).padding.top;
    double navigation = MediaQuery.of(context).padding.bottom;
    double theight = MediaQuery.of(context).size.height;
    double bodyheight = theight - stbar - navigation - kToolbarHeight;
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.purple[900],
          title: Text("Uploaded Products"),
        ),
        body: emptyproduct
            ? Center(child: Text("Upload Empty"))
            : Column(
                children: [
                  SizedBox(
                    height: bodyheight,
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: product.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1, childAspectRatio: 2.5),
                      itemBuilder: (context, index) {
                        return Slidable(
                            endActionPane:
                                ActionPane(motion: ScrollMotion(), children: [
                              SlidableAction(
                                onPressed: (context) {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return updateproduct(product[index]);
                                    },
                                  ));
                                },
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                icon: Icons.archive,
                                label: 'Update',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Are you sure delete?"),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                EasyLoading.show();
                                                Map map = {
                                                  'id': product[index].id
                                                };
                                                var url = Uri.parse(
                                                    'https://easyshopping1344.000webhostapp.com/apicalling/deleteproduct.php');

                                                var response = await http
                                                    .post(url, body: map);
                                                print(
                                                    'Response status: ${response.statusCode}');
                                                print(
                                                    'Response body: ${response.body}');

                                                var mm =
                                                    jsonDecode(response.body);

                                                if (await mm['result'] == 1) {
                                                  EasyLoading.dismiss(
                                                      animation: false);
                                                  Navigator.pop(context);
                                                  EasyLoading.showSuccess(
                                                      "Delete successfully");
                                                  setState(() {
                                                    checkuploaddata();
                                                  });
                                                }
                                              },
                                              child: Text("Yes")),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("No")),
                                        ],
                                      );
                                    },
                                  );
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.save,
                                label: 'Delete',
                              ),
                            ]),
                            child: Card(
                              elevation: 10,
                              margin: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://easyshopping1344.000webhostapp.com/apicalling/${product[index].photos.split(",")[0]}"))),
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: Text(
                                          product[index].name,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              product[index].description,
                                              maxLines: 1,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  product[index].actualprice,
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "₹ ${product[index].sellprice}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "${persontage(index)} %",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                ],
              ),
      ),
      onWillPop: () {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return homepage();
          },
        ));
        return Future.value();
      },
    );
  }

  Future<void> checkuploaddata() async {
    var url = Uri.parse(
        'https://easyshopping1344.000webhostapp.com/apicalling/uploadedproduct.php');

    String id = modal.preference!.getString('id') ?? "";

    print("-------------$id");
    Map map = {'id': id};

    var response = await http.post(url, body: map);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var viewproductdata = jsonDecode(response.body);

    Uploadeddata aaa = Uploadeddata.fromJson(viewproductdata);

    setState(() {
      if (aaa.details.isNotEmpty) {
        product = aaa.details;
      } else {
        emptyproduct = true;
      }
    });
  }

  String persontage(int index) {
    double pr = 100 -
        (double.parse(product[index].sellprice) *
            100 /
            double.parse(product[index].actualprice));
    return pr.toStringAsFixed(2);
  }
}

class Uploadeddata {
  Uploadeddata(
    this.connection,
    this.result,
    this.details,
  );

  int connection;
  int result;
  List<Detail> details;

  factory Uploadeddata.fromJson(Map<String, dynamic> json) => Uploadeddata(
        json["connection"],
        json["result"],
        List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "connection": connection,
        "result": result,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class Detail {
  Detail(
    this.id,
    this.userid,
    this.name,
    this.catagory,
    this.description,
    this.actualprice,
    this.sellprice,
    this.warranty,
    this.warrantycondition,
    this.refund,
    this.photos,
  );

  String id;
  String userid;
  String name;
  String catagory;
  String description;
  String actualprice;
  String sellprice;
  String warranty;
  String warrantycondition;
  String refund;
  String photos;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        json["Id"],
        json["Userid"],
        json["Name"],
        json["Catagory"],
        json["Description"],
        json["Actualprice"],
        json["Sellprice"],
        json["Warranty"],
        json["Warrantycondition"],
        json["Refund"],
        json["Photos"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Userid": userid,
        "Name": name,
        "Catagory": catagory,
        "Description": description,
        "Actualprice": actualprice,
        "Sellprice": sellprice,
        "Warranty": warranty,
        "Warrantycondition": warrantycondition,
        "Refund": refund,
        "Photos": photos,
      };
}
