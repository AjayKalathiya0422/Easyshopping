import 'package:easyshopping/homepage/homepage.dart';
import 'package:easyshopping/modalclass.dart';
import 'package:easyshopping/userproductview/photoview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class productview extends StatefulWidget {
  Details productdata;

  productview(Details this.productdata);

  @override
  State<productview> createState() => _productviewState();
}

class _productviewState extends State<productview> {

  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;

  PageController page = PageController();
  String pr = "";
  String? number;
  String? email;
  bool maxlines = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      number = modal.preference!.getString('phone') ?? "";
      email = modal.preference!.getString('email') ?? "";
      double num = 100 -
          (double.parse(widget.productdata.sellprice) *
              100 /
              double.parse(widget.productdata.actualprice));

      pr = num.toStringAsFixed(2);
    });
    payment();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {

    var options = {
      'key': 'rzp_test_HloySgyCd4zNVM',
      'amount': double.parse(widget.productdata.sellprice) * 100,
      'name': '${widget.productdata.name}',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '$number', 'email': '$email'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    /*Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    /* Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
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
        body: Column(
          children: [
            Expanded(
              child: Container(
                height: bodyheight,
                width: twidth,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: bodyheight * 0.5,
                          width: twidth,
                          child: PageView.builder(
                            onPageChanged: (value) {
                              setState(() {
                                page = PageController(initialPage: value);
                              });
                            },
                            itemCount:
                                widget.productdata.photos.split(",").length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return photoview(
                                          widget.productdata.photos);
                                    },
                                  ));
                                },
                                child: SizedBox(
                                  height: bodyheight * 0.5,
                                  width: twidth,
                                  child: Image.network(
                                    "https://easyshopping1344.000webhostapp.com/apicalling/${widget.productdata.photos.split(",")[index]}",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              IconButton(
                                  onPressed: () {},
                                  icon: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.share,
                                      color: Colors.black45,
                                    ),
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.favorite_border,
                                      color: Colors.black45,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: SmoothPageIndicator(
                        controller: page,
                        count: widget.productdata.photos.split(",").length,
                        effect: SwapEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          type: SwapType.yRotation,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.productdata.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          widget.productdata.actualprice,
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 17),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "₹ ${widget.productdata.sellprice}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 17),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "$pr %",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 17),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(
                      "About product :",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Text(
                            " \n${widget.productdata.description}",
                            maxLines: maxlines ? 4 : null,
                            style: TextStyle(
                                fontSize: 17, color: Colors.grey.shade700),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (maxlines) {
                                      maxlines = false;
                                    } else {
                                      maxlines = true;
                                    }
                                  });
                                },
                                child: Text(
                                  maxlines ? "more ..." : "less ...",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                          )
                        ],
                      ),
                    ),
                    Text(
                      "Product Description :",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: detailsform(),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Add to Cart",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: openCheckout,
                    child: Container(
                      height: 55,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Text(
                        "BUY NOW",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  detailsform() {
    List<String> columnfields = [
      "Name",
      "Description",
      "Catagory",
      "Product Price",
      "Warranty",
      "Warranty condtion",
      "Refund policy"
    ];
    List<String> columndetails = [
      widget.productdata.name,
      widget.productdata.description,
      widget.productdata.catagory,
      widget.productdata.sellprice,
      widget.productdata.warranty,
      widget.productdata.warrantycondition,
      widget.productdata.refund
    ];

    List<Widget> mm = [];
    for (int i = 0; i < columnfields.length; i++) {
      mm.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text("${columnfields[i]} :")),
          Expanded(
              child: Text(
            columndetails[i].isEmpty ? "-" : columndetails[i],
            style: TextStyle(color: Colors.grey.shade700),
          )),
        ],
      ));
      mm.add(SizedBox(
        height: 20,
      ));
    }
    return mm;
  }

  void payment() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
}
