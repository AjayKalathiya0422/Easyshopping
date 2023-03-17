import 'dart:convert';

import 'package:easyshopping/homepage/addproduct.dart';
import 'package:easyshopping/loginpage.dart';
import 'package:easyshopping/modalclass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import '../userproductview/myuploadedproduct.dart';
import '../userproductview/productview.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  String imagee = "";
  String namee = "";

  List<Details> productdata = [];

  TextStyle drawertext = TextStyle(fontWeight: FontWeight.bold);
  Color drawercolor = Colors.black54;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      imagee = modal.preference!.getString("profilephoto") ?? "";
      namee = modal.preference!.getString('name') ?? "";

      viewproduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    double twidth = MediaQuery.of(context).size.width;
    double stbar = MediaQuery.of(context).padding.top;
    double navigation = MediaQuery.of(context).padding.bottom;
    double theight = MediaQuery.of(context).size.height;
    double bodyheight = theight - stbar - navigation - kToolbarHeight;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple[900],
        title: Text("easy-Shopping"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.purple[900],
                    image: DecorationImage(
                        image: AssetImage("assets/profile_drawer1.jpeg"),
                        fit: BoxFit.fill)),
                currentAccountPicture:
                    CircleAvatar(backgroundImage: profiledp(imagee)),
                accountName: Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text("Hello, ${namee}")),
                accountEmail: null),
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.person,
                          color: drawercolor,
                        ),
                        title: Text(
                          'Profile',
                          style: drawertext,
                        )),
                    ListTile(
                        onTap: () {
                          EasyLoading.show(status: "Please wait");
                          Future.delayed(Duration(seconds: 2)).then((value) {
                            EasyLoading.dismiss(animation: false);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return addproduct();
                              },
                            ));
                          });
                        },
                        leading: Icon(
                          Icons.add_business_sharp,
                          color: drawercolor,
                        ),
                        title: Text(
                          'Bussiness with easy-shopping',
                          style: drawertext,
                        )),
                    ListTile(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return uploadedproduct();
                            },
                          ));
                        },
                        leading: Icon(
                          Icons.shopping_basket,
                          color: drawercolor,
                        ),
                        title: Text(
                          'My Upload product',
                          style: drawertext,
                        )),
                    ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.shopping_cart,
                          color: drawercolor,
                        ),
                        title: Text(
                          'My Cart',
                          style: drawertext,
                        )),
                    ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.favorite,
                          color: drawercolor,
                        ),
                        title: Text(
                          'My Wishlist',
                          style: drawertext,
                        )),
                  ],
                ),
              ),
            ),
            Container(
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                        child: Column(
                      children: <Widget>[
                        Divider(
                          thickness: 2,
                        ),
                        ListTile(
                            onTap: () {
                              modal.preference!.setBool("loginst", false);
                              EasyLoading.show(status: "Please wait");
                              Future.delayed(Duration(seconds: 2))
                                  .then((value) {
                                EasyLoading.showSuccess("Logout successfull");
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return login();
                                  },
                                ));
                              });
                            },
                            leading: Icon(
                              Icons.logout,
                              color: drawercolor,
                            ),
                            title: Text(
                              'Logout',
                              style: drawertext,
                            )),
                        ListTile(
                            onTap: () {},
                            leading: Icon(
                              Icons.help,
                              color: drawercolor,
                            ),
                            title: Text(
                              'Help and Feedback',
                              style: drawertext,
                            ))
                      ],
                    ))))
          ],
        ),
      ),
      body: SizedBox(
        height: bodyheight,
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: productdata.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, childAspectRatio: 2.5),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return productview(productdata[index]);
                  },
                ));
              },
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
                                  "https://easyshopping1344.000webhostapp.com/apicalling/${productdata[index].photos.split(",")[0]}"))),
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            productdata[index].name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                productdata[index].description,
                                maxLines: 1,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    productdata[index].actualprice,
                                    style: TextStyle(
                                        decoration:
                                            TextDecoration.lineThrough),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "₹ ${productdata[index].sellprice}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "${persontage(index)} %",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
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
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> viewproduct() async {
    var url = Uri.parse(
        'https://easyshopping1344.000webhostapp.com/apicalling/viewproduct.php');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var viewproductdata = await jsonDecode(response.body);

    Autogenerated aaa = await Autogenerated.fromJson(viewproductdata);

    setState(() {
      productdata = aaa.details!;
    });
  }

  String persontage(int index) {
    double pr = 100 -
        (double.parse(productdata[index].sellprice) *
            100 /
            double.parse(productdata[index].actualprice));
    return pr.toStringAsFixed(2);
  }
}

ImageProvider profiledp(String imagee) {
  if (imagee == "dp not set") {
    return AssetImage("assets/profile_icon.jfif");
  } else {
    return NetworkImage(
        "https://easyshopping1344.000webhostapp.com/apicalling/$imagee");
  }
}

class Autogenerated {
  int? connection;
  int? result;
  List<Details>? details;

  Autogenerated({this.connection, this.result, this.details});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connection'] = this.connection;
    data['result'] = this.result;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String id = "";
  String userid = "";
  String name = "";
  String catagory = "";
  String description = "";
  String actualprice = "";
  String sellprice = "";
  String warranty = "";
  String warrantycondition = "";
  String refund = "";
  String photos = "";

  Details(
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
      this.photos);

  Details.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    userid = json['Userid'];
    name = json['Name'];
    catagory = json['Catagory'];
    description = json['Description'];
    actualprice = json['Actualprice'];
    sellprice = json['Sellprice'];
    warranty = json['Warranty'];
    warrantycondition = json['Warrantycondition'];
    refund = json['Refund'];
    photos = json['Photos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Userid'] = this.userid;
    data['Name'] = this.name;
    data['Catagory'] = this.catagory;
    data['Description'] = this.description;
    data['Actualprice'] = this.actualprice;
    data['Sellprice'] = this.sellprice;
    data['Warranty'] = this.warranty;
    data['Warrantycondition'] = this.warrantycondition;
    data['Refund'] = this.refund;
    data['Photos'] = this.photos;
    return data;
  }
}
