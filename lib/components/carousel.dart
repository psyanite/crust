import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<String> images;

  Carousel({
    this.images,
  }) : assert(images != null);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  PageController _controller = new PageController();

  @override
  void dispose() {
    _controller.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width - 30.0,
          child: _gallery(),
        ),
        Dots(controller: _controller, itemCount: widget.images.length)
      ],
    );
  }

  Widget _gallery() {
    final List<Widget> listImages = widget.images
        .map<Widget>((image) => Container(
            decoration: BoxDecoration(
                image: new DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ))))
        .toList();
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Container(
          child: PageView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _controller,
            children: listImages,
          ),
        ),
      ],
    );
  }
}

class Dots extends AnimatedWidget {
  final PageController controller;
  final int itemCount;

  Dots({this.controller, this.itemCount}) : super(listenable: controller);

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double size = 6.0 * (1.0 + 0.1 * selectedness);
    Color color = selectedness > 0.5 ? Colors.orange[200] : Colors.orange[100];
    return Container(
      height: 20.0,
      width: 10.0,
      child: Center(
        child: Material(
          color: color,
          type: MaterialType.circle,
          child: Container(
            height: size,
          ),
        ),
      ),
    );
  }
}
