import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class photoview extends StatefulWidget {
  String photos;

  photoview(this.photos);

  @override
  State<photoview> createState() => _photoviewState();
}

class _photoviewState extends State<photoview> {
  PageController page = PageController();
  bool pagingenabled = true;
  PhotoViewController _transformationController = PhotoViewController();

  @override
  Widget build(BuildContext context) {
    double twidth = MediaQuery.of(context).size.width;
    double stbar = MediaQuery.of(context).padding.top;
    double navigation = MediaQuery.of(context).padding.bottom;
    double theight = MediaQuery.of(context).size.height;
    double bodyheight = theight - stbar - navigation;
    return Scaffold(
      body: PageView.builder(
        physics: pagingenabled
            ? PageScrollPhysics()
            : NeverScrollableScrollPhysics(),
        onPageChanged: (value) {
          setState(() {
            page = PageController(initialPage: value);
          });
        },
        itemCount: widget.photos.split(",").length,
        itemBuilder: (context, index) {
          return Container(
            height: bodyheight,
            width: twidth,
            child: PhotoView(
              minScale: PhotoViewComputedScale.contained * 1,
              backgroundDecoration: BoxDecoration(color: Colors.white),
              imageProvider: NetworkImage(
                "https://easyshopping1344.000webhostapp.com/apicalling/${widget.photos.split(",")[index]}",
              ),
            ),
          );
        },
      ),
    );
  }
}
